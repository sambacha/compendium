pragma solidity ^0.4.17;
contract Auction {
  address public highestBidder;
  uint highestBid;
  mapping(address => uint) refunds;

  function bid() public payable {
    require(msg.value >= highestBid);
    if (highestBidder != 0) {
      // record the underlying bid to be refund
      refunds[highestBidder] += highestBid; 
    }
    highestBidder = msg.sender;
    highestBid = msg.value;
  }
  
  function withdrawRefund() public {
    uint refund = refunds[msg.sender];
    refunds[msg.sender] = 0;
    msg.sender.transfer(refund);
  }
}