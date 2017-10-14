pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	function bid() payable external returns (bool) {
		if (msg.value <= getHighestBid()) {
			if (!msg.sender.send(msg.value)) {
				revert();
			}
			return false;
		}
		if (highestBidder != 0 && !highestBidder.send(highestBid)) {
			if (!msg.sender.send(msg.value)) {
				revert();
			}
			return true; 
		} 
		highestBidder = msg.sender;
		highestBid = msg.value;
		return true;
	}

	/* Give people their funds back */
	function () payable {
		revert();
	}
}
