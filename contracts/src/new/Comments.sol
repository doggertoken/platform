// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ReentrancyGuard.sol";
import "./IDogger.sol";

contract Comments is ReentrancyGuard {
    event CommentAdded(uint indexed commentKey, uint indexed barkKey, uint indexed userKey, uint subcommentKey, bool isSubcomment, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isEmpty, bool isRemoved, uint date);
    event CommentRemoved(uint indexed commentKey, uint indexed barkKey, uint indexed userKey, uint subcommentKey, bool isSubcomment, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isEmpty, bool isRemoved, uint date);

    address doggerAddress;
    IDogger dogger;

    constructor(
        address _doggerAddress
    ) {
        doggerAddress = _doggerAddress;
        dogger = IDogger(doggerAddress);
    }

    function addComment(
        uint _barkKey,
        uint _commentKey,
        bool _isSubcomment,
        string memory _text,
        bool _isMedia,
        string memory _ipfs
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(dogger.barkExists(_barkKey), "This bark doesn't exist");

        if (_isMedia) {
            require(dogger.isMediaEnabled(), "Media posting is currently disabled");
            require(64 >= bytes(_ipfs).length, "Content hash cannot exceed 64 chars");
        } else {
            _ipfs = "";
        }

        if (_isSubcomment) {
            require(dogger.commentExists(_commentKey), "This comment doesn't exist");
        }

        require(280 >= bytes(_text).length, "Comments must be 280 chars or less");

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;

        uint date = block.timestamp;

        (, bytes memory data) = doggerAddress.call(
            abi.encodeWithSignature("addComment(uint256,uint256,bool,uint256,string,bool,string,uint)", userKey, _barkKey, _isSubcomment, _commentKey, _text, _isMedia, _ipfs, date)
        );

        uint commentKey;
        assembly {
            commentKey := mload(add(data, add(0x20, 0)))
        }

        //emit CommentAdded(commentKey, _barkKey, userKey, _commentKey, _isSubcomment, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);
    }

    function removeComment(
        uint _commentKey
    ) public nonReentrant {
        require(dogger.commentExists(_commentKey), "This comment doesn't exist");
        Comment memory _comment = dogger.retrieveCommentByKey(_commentKey);
        require(_comment.isRemoved == false, "This comment is already removed");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(_comment.userKey == dogger.retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your comment");

        doggerAddress.call(
            abi.encodeWithSignature("removeComment(uint256)", _commentKey)
        );

        emit CommentRemoved(_commentKey, _comment.barkKey, _comment.userKey, _comment.subcommentKey, _comment.isSubcomment, _comment.text, _comment.isMedia, _comment.ipfs, _comment.comments, _comment.reposts, _comment.likes, false, true, block.timestamp);
    }
}
