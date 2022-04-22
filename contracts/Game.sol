// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./interface/CLV2V3Interface.sol";

contract Game {
    // Oracle price feed address
    CLV2V3Interface public priceFeed;

    // Game reference price
    int256 public referencePrice = 0;

    // Game reference timestamp
    uint256 public referenceTimestamp = 0;

    // Game ended
    bool public gameEnded = false;

    // Outcome
    bool public outcome;

    // Score mapping (address -> integer)
    mapping(address => uint) public scores;

    // List of bigger votes
    address[] public biggerVotes;

    // List of smaller votes
    address[] public smallerVotes;

    modifier isGameActive() {
        require(!gameEnded, "Game has ended");
        _;
    }
    
    modifier isGameEnded() {
        require(gameEnded, "Game hasnt ended");
        _;
    }

    constructor(address _priceFeed) {
        priceFeed = CLV2V3Interface(_priceFeed);
    }

    function start() public {
        require(referenceTimestamp == 0, "Game was already activated");
        (, referencePrice, , referenceTimestamp, ) = priceFeed
            .latestRoundData();
    }

    function vote(bool isBigger) public isGameActive {
        if (isBigger) {
            biggerVotes.push(msg.sender);
        } else {
            smallerVotes.push(msg.sender);
        }
    }

    function tally() public isGameActive {
        (, int newPrice, , uint newTimestamp, ) = priceFeed.latestRoundData();

        require(
            newTimestamp > referenceTimestamp,
            "Price timestamp is not valid"
        );

        if (newPrice > referencePrice) {
            for (uint i = 0; i < biggerVotes.length; i++) {
                scores[biggerVotes[i]]++;
            }
        } else if (newPrice < referencePrice) {
            for (uint i = 0; i < smallerVotes.length; i++) {
                scores[smallerVotes[i]]++;
            }
        }

        gameEnded = true;
    }

    function getPoints(address _for) public view isGameEnded returns(uint) {
        if (outcome) {
            return scores[_for];
        } else {
            return scores[_for];
        }
    }
}
