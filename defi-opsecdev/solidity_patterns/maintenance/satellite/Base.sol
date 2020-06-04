pragma solidity ^0.4.17;
import "../../authorization/Ownership.sol";
import "./Satellite.sol";
contract Base is Owned {
  uint public variable;
  address satelliteAddress;

  function setVariable() public onlyOwner {
    Satellite s = Satellite(satelliteAddress);
    variable = s.calculateVariable();
  }

  function updateSatelliteAddress(address _address) public onlyOwner {
    satelliteAddress = _address;
  }
}