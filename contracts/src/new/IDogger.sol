// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Structs.sol";

interface IDogger {
    function addBark(
        uint userKey,
        string memory _text,
        bool _isMedia,
        string memory _ipfs,
        uint date
    ) external returns (uint);

    function removeBark(
        uint _barkKey
    ) external;

    function addComment(
        uint userKey,
        uint _barkKey,
        bool _isSubcomment,
        uint _commentKey,
        string memory _text,
        bool _isMedia,
        string memory _ipfs,
        uint date
    ) external returns (uint);

    function removeComment(
        uint _commentKey
    ) external;

    function addRepost(
        bool _isComment,
        uint _postKey,
        uint userKey,
        bool _isQuote,
        string memory _text,
        uint date
    ) external returns (uint);

    function removeRepost(
        uint _repostKey
    ) external;

    function addLike(
        bool _isComment,
        uint _postKey,
        uint userKey,
        uint date
    ) external returns (uint);

    function removeLike(
        uint _likeKey
    ) external;

    function addUser(
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _ipfsProfile,
        string memory _ipfsBanner
    ) external;

    function updateUser(
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _website,
        string memory _location,
        string memory _ipfsProfile,
        string memory _ipfsBanner
    ) external;

    function removeUser(
        uint _userKey
    ) external;

    function followUser(
        uint _userKey,
        uint userKey
    ) external;

    function unfollowUser(
        uint _userKey,
        uint userKey
    ) external;

    function isRestricted(
        address _addr
    ) external view returns (bool);

    function isMediaEnabled() external view returns (bool);

    function isPaused() external view returns (bool);

    function retrieveBarksWithLimit(
        uint _limit
    ) external view returns (Bark[] memory);

    function retrieveBarksByUser(
        uint _userKey
    ) external view returns (Bark[] memory);

    function retrieveBarkByKey(
        uint _barkKey
    ) external view returns (Bark memory);

    function retrieveRepostsByUser(
        uint _userKey
    ) external view returns (Repost[] memory);

    function retrieveRepostByKey(
        uint _repostKey
    ) external view returns (Repost memory);

    function retrieveCommentsByUser(
        uint _userKey
    ) external view returns (Comment[] memory);

    function retrieveCommentByKey(
        uint _commentKey
    ) external view returns (Comment memory);

    function retrieveLikesByUser(
        uint _userKey
    ) external view returns (Like[] memory);

    function retrieveLikeByKey(
        uint _likeKey
    ) external view returns (Like memory);

    function retrieveCommentsByBark(
        uint _barkKey
    ) external view returns (Comment[] memory);

    function retrieveCommentsAndSubcommentsByBark(
        uint _barkKey
    ) external view returns (Comment[] memory);

    function retrieveRepostsByBark(
        uint _barkKey
    ) external view returns (Repost[] memory);

    function retrieveCommentsByComment(
        uint _commentKey
    ) external view returns (Comment[] memory);

    function retrieveRepostsByComment(
        uint _commentKey
    ) external view returns (Repost[] memory);

    function retrieveLikesByComment(
        uint _commentKey
    ) external view returns (Like[] memory);

    function barkExists(
        uint _barkKey
    ) external view returns (bool);

    function commentExists(
        uint _commentKey
    ) external view returns (bool);

    function repostExists(
        uint _repostKey
    ) external view returns (bool);

    function likeExists(
        uint _likeKey
    ) external view returns (bool);

    function userExists(
        address payable _addr
    ) external view returns (bool);

    function userExistsById(
        uint _userKey
    ) external view returns (bool);

    function hasLiked(
        uint _postKey,
        bool _isComment,
        uint _userKey
    ) external view returns (int);

    function hasReposted(
        uint _postKey,
        bool _isComment,
        uint _userKey
    ) external view returns (int);

    function retrieveUserByAddress(
        address payable _addr
    ) external view returns (User memory);

    function retrieveUserByKey(
        uint _userKey
    ) external view returns (User memory);

    function isFollowing(
        uint _followerUserKey,
        uint _followingUserKey
    ) external view returns (bool);

    function retrieveFollowersByUser(
        uint _userKey
    ) external view returns (User[] memory);

    function retrieveFollowingByUser(
        uint _userKey
    ) external view returns (User[] memory);

    function getDeployerAddress() external view returns (address payable);
}
