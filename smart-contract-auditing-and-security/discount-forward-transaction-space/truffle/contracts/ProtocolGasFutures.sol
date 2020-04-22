pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
//import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

import "./ProtocolGasFuturesToken.sol";
import "./Dex.sol";

contract ProtocolGasFutures {
  
  using SafeMath for uint;

  ProtocolGasFuturesToken public token;

  mapping (uint => uint[]) public ids;
  uint public numFuturesIssued = 0;

  Dex dex;

  event CreatedGasFuture(uint indexed id);
  event AuctionResult(uint id, uint price);

  constructor(ProtocolGasFuturesToken _token) public {
    token = _token;  
  }

  function issueToken(uint256 expiry, uint256 gasLimit) internal {
    uint256 id = token.issue(expiry-100, expiry, gasLimit);

    // transfer token to the dex
    token.approve(dex, id);
    dex.depositNFToken(token.name(), id);
    dex.askOrderERC721(token.name(), "ETH", id, 0, 1);
 
    // update internal bookkeeping
    numFuturesIssued++;
    ids[expiry].push(id);
    emit CreatedGasFuture(id);
  }

  
  function issue() public {
    uint height = block.number;
    uint gasLimit = 350000;

    // Assume average block time is 15 seconds
    issueToken(height+5760, gasLimit); // 24 hours
    issueToken(height+40320, gasLimit); // 7 days
    issueToken(height+175200, gasLimit); // 1 month
    issueToken(height+2102400, gasLimit); // 365 days
  }

  function settle() public returns (bool) {
    uint[] ids_to_settle = ids[block.number];
    for (uint i = 0; i < ids_to_settle.length; i++) {
        bool executed = token.settle(ids_to_settle[i]);
        if (!executed)
            return false;
    }

    return true;
  }



  function setDex(Dex _dex) public {
    dex = _dex;
  }

  function runAuction(uint _id) public {

    uint price = dex.settleERC721(token.name(), _id);

    emit AuctionResult(_id, price);

  }

}
