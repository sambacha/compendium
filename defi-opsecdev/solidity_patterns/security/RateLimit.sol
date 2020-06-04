pragma solidity ^0.4.17;
contract RateLimit {
  uint enabledAt = now;
    
  modifier enabledEvery(uint t) {
    if (now >= enabledAt) {
      enabledAt = now + t;
      _;      
    }
  }
  
  function f() public enabledEvery(1 minutes) {
    // some code
  }
}