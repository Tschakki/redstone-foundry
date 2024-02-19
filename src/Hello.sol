// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.20 and less than 0.9.0
pragma solidity ^0.8.20;
import "lib/solidity-util/lib/Strings.sol";

contract Hello {
    using Strings for string;

    /** State variables */
    // State variable for the Hello messages
    mapping(address => string) public message;
    // State variable for the message counter
    uint32 public counter = 0;
    // Address of the contract owner
    address public owner;
    // Blacklist of words that are not allowed in the Hello message
    string[] public blacklist = ["word1","word2"];
    // Maximum length of the Hello message
    uint32 public maxLength = 200;
    // Minimum length of the Hello message
    uint32 public minLength = 3;

    constructor() {
        // Set the transaction sender as the owner of the contract.
        owner = msg.sender;
    }

    /** Modifiers */
    // Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    // Validate message length
    modifier validLength(string memory _message) {
        require(bytes(_message).length >= minLength, "Message too short");
        require(bytes(_message).length <= maxLength, "Message too long");
        _;
    }
    // Validate message content
    modifier validWords(string memory _message) {
        bytes memory whereBytes = bytes (_message);

        for (uint h = 0; h < blacklist.length; h++) {
            bool found = false;
            bytes memory whatBytes = bytes (blacklist[h]);
            for (uint i = 0; i <= whereBytes.length - whatBytes.length; i++) {
                bool flag = true;
                for (uint j = 0; j < whatBytes.length; j++)
                    if (whereBytes [i + j] != whatBytes [j]) {
                        flag = false;
                        break;
                    }
                if (flag) {
                    found = true;
                    break;
                }
            }
            require (!found, "Message contains blacklisted word");
        }
        _;
    }

    /** Events */
     // Event for new Hello messages
    event NewHello(address indexed sender, string message);

    /** Functions */
    // Function to configure the blacklist
    function setBlacklist(string[] memory _newBlackList) public onlyOwner {
        blacklist = _newBlackList;
    } 
    // Function to configure min/max message length
    function setMinMaxMessageLength(uint32 _newMin,uint32 _newMax) public onlyOwner {
        minLength = _newMin;
        maxLength = _newMax;
    }
    // Function to create a new Hello message
    function createHello(string calldata _message) public validLength(_message) validWords(_message) {
        message[msg.sender] = _message;
        counter+=1;
        emit NewHello(msg.sender, _message);
    }

    /* Not needed anymore, as state variables are public (maybe reimplement former plugin as view function?) */
    /* // Function to get the Hello message counter
    function getHelloCounter() public view returns (uint32) {
        return counter;
    }
    // Function to get the Hello message of an address
    function getHello(address _address) public view returns (string memory) {
        return message[_address];
    } */
}
