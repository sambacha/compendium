pragma solidity ^0.4.17;
contract SimpleDeposit {
  mapping (address => uint) balances;    
    
  event LogDepositMade(address from, uint amount);
    
  modifier minAmount(uint amount) {
    require(msg.value >= amount);
    _;
  }
    
  function SimpleDeposit() public payable {
    balances[msg.sender] = msg.value;
  }
	
  function deposit() public payable minAmount(1 ether) {
    balances[msg.sender] += msg.value;
    LogDepositMade(msg.sender, msg.value);
  }
    
  function getBalance() public view returns (uint balance) {
    return balances[msg.sender];
  }
  
  function withdrawBalance() public {
    uint amount = balances[msg.sender];
    require(msg.sender.call.value(amount)()); // caller's code is executed and can re-enter withdrawBalance again
    balances[msg.sender] = 0; // INSECURE - user's balance must be reset before the external call
  }
}