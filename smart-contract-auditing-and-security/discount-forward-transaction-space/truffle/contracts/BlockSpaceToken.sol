pragma solidity ^0.4.23;

//import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract BlockSpaceToken is ERC721Token {
  
  using SafeMath for uint;
  
    /* 
        - Miners is currently the issuer and offerer
        - Taker is the owner of the NFT
        - Taker pays the miner for the NFT
    */
  
    struct Derivative {
        uint lower;
        uint upper;
        uint gasLimit; // refers to the amount of gas in a block
        address offerer;
        uint bond;
        bool settled;
        bytes executionMessage; // what function to call when the miner settles the contract
        address executionAddress; // the address of the smart contract to call
    }

    event DerivativeCreated(uint indexed id, uint lower, uint upper, uint gasLimit, uint bond, address indexed offerer);
    event DerivativeSettled(uint indexed id, address indexed maker, address indexed taker, bool executed);
    event BondClaimed(uint indexed id, address indexed taker, uint bond);
    event DerivativeCanceled(uint indexed id, address indexed offerer, uint gasLimit, uint bond);
        
    mapping (uint => Derivative) public derivativeData;
    
    constructor() ERC721Token("BlockSpaceToken","SPACE") public { }

    // Miners are the issuers and must set the bond when they create the contract
    function mint(uint _lower, uint _upper, uint _gasLimit) public payable returns (uint)  {
    
        require(_lower < _upper);
        require(_lower > block.number);
        
        uint id = totalSupply();
        address _offerer = msg.sender;
        uint _bond = msg.value;
        derivativeData[id] = Derivative(_lower, _upper, _gasLimit, _offerer, _bond, false, "", address(0x0)); 
        
        emit DerivativeCreated(id, _lower, _upper, _gasLimit, _bond, _offerer);
        
        _mint(msg.sender, id);
        
        return id;
    }

    // Trading the miners / offerer
    function transferOfferer(uint _id, address _offerer) public {
        // Need to have the existing offerer allow another agent to take over it
        // Can copy pattern `safeTransferFrom`
        require(_id < totalSupply());
        Derivative storage d = derivativeData[_id];
        require(msg.sender == d.offerer);
        d.offerer = _offerer;
    }

    // Note bond can only be increased, not decreased in current implimentation
    // No access controls anyone can increase the bond amount
    function increaseBond(uint _id) public payable {
        derivativeData[_id].bond += msg.value;
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

        require(msg.sender == d.offerer);
        assert(gasleft() > d.gasLimit);

        address newAddress = d.executionAddress;
        bool executed = newAddress.call.gas(d.gasLimit)(d.executionMessage);

        if (executed) {
            d.offerer.transfer(d.bond);
            d.settled = true;
        }

        emit DerivativeSettled(_id, d.offerer, ownerOf(_id), executed);

        return executed;
    }

    // If the miner / offerer does not execute and the block height has passed
    // -> then the taker can claim the bond
    function reclaim(uint _id) public {
        require(_id < totalSupply());
        Derivative storage d = derivativeData[_id];
        
        if (d.upper < block.number) {
            ownerOf(_id).transfer(d.bond); // is using `ownerOf(_id)` more efficient?
            d.settled = true;

            emit BondClaimed(_id, ownerOf(_id), d.bond);
        }
    }

    // Should follow the chicago style futures model for cancelling
    function cancel(uint _id) public {
        require(_id < totalSupply());
        Derivative storage d = derivativeData[_id];
        require(msg.sender == d.offerer);
        require(ownerOf(_id) != address(0));
        require(!d.settled);
        d.settled = true;
        d.offerer.transfer(d.bond);

        emit DerivativeCanceled(_id, d.offerer, d.gasLimit, d.bond);
    }
  
}