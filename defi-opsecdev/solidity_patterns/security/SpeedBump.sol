pragma solidity ^0.4.17;
contract SpeedBump {
  struct Withdrawal {
    uint amount;
    uint requestedAt;
  }
  mapping (address => uint) private balances;
  mapping (address => Withdrawal) private withdrawals;
  uint constant WAIT_PERIOD = 7 days;

  function deposit() public payable {
    if(!(withdrawals[msg.sender].amount > 0))
      balances[msg.sender] += msg.value;
  }
  
  function requestWithdrawal() public {
    if (balances[msg.sender] > 0) {
  	  uint amountToWithdraw = balances[msg.sender];
      balances[msg.sender] = 0;
      withdrawals[msg.sender] = Withdrawal({
        amount: amountToWithdraw,
        requestedAt: now
      });
    }
  }

  function withdraw() public {
    if(withdrawals[msg.sender].amount > 0 && now > withdrawals[msg.sender].requestedAt + WAIT_PERIOD) {
      uint amount = withdrawals[msg.sender].amount;
      withdrawals[msg.sender].amount = 0;
      msg.sender.transfer(amount);
    }
  }
}