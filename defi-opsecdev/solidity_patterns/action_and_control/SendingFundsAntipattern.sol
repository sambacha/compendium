pragma solidity ^0.4.17;
contract Auction {
  address public highestBidder;
  uint highestBid;

  function bid() public payable {
    require(msg.value >= highestBid);
    if (highestBidder != 0) {
      // if call fails causing a rollback,
      // no one else can bid
      highestBidder.transfer(highestBid);
    }
    highestBidder = msg.sender;
    highestBid = msg.value;
  }
}