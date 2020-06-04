pragma solidity ^0.4.17;
contract DataStorage {
  mapping(bytes32 => uint) uintStorage;
  mapping(bytes32 => int) intStorage;
  mapping(bytes32 => string) stringStorage;
  mapping(bytes32 => address) addressStorage;
  mapping(bytes32 => bool) booleanStorage;
  mapping(bytes32 => bytes) bytesStorage;

  function getIntValue(bytes32 key) public constant returns (int) {
    return intStorage[key];
  }

  function setIntValue(bytes32 key, int value) public {
    intStorage[key] = value;
  }
   
  function getUintValue(bytes32 key) public constant returns (uint) {
    return uintStorage[key];
  }

  function setUintValue(bytes32 key, uint value) public {
    uintStorage[key] = value;
  }

  function getStringValue(bytes32 key) public constant returns (string) {
    return stringStorage[key];
  }

  function setStringValue(bytes32 key, string value) public {
    stringStorage[key] = value;
  }

  function getAddressValue(bytes32 key) public constant returns (address) {
    return addressStorage[key];
  }

  function setAddressValue(bytes32 key, address value) public {
    addressStorage[key] = value;
  }
    
  function getBytesValue(bytes32 key) public constant returns (bytes) {
    return bytesStorage[key];
  }

  function setBytesValue(bytes32 key, bytes value) public {
    bytesStorage[key] = value;
  }

  function getBooleanValue(bytes32 key) public constant returns (bool) {
    return booleanStorage[key];
  }

  function setBooleanValue(bytes32 key, bool value) public {
    booleanStorage[key] = value;
  }
}