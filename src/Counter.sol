// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "https://github.com/gelatodigital/gelato-raas-redstone/blob/main/contracts/adapters/RedstonePriceFeedWithRoundsETH.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
