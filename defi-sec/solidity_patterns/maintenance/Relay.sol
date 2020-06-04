pragma solidity ^0.4.17;
import "../authorization/Ownership.sol";
contract Relay is Owned {
  address public currentVersion;

  function Relay(address initAddr) public {
    currentVersion = initAddr;
    owner = msg.sender;
  }
  
  function changeContract(address newVersion) public onlyOwner() {
    currentVersion = newVersion;
  }
  
  // fallback function
  function() public {
    require(currentVersion.delegatecall(msg.data));
  }
}