// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./interface/CLV2V3Interface.sol";

contract Game {
    // Oracle price feed address
    CLV2V3Interface public priceFeed;

    // Score mapping (address -> integer)
    mapping(address => uint) scores;

    // List of bigger votes
    address[] biggerVotes;
    // List of smaller votes
    address[] smallerVotes;

    constructor(address _priceFeed) {
        priceFeed = CLV2V3Interface(_priceFeed);
    }

    function vote(bool isBigger) public {
        // Store msg.sender in array
    }

    function tally() public {
        // Reads price feed
        // Checks timestamps
        // If ok, assign scores to winners
    }
}
