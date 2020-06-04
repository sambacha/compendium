pragma solidity ^0.4.17;
contract AutoDeprecate {
  uint public constant BLOCK_NUMBER = 4400000;
  
  modifier isActive() {
    require(block.number <= BLOCK_NUMBER);
    _;
  }

  function deposit() public isActive() {
    // some code
  }

  function withdraw() public {
    // some code
  }
}