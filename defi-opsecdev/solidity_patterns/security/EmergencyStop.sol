pragma solidity ^0.4.17;
import "../authorization/Ownership.sol";
contract EmergencyStop is Owned {
  bool public contractStopped = false;

  modifier haltInEmergency { 
    if (!contractStopped) _;
  }
  
  modifier enableInEmergency { 
    if (contractStopped) _;
  }

  function toggleContractStopped() public onlyOwner {
    contractStopped = !contractStopped;
  }

  function deposit() public payable haltInEmergency {
    // some code
  }

  function withdraw() public view enableInEmergency {
    // some code
  }
}

