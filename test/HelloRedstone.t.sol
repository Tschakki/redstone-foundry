// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/HelloRedstone.sol";

contract MockRedstonePayload is Test {
    function getRedstonePayload(
        // dataFeedId:value:decimals
        string memory priceFeed
    ) public returns (bytes memory) {
        string[] memory args = new string[](3);
        args[0] = "node";
        args[1] = "getRedstonePayload.js";
        args[2] = priceFeed;

        return vm.ffi(args);
    }
}

contract HelloRedstoneTest is Test, MockRedstonePayload {
    HelloRedstone public helloRedstone;

    function setUp() public {
        helloRedstone = new HelloRedstone();
    }

    function testOracleData() public {
        bytes memory redstonePayload = getRedstonePayload("ETH:69:8");

        bytes memory encodedFunction = abi.encodeWithSignature(
            "getLatestEthPrice()"
        );
        bytes memory encodedFunctionWithRedstonePayload = abi.encodePacked(
            encodedFunction,
            redstonePayload
        );

        // Securely getting oracle value
        (bool success, ) = address(helloRedstone).call(
            encodedFunctionWithRedstonePayload
        );
        assertEq(success, true);
        // 120 * 10 ** 8
        //assertEq(counter.number(), 12000000000);
    }
}