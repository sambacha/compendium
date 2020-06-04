pragma solidity ^0.4.17;
import "./Oracle.sol";
contract OracleConsumer {
  Oracle oracle = Oracle(0x123...); // known contract
  
  modifier onlyBy(address account) { 
    require(msg.sender == account);  _; 
  }
  
  function updateExchangeRate() {
    oracle.query("USD", this.oracleResponse);
  }
    
  function oracleResponse(bytes response) onlyBy(oracle) { 
    // use the data
  }
}