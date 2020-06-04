pragma solidity ^0.4.17;
contract Oracle {
  address knownSource = 0x123...; // known source
  struct Request {
    bytes data;
    function(bytes memory) external callback;
  }
  Request[] requests;
  
  event NewRequest(uint);

  modifier onlyBy(address account) { 
    require(msg.sender == account);  _; 
  }
  
  function query(bytes data, function(bytes memory) external callback) public {
    requests.push(Request(data, callback));
    NewRequest(requests.length - 1);
  }
  
  // invoked by outside world
  function reply(uint requestID, bytes response) public onlyBy(knownSource) {
    requests[requestID].callback(response);
  }
}