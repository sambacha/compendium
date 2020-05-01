pragma solidity ^0.4.24;

/**
 * @title BOLApp
 * @dev An interface for BOL admin functions implemented in the proxy contracts
 */
contract BOLApp {
  function pause() external;
  function changeController(address) external;
  function setMaster(address) external;
  function setTarget(bytes4, address) external;
  function getTarget(bytes4) external view returns (address);
}

/**
 * @title Controller
 * @dev Admin interface for the BOLApp
 */
contract Controller {

  BOLApp public app;

  address public admin;

  /**
   * @dev Only the admin address can access functions with this modifier
   */
  modifier onlyAdmin {
    require(msg.sender == admin);
    _;
  }

  /**
   * @dev Constructor
   * @param bolApp The address implementing the BOLApp interface
   * @param bolAdmin The address allowed to use this contract
   */
  constructor (address bolApp, address bolAdmin) public {
    app = BOLApp(bolApp);
    admin = bolAdmin;
  }

  /**
   * @dev Allows the admin to pause/unpause all non-admin execution in the application
   *      All functions not implemented in the MasterProxy contract will be locked
   *      until this function is called again.
   */
  function pause() external onlyAdmin {
    app.pause();
  }

  /**
   * @dev Change the address allowed to execute admin functions in the app.
   *      Note that by default, this contract is the controller. Changing
   *      the controller will migrate the permissions for this contract to
   *      another address.
   * @param newController The new controller address
   */
  function changeController(address newController) external onlyAdmin {
    app.changeController(newController);
  }

  /**
   * @dev Allows the admin to set a delegate target for a function selector in the app
   * @param functionSel The function selector for which routing is adjusted
   * @param newTarget The new destination to which calls with the selector will be routed
   */
  function setTarget(bytes4 functionSel, address newTarget) external onlyAdmin {
    app.setTarget(functionSel, newTarget);
  }

  /**
   * @dev Allows the admin to set a new master address for the application
   * @param newMaster The new default delegate target for the universal proxy
   */
  function setMaster(address newMaster) external onlyAdmin {
    app.setMaster(newMaster);
  }
}
