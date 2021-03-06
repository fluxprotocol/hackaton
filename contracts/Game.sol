// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./interface/CLV2V3Interface.sol";

contract Game {
    enum GameStatus {
        INACTIVE,
        ACTIVE,
        ENDED
    }

    // Oracle price feed address
    CLV2V3Interface public priceFeed;

    // Game reference price
    int256 public referencePrice = 0;

    // Game reference timestamp
    uint256 public referenceTimestamp = 0;

    // Game state
    GameStatus public gameState = GameStatus.INACTIVE;

    // Outcome
    bool public outcome;

    // Score mapping (address -> integer)
    mapping(address => uint) public scores;

    // List of bigger votes
    address[] public biggerVotes;

    // List of smaller votes
    address[] public smallerVotes;

    modifier isGameActive() {
        require(gameState == GameStatus.ACTIVE, "Game has ended");
        _;
    }
    
    modifier isGameEnded() {
        require(gameState == GameStatus.ENDED, "Game hasnt ended");
        _;
    }

    constructor(address _priceFeed) {
    }

    function start() public {
    }

    function vote(bool isBigger) public isGameActive {
    }

    function tally() public isGameActive {
    }

    function getPoints(address _for) public view isGameEnded returns(uint) {
    }
}
