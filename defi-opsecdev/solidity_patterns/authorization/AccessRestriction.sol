pragma solidity ^0.4.17;
import "./Ownership.sol";
contract AccessRestriction is Owned {
  uint public creationTime = now;
  
  modifier onlyBefore(uint _time) { 
    require(now < _time); _; 
  }
  
  modifier onlyAfter(uint _time) { 
    require(now > _time); _; 
  }
  
  modifier onlyBy(address account) { 
    require(msg.sender == account);  _; 
  }
  
  modifier condition(bool _condition) { 
    require(_condition); _; 
  }
  
  modifier minAmount(uint _amount) { 
    require(msg.value >= _amount); _; 
  }

  function f() payable onlyAfter(creationTime + 1 minutes) onlyBy(owner) minAmount(2 ether) condition(msg.sender.balance >= 50 ether) {
    // some code
  }
}