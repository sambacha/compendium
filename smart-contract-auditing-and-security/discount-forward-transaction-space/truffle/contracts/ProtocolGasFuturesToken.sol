pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract ProtocolGasFuturesToken is ERC721Token {
  
  using SafeMath for uint;

  /*
    This contract is the inprotocol version of `BlockSpaceToken.sol`
    There is less error checking as the protocol is not susceptible to user error
  */
  
    struct Derivative {
        uint blockCreated;
        uint startHeight;
        uint executeHeight;
        uint gasLimit; // refers to the amount of gas in a block
        uint price; //price of the NFT at the 1st sale
        bytes executionMessage; // what function to call when the miner settles the contract
        address executionAddress; // the address of the smart contract to call
    }

    function getBlockCreated(uint id) public view returns(uint) {
        return derivativeData[id].blockCreated;
    }

    function getStartHeight(uint id) public view returns(uint)  {
        return derivativeData[id].startHeight;
    }
    function getEndHeight(uint id) public view returns(uint)  {
        return derivativeData[id].executeHeight;
    }
    function getGasLimit(uint id) public view returns(uint)  {
        return derivativeData[id].gasLimit;
    }
    function getExecutionAddress(uint id) public view returns(address)  {
        return derivativeData[id].executionAddress;
    }

    event DerivativeCreated(uint indexed id, uint startHeight, uint executeHeight, uint gasLimit);
    event DerivativeSettled(uint indexed id, address indexed miner, address indexed taker, bool executed);
        
    mapping (uint => Derivative) public derivativeData;
    
    constructor() ERC721Token("ProtocolGasFutures","GASF") public { }

    function issue(uint _startHeight, uint _executeHeight, uint _gasLimit) public payable returns (uint)  {
      
      uint id = totalSupply();
      derivativeData[id] = Derivative(block.number, _startHeight, _executeHeight, _gasLimit, 0, "", address(0x0)); 
      
      emit DerivativeCreated(id, _startHeight, _executeHeight, _gasLimit);
      
      _mint(msg.sender, id);
      
      return id;
    }

    function salePrice(uint _id) public payable {
      derivativeData[_id].price += msg.value;
    }

    function setExecutionAddress(uint _id, address _executionAddress) public {
      require(msg.sender == ownerOf(_id));
      derivativeData[_id].executionAddress = _executionAddress;
    }

    function setExecutionMessage(uint _id, bytes _executionMessage) public {
      require(msg.sender == ownerOf(_id));
      derivativeData[_id].executionMessage = _executionMessage;
    }

    function settle(uint _id) public returns (bool) {
      require(_id < totalSupply());
      Derivative storage d = derivativeData[_id];

      // current block miner's address
      address miner = block.coinbase;
      address newAddress = d.executionAddress;
      bool executed = newAddress.call.gas(d.gasLimit)(d.executionMessage);

      if (executed) {
        miner.transfer(d.price);
      }

      emit DerivativeSettled(_id, miner, ownerOf(_id), executed);

      return executed;
    }
}
