// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ReentrancyGuard.sol";
import "./IDogger.sol";

contract Reposts is ReentrancyGuard {
    event RepostAdded(uint indexed repostKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isQuote, string text, bool isRemoved, uint date);
    event RepostRemoved(uint indexed repostKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isQuote, string text, bool isRemoved, uint date);

    address doggerAddress;
    IDogger dogger;

    constructor(
        address _doggerAddress
    ) {
        doggerAddress = _doggerAddress;
        dogger = IDogger(doggerAddress);
    }

    function addRepost(
        uint _postKey,
        bool _isComment,
        bool _isQuote,
        string memory _text
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");

        if (_isComment) {
            require(dogger.commentExists(_postKey), "This comment doesn't exist");
        } else {
            require(dogger.barkExists(_postKey), "This bark doesn't exist");
        }

        if (_isQuote) {
            require(280 >= bytes(_text).length, "Reposts must be 280 chars or less");
        } else {
            _text = "";
        }

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;
        require(dogger.hasReposted(_postKey, _isComment, userKey) == -1, "You have already reposted this");

        uint date = block.timestamp;

        (, bytes memory data) = doggerAddress.call(
            abi.encodeWithSignature("addRepost(bool,uint256,uint256,bool,string,uint256)", _isComment, _postKey, userKey, _isQuote, _text, date)
        );

        uint repostKey;
        assembly {
            repostKey := mload(add(data, add(0x20, 0)))
        }

        emit RepostAdded(repostKey, _postKey, userKey, _isComment, _isQuote, _text, false, date);
    }

    function removeRepost(
        uint _repostKey
    ) public nonReentrant {
        require(dogger.repostExists(_repostKey), "This repost doesn't exist");
        Repost memory _repost = dogger.retrieveRepostByKey(_repostKey);
        require(_repost.isRemoved == false, "This repost is already removed");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(_repost.userKey == dogger.retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your repost");

        doggerAddress.call(
            abi.encodeWithSignature("removeRepost(uint256)", _repostKey)
        );

        emit RepostRemoved(_repostKey, _repost.postKey, _repost.userKey, _repost.isComment, _repost.isQuote, _repost.text, true, block.timestamp);
    }
}
