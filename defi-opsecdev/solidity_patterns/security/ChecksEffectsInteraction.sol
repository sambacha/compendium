pragma solidity ^0.4.17;
contract Auction {
  address public beneficiary = msg.sender;
  address highestBidder;
  uint highestBid;
  uint public auctionEnd = now + 3 days;
  bool ended;
  mapping(address => uint) refunds;

  function bid() public payable {
    require(msg.value >= highestBid);
    if (highestBidder != 0) {
      refunds[highestBidder] += highestBid; // record the refund that this user can claim
    }
    highestBidder = msg.sender;
    highestBid = msg.value;
  }

  function withdrawRefund() public {
    uint refund = refunds[msg.sender];
    refunds[msg.sender] = 0;
    msg.sender.transfer(refund);
  }
    
  function auctionEnd() public {
    // 1. Checks
    require(now >= auctionEnd);
    require(!ended);
    // 2. Effects
    ended = true;
    // 3. Interaction
    beneficiary.transfer(highestBid);
  }
}