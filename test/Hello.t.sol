// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Hello} from "../src/Hello.sol";

contract HelloTest is Test {
    Hello public hello;
    address alice = makeAddr("alice");
    event NewHello(address indexed sender, string message);

    function setUp() public {
        hello = new Hello();
    }

    function test_CreateHello() public {
        string memory message = "Hello World";
        // Expect NewHello event
        vm.expectEmit(true,false,false,false);
        emit NewHello(address(alice), message);
        // Create a new Hello message
        hoax(alice, 100 ether);
        hello.createHello(message);
        // Check the message
        assertEq(hello.message(alice),message);
        // Check if counter = 1
        assertEq(hello.counter(),1);
    }

    function test_MinLength() public {
        vm.expectRevert("Message too short");
        hello.createHello("Hi");
    }

    function test_MaxLength() public {
        vm.expectRevert("Message too long");
        hello.createHello("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean porta neque eget elit tristique pharetra. Pellentesque tempus sollicitudin tortor, ut tempus diam. Nulla facilisi. Donec at neque sapien.");
    }

    function test_Blacklist() public {
        vm.expectRevert("Message contains blacklisted word");
        hello.createHello("Hello word1");
    }

    function test_SetBlacklist() public {
        // Create a temporary dynamic array of strings
        string[] memory bl = new string[](3);
        bl[0] = "word1";
        bl[1] = "word3";
        bl[2] = "word4";
        hello.setBlacklist(bl);
        string[] memory getBL = new string[](2);
        getBL[0] = hello.blacklist(0);
        getBL[1] = hello.blacklist(1);
        assertEq(getBL[0], bl[0]);
        assertEq(getBL[1], bl[1]);
    }

    function test_SetBlacklistNotOwner() public {
        string[] memory bl = new string[](3);
        bl[0] = "word1";
        bl[1] = "word3";
        bl[2] = "word4";
        vm.expectRevert("Not owner");
        hoax(alice, 100 ether);
        hello.setBlacklist(bl);
    }

    function test_SetMinMaxMessageLength() public {
        uint32 newMin = 1;
        uint32 newMax = 500;
        hello.setMinMaxMessageLength(newMin,newMax);
        assertEq(hello.minLength(), newMin);
        assertEq(hello.maxLength(), newMax);
    }

    function test_SetMinMaxMessageLengthNotOwner() public {
        uint32 newMin = 1;
        uint32 newMax = 500;
        hoax(alice, 100 ether);
        vm.expectRevert();
        hello.setMinMaxMessageLength(newMin,newMax);
    }
    /* function test_getHello() public {
        hoax(alice, 100 ether);
        hello.createHello("Hello World");
        assertEq(hello.getHello(alice), "Hello World");
    }

    function test_getHelloCounter() public {
        hoax(alice, 100 ether);
        assertEq(hello.getHelloCounter(), 0);
        hello.createHello("Hello World");
        assertEq(hello.getHelloCounter(), 1);
    } */
}
