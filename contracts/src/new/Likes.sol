// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ReentrancyGuard.sol";
import "./IDogger.sol";

contract Likes is ReentrancyGuard {
    event LikeAdded(uint indexed likeKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isRemoved, uint date);
    event LikeRemoved(uint indexed likeKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isRemoved, uint date);

    address doggerAddress;
    IDogger dogger;

    constructor(
        address _doggerAddress
    ) {
        doggerAddress = _doggerAddress;
        dogger = IDogger(doggerAddress);
    }

    function addLike(
        uint _postKey,
        bool _isComment
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");

        if (_isComment) {
            require(dogger.commentExists(_postKey), "This comment doesn't exist");
        } else {
            require(dogger.barkExists(_postKey), "This bark doesn't exist");
        }

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;
        require(dogger.hasLiked(_postKey, _isComment, userKey) == -1, "You have already liked this");

        uint date = block.timestamp;

        (, bytes memory data) = doggerAddress.call(
            abi.encodeWithSignature("addLike(bool,uint256,uint256,uint256)", _isComment, _postKey, userKey, date)
        );

        uint likeKey;
        assembly {
            likeKey := mload(add(data, add(0x20, 0)))
        }

        emit LikeAdded(likeKey, _postKey, userKey, _isComment, false, date);
    }

    function removeLike(
        uint _likeKey
    ) public nonReentrant {
        require(dogger.likeExists(_likeKey), "This like doesn't exist");
        Like memory _like = dogger.retrieveLikeByKey(_likeKey);
        require(_like.isRemoved == false, "This like is already removed");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(_like.userKey == dogger.retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your like");

        doggerAddress.call(
            abi.encodeWithSignature("removeLike(uint256)", _likeKey)
        );

        emit LikeRemoved(_likeKey, _like.postKey, _like.userKey, _like.isComment, true, block.timestamp);
    }
}
