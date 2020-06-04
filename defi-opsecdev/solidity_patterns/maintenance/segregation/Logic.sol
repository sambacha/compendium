pragma solidity ^0.4.17;
import "./DataStorage.sol";
contract Logic {
  DataStorage dataStorage;
    
  function Logic(address _address) public {
    dataStorage = DataStorage(_address);
  }

  function f() public {
    bytes32 key = keccak256("emergency");
    dataStorage.setUintValue(key, 911);
    dataStorage.getUintValue(key);
  }
}