// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ReentrancyGuard.sol";
import "./IDogger.sol";

contract Barks is ReentrancyGuard {
    event BarkAdded(uint indexed barkKey, uint indexed userKey, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isRemoved, bool isEmpty, uint date);
    event BarkRemoved(uint indexed barkKey, uint indexed userKey, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isRemoved, bool isEmpty, uint date);

    address doggerAddress;
    IDogger dogger;

    constructor(
        address _doggerAddress
    ) {
        doggerAddress = _doggerAddress;
        dogger = IDogger(doggerAddress);
    }

    function addBark(
        string memory _text,
        bool _isMedia,
        string memory _ipfs
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(280 >= bytes(_text).length, "Barks must be 280 chars or less");

        if (_isMedia) {
            require(dogger.isMediaEnabled(), "Media posting is currently disabled");
            require(64 >= bytes(_ipfs).length, "Content hash cannot exceed 64 chars");
        } else {
            _ipfs = "";
        }

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;

        uint date = block.timestamp;

        (, bytes memory data) = doggerAddress.call(
            abi.encodeWithSignature("addBark(uint256,string,bool,string,uint256)", userKey, _text, _isMedia, _ipfs, date)
        );

        uint barkKey;
        assembly {
            barkKey := mload(add(data, add(0x20, 0)))
        }

        emit BarkAdded(barkKey, userKey, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);
    }

    function removeBark(
        uint _barkKey
    ) public nonReentrant {
        require(dogger.barkExists(_barkKey), "This bark doesn't exist");
        Bark memory _bark = dogger.retrieveBarkByKey(_barkKey);
        require(_bark.isRemoved == false, "This bark is already removed");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(_bark.userKey == dogger.retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your bark");

        doggerAddress.call(
            abi.encodeWithSignature("removeBark(uint256)", _barkKey)
        );

        emit BarkRemoved(_barkKey, _bark.userKey, _bark.text, _bark.isMedia, _bark.ipfs, _bark.comments, _bark.reposts, _bark.likes, false, true, block.timestamp);
    }
}
