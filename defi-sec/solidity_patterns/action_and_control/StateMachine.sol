pragma solidity ^0.4.17;
contract DepositLock {
  enum Stages {
    AcceptingDeposits,
    FreezingDeposits,
    ReleasingDeposits
  }
  Stages public stage = Stages.AcceptingDeposits;
  uint public creationTime = now;
  mapping (address => uint) balances;    
  
  modifier atStage(Stages _stage) {
    require(stage == _stage);
    _;
  }

  modifier timedTransitions() {
    if (stage == Stages.AcceptingDeposits && now >= creationTime + 1 days)
      nextStage();
    if (stage == Stages.FreezingDeposits && now >= creationTime + 8 days)
      nextStage();
    _;
  }
    
  function nextStage() internal {
    stage = Stages(uint(stage) + 1);
  }

  function deposit() public payable timedTransitions atStage(Stages.AcceptingDeposits) {
    balances[msg.sender] += msg.value; 
  }
  
  function withdraw() public timedTransitions atStage(Stages.ReleasingDeposits) { 
    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    msg.sender.transfer(amount);
  }
}