pragma solidity ^0.4.24;

/**
 * @title UniversalABI
 * @dev The JSON ABI of this contract can be used to interface with
 *      the entire application through the UniversalProxy
 */
contract UniversalABI {

  // Admin interface
  function pause() external;
  function changeMaster(address) external;
  function changeController(address) external;
  function setTarget(bytes4, address) external;
  function getController() external view returns (address);
  function getTarget(bytes4) external view returns (address);
  function getMaster() external view returns (address);
  // TODO extend with all implemented NFT functions
}
