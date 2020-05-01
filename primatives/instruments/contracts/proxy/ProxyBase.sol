pragma solidity ^0.4.24;

contract ProxyBase {

  // Key for function selector -> address mapping for proxy contracts
  bytes32 constant PROXY_TARGETS = keccak256("PROXY_TARGETS");

  // Master contract - default target for all delegatecall forwarding
  address master;
  // Controller - can perform administrative functions
  address controller;

  // Whether or not the contract is paused
  bool paused;

  // Function selector -> delegate address map
  mapping (bytes32 => mapping(bytes4 => address)) targets;
}
