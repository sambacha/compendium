pragma solidity ^0.4.24;

library SafeMath {

  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
    uint256 c = _a + _b;
    require(c >= _a && c >= _b);
    return c;
  }

  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    require(_a >= _b);
    return _a - _b;
  }

  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
    uint256 c = _a * _b;
    require(_a == 0 || c / _a == _b);
    return c;
  }

}
