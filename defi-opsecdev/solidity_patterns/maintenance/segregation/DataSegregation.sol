pragma solidity ^0.4.17;
contract DataStore {
  // storage data goes here
  uint public x;
}

contract Consumer {
  address _data;
  DataStore data;
  
  function Consumer(address d) {
      data = DataStore(d); 
      _data = d; 
  }
  
  function get_data() returns (address) { 
      return _data;
  }
}

contract Controller is Consumer {
    
  function Controller(address d) Consumer(d) {
  }
  
  function accessData() public returns (uint) {
      return data.x;
  }
}