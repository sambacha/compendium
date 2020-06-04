pragma solidity ^0.4.17;
import "../authorization/Ownership.sol";
contract Register is Owned {
  address backendContract;
  address[] previousBackends;

  function Register() public {
    owner = msg.sender;
  }

  function changeBackend(address newBackend) public onlyOwner() returns (bool) {
    if(newBackend != backendContract) {
      previousBackends.push(backendContract);
      backendContract = newBackend;
      return true;
    }
    return false;
  }
}