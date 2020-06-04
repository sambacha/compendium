pragma solidity ^0.4.17;
contract AutoDeprecate {
  uint expires;
  
  function AutoDeprecate(uint _days) public {
    expires = now + _days * 1 days;
  }

  function expired() internal view returns (bool) {
    return now > expires;
  }
  
  modifier willDeprecate() {
    require(!expired()); 
    _;
  }
  
  modifier whenDeprecated() {
    require(expired());
    _;
  }
  
  function deposit() public payable willDeprecate {
    // some code
  }
  
  function withdraw() public view whenDeprecated {
    // some code
  }
}