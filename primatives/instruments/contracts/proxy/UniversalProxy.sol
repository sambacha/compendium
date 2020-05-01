pragma solidity ^0.4.24;

import "./ProxyBase.sol";

/**
 * @title UniversalProxy
 * @dev Interface for all functions implemented in this application.
 *      Delegates all execution to the default target, the MasterProxy
 */
contract UniversalProxy is ProxyBase {

  /**
   * @dev Constructor
   * @param pMaster The default delegate target for the contract
   * @param pController The permissioned controller address
   */
  constructor (address pMaster, address pController) public {
    master = pMaster;
    controller = pController;
  }


  /**
   * @dev Fallback function. Delegates execution to the master contract
   */
  function () external payable {
    address target = master;
    assembly {
      // Copy all calldata to mem @ 0x00
      calldatacopy(0, 0, calldatasize)

      // Delegatecall the target. Copy its returndata
      let res := delegatecall(gas, target, 0, calldatasize, 0, 0)
      returndatacopy(0, 0, returndatasize)

      // If we got an error, revert data to sender. Otherwise, return data
      switch res
      case 0 { revert(0, returndatasize) }
      default { return(0, returndatasize) }
    }
  }
}
