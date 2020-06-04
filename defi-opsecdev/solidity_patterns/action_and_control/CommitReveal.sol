pragma solidity ^0.4.17;
contract CommitReveal {
  struct Commit {string choice; string secret; string status;}
  mapping(address => mapping(bytes32 => Commit)) public userCommits;
    
  event LogCommit(bytes32, address);
  event LogReveal(bytes32, address, string, string);
    
  function CommitReveal() public {}
    
  function commit(bytes32 _commit) public returns (bool success) {
    var userCommit = userCommits[msg.sender][_commit];
    if(bytes(userCommit.status).length != 0) {
      return false; // commit has been used before
    }
    userCommit.status = "c"; // comitted
    LogCommit(_commit, msg.sender);
    return true;
  }
    
  function reveal(string _choice, string _secret, bytes32 _commit) public returns (bool success) {
    var userCommit = userCommits[msg.sender][_commit];
    bytes memory bytesStatus = bytes(userCommit.status);
    if(bytesStatus.length == 0) {
      return false; // choice not committed before
    } else if (bytesStatus[0] == "r") {
      return false; // choice already revealed
    }
    if (_commit != keccak256(_choice, _secret)) {
      return false; // hash does not match commit
    }
    userCommit.choice = _choice;
    userCommit.secret = _secret;
    userCommit.status = "r"; // revealed
    LogReveal(_commit, msg.sender, _choice, _secret);
    return true;
  }
    
  function traceCommit(address _address, bytes32 _commit) public view returns (string choice, string secret, string status) {
    var userCommit = userCommits[_address][_commit];
    require(bytes(userCommit.status)[0] == "r");
    return (userCommit.choice, userCommit.secret, userCommit.status);
  }
}