pragma solidity ^0.4.17;
contract LimitBalance {
  uint256 public limit;

  function LimitBalance(uint256 value) public {
    limit = value;
  }

  modifier limitedPayable() {
    require(this.balance <= limit);
    _;
  }
  
  function deposit() public payable limitedPayable {
    // some code
  }
}