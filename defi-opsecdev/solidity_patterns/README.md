This is the accompanying code repository for the following research papers:<br/>
[Design Patterns for Smart Contracts in the Ethereum Ecosystem](https://swa.cs.univie.ac.at/research/publications/publication/5665/])<br/>
[Smart Contracts: Security Patterns in the Ethereum Ecosystem and Solidity](https://swa.cs.univie.ac.at/research/publications/publication/5433/)

# Design Patterns

Design  patterns are a commonly used technique to encode design guide-lines or best practices. They express an abstract or conceptual solution to a concrete, complex, and reoccurring problem.

## Action and Control

Action and Control is a group of patterns that provide mechanisms 
for typical operational tasks.

_ | PULL PAYMENT PATTERN |
--- | :---  | 
**Problem** | When a contract sends funds to another party, the send operation can fail. | 
**Solution** | Let the receiver of a payment withdraw the funds. | 
Source | [action_and_control/SendingFunds.sol](action_and_control/SendingFunds.sol)

_ | STATE MACHINE PATTERN |
--- | :---  | 
**Problem** | An application scenario implicates different behavioural stages and transitions. | 
**Solution** | Apply a state machine to model and represent different behavioural contract stages and their transitions. | 
Source | [action_and_control/StateMachine.sol](action_and_control/StateMachine.sol)

_ | COMMIT AND REVEAL PATTERN |
--- | :---  | 
**Problem** | All data and every transaction is publicly visible on the blockchain, but an application scenario requires that contract interactions, specifically submitted parameter values, are treated confidentially. | 
**Solution** | Apply a commitment scheme to ensure that a value submission is binding and concealed until a consolidation phase runs out, after which the value is revealed, and it is publicly verifiable that the value remained unchanged. | 
Source | [action_and_control/CommitReveal.sol](action_and_control/CommitReveal.sol)

_ | ORACLE (DATA PROVIDER) PATTERN |
--- | :---  | 
**Problem** | An application scenario requires knowledge contained outside the blockchain, but Ethereum contracts cannot directly acquire information from the outside world. On the contrary, they rely on the outside world pushing information into the network. | 
**Solution** | Request external data through an oracle service that is connected to the outside world and acts as a data carrier. | 
Source | [action_and_control/oracle/Oracle.sol](action_and_control/oracle/Oracle.sol); [action_and_control/oracle/OracleConsumer.sol](action_and_control/oracle/OracleConsumer.sol)

## Authorization

Authorization is a group of patterns that control access to
smart contract functions and provide basic authorization control,
which simplify the implementation of "user permissions".

_ | OWNERSHIP PATTERN |
--- | :---  | 
**Problem** | By default any party can call a contract method, but it must be ensured that sensitive contract methods can only be executed by the owner of a contract. | 
**Solution** | Store the contract creator’s address as owner of a contract and restrict method execution dependent on the callers address. | 
Source | [authorization/Ownership.sol](authorization/Ownership.sol)

_ | ACCESS RESTRICTION PATTERN |
--- | :---  | 
**Problem** | By default a contract method is executed without any preconditions being checked, but it is desired that the execution is only allowed if certain requirements are met. | 
**Solution** | Define generally applicable modifiers that check the desired requirements and apply these modifiers in the function definition. | 
Source | [authorization/AccessRestriction.sol](authorization/AccessRestriction.sol)

## Lifecycle

Lifecycle is a group of patterns that control the creation and
destruction of smart contracts.

_ | MORTAL PATTERN |
--- | :---  | 
**Problem** | A deployed contract will exist as long as the Ethereum network exists. If a contract’s lifetime is over, it must be possible to destroy a contract and stop it from operating. | 
**Solution** | Use a selfdestruct call within a method that does a preliminary authorization check of the invoking party. | 
Source | [lifecycle/Mortal.sol](lifecycle/Mortal.sol)

_ | AUTOMATIC DEPRECATION PATTERN |
--- | :---  | 
**Problem** | A usage scenario requires a temporal constraint defining a point in time when functions become deprecated. | 
**Solution** | Define an expiration time and apply modifiers in function definitions to disable function execution if the expiration date has been reached. | 
Source | [lifecycle/AutomaticDeprecation.sol](lifecycle/AutomaticDeprecation.sol); [lifecycle/AutomaticDeprecation2.sol](lifecycle/AutomaticDeprecation2.sol)

## Maintenance

Maintenance is a group of patterns that provide mechanisms
for live operating contracts.

_ | DATA SEGREGATION PATTERN |
--- | :---  | 
**Problem** | Contract data and its logic are usually kept in the same contract, leading to a closely entangled coupling. Once a contract is replaced by a newer version, the former contract data must be migrated to the new contract version. | 
**Solution** | Decouple the data from the operational logic into separate contracts. | 
Source | [maintenance/segregation/DataStorage.sol](maintenance/segregation/DataStorage.sol); [maintenance/segregation/Logic.sol](maintenance/segregation/Logic.sol)

_ | SATELLITE PATTERN |
--- | :---  | 
**Problem** | Contracts are immutable. Changing contract functionality requires the deployment of a new contract. | 
**Solution** | Outsource functional units that are likely to change into separate so-called satellite contracts and use a reference to these contracts in order to utilize needed functionality. | 
Source | [maintenance/satellite/Satellite.sol](maintenance/satellite/Satellite.sol); [maintenance/satellite/Base.sol](maintenance/satellite/Base.sol)

_ | CONTRACT REGISTER PATTERN |
--- | :---  | 
**Problem** | Contract participants must be referred to the latest contract version. | 
**Solution** | Let contract participants pro-actively query the latest contract address through a register contract that returns the address of the most recent version. | 
Source | [maintenance/Register.sol](maintenance/Register.sol)

_ | CONTRACT RELAY PATTERN |
--- | :---  | 
**Problem** | Contract participants must be referred to the latest contract version. | 
**Solution** | Contract participants always interact with the same proxy contract that relays all requests to the most recent contract version. | 
Source | [maintenance/Relay.sol](maintenance/Relay.sol)

## Security

Security is a group of patterns that introduce safety measures
to mitigate damage and assure a reliable contract execution.

_ | CHECKS-EFFECTS-INTERACTION PATTERN |
--- | :---  | 
**Problem** | When  a  contract  calls  another  contract,  it  hands  over  control to that other contract. The called contract can then, in turn, re-enter the contract by which it was called and try to manipulate its state or hijack the control flow through malicious code. | 
**Solution** | Follow a recommended functional code order, in which calls to external contracts are always the last step, to reduce the attack surface of a contract being manipulated by its own externally called contracts. | 
Source | [security/ChecksEffectsInteraction.sol](security/ChecksEffectsInteraction.sol)

_ | EMERGENCY STOP (CIRCUIT BREAKER) PATTERN |
--- | :---  | 
**Problem** | Since a deployed contract is executed autonomously on the Ethereum network, there is no option to halt its execution in case of a major bug or security issue. | 
**Solution** | Incorporate an emergency stop functionality into the contract that can be triggered by an authenticated party to disable sensitive functions. | 
Source | [security/EmergencyStop.sol](security/EmergencyStop.sol)

_ | SPEED BUMP PATTERN |
--- | :---  | 
**Problem** | The simultaneous execution of sensitive tasks by a huge number of parties can bring about the downfall of a contract. | 
**Solution** | Prolong the completion of sensitive tasks to take steps against fraudulent activities. | 
Source | [security/SpeedBump.sol](security/SpeedBump.sol)

_ | RATE LIMIT PATTERN |
--- | :---  | 
**Problem** | A request rush on a certain task is not desired and can hinder the correct operational performance of a contract. | 
**Solution** | Regulate how often a task can be executed within a period of time. | 
Source | [security/RateLimit.sol](security/RateLimit.sol)

_ | MUTEX PATTERN |
--- | :---  | 
**Problem** | Re-entrancy attacks can manipulate the state of a contract and hijack the control flow. | 
**Solution** | Utilize a mutex to hinder an external call from re-entering its caller function again. | 
Source | [security/Mutex.sol](security/Mutex.sol)

_ | BALANCE LIMIT PATTERN |
--- | :---  | 
**Problem** | There is always a risk that a contract gets compromised due to bugs in the code or yet unknown security issues within the contract platform. | 
**Solution** | Limit the maximum amount of funds at risk held within a contract. | 
Source | [security/LimitBalance.sol](security/LimitBalance.sol)
