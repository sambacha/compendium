pragma solidity ^0.4.24;

import "./ProxyBase.sol";

/**
 * @title MasterProxy
 * @dev The default target to which UniversalProxy delegates execution.
 *      Implements various administrative functions, allowing a controller
 *      address to selectively upgrade parts of the application.
 */
contract MasterProxy is ProxyBase {

  /**
   * @dev Only the controller address can access functions with this modifier
   */
  modifier onlyController {
    require(msg.sender == controller);
    _;
  }

  /**
   * @dev Fallback function. Delegates execution to the correct target, based
   *      on the function selector included with the transaction
   */
  function () external payable {
    require(!paused, "Contract is paused");

    // Get target from msg.sig
    address target = targets[PROXY_TARGETS][msg.sig];
    require(target != 0, "Invalid execution target");
    
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

  /**
   * @dev Allows the controller to transfer permissions to a new address
   * @param newController The address to which permissions will be transferred
   */
  function changeController(address newController) external onlyController {
    controller = newController;
  }

  /**
   * @dev Allows the controller to flip the pause status of the application
   */
  function pause() external onlyController {
    paused = !paused; // Flips the bool on or off
  }

  /**
   * @dev Allows the controller to set a new master address. Note that *this contract*
   *      is deployed at the master address by default.
   * @param newMaster The new default delegate target for the universal proxy
   */
  function setMaster(address newMaster) external onlyController {
    require(isContract(newMaster), "Invalid master address");
    master = newMaster;
  }

  /**
   * @dev Returns the master address of the universal proxy that is calling this contract.
   * @return The master address of the universal proxy
   */
  function getMaster() external view returns (address) {
    return master;
  }

  /** 
   * @dev Returns the controller address of the universal proxy that is calling this contract.
   * @return The controller address of the universal proxy
   */
  function getController() external view returns (address) {
    return controller;
  }

  /**
   * @dev Allows the controller to set a delegate target for a function selector
   * @param functionSel The function selector for which routing is adjusted
   * @param newTarget The new destination to which calls with the selector will be routed
   */
  function setTarget(bytes4 functionSel, address newTarget) external onlyController {
    require(isContract(newTarget), "Invalid target address");
    targets[PROXY_TARGETS][functionSel] = newTarget;
  }

  /**
   * @dev Returns the address to which execution is delegated for a given function selector
   * @param functionSel The function selector to check
   * @return address The address to which execution will be delegated for the selector
   */
  function getTarget(bytes4 functionSel) external view returns (address) {
    return targets[PROXY_TARGETS][functionSel];
  }

  /**
   * @dev Returns whether or not the address contains code. Note that contracts have
   *      extcodesize 0 during construction.
   * @param a The address to check
   * @return valid True if the address has a nonzero extcodesize
   */

  function isContract(address a) internal view returns (bool valid) {
    assembly { valid := extcodesize(a) }
  }
}
