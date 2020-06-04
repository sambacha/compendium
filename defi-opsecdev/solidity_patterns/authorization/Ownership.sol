pragma solidity ^0.4.17;
contract Owned {
  address public owner;

  event LogOwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
  function Owned() public {  
    owner = msg.sender; 
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    LogOwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}