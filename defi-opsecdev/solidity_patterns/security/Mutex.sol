pragma solidity ^0.4.17;
contract Mutex {
  bool locked;
	
  modifier noReentrancy() {
    require(!locked);
    locked = true;
    _;
    locked = false;
  }

  // f is protected by a mutex, thus reentrant calls
  // from within msg.sender.call cannot call f again
  function f() noReentrancy public returns (uint) {
    require(msg.sender.call());
    return 1;
  }
}