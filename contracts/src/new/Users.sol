// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ReentrancyGuard.sol";
import "./IDogger.sol";

contract Users is ReentrancyGuard {
    event UserAdded(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, string ipfsProfile, string ipfsBanner, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);
    event UserUpdated(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, string ipfsProfile, string ipfsBanner, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);
    event UserRemoved(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, string ipfsProfile, string ipfsBanner, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);

    address doggerAddress;
    IDogger dogger;

    constructor(
        address _doggerAddress
    ) {
        doggerAddress = _doggerAddress;
        dogger = IDogger(doggerAddress);
    }

    function addUser(
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _ipfsProfile,
        string memory _ipfsBanner
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(!dogger.userExists(payable(msg.sender)), "You already have a profile");
        require(!dogger.isRestricted(msg.sender), "Restricted");
        require(bytes(_displayName).length >= 1 && 32 >= bytes(_displayName).length, "Display names must be 1-32 chars");
        require(bytes(_username).length >= 3 && 32 >= bytes(_username).length, "Usernames must be 3-32 chars");
        require(160 >= bytes(_bio).length, "Bios must be 160 chars or less");
        require(64 >= bytes(_ipfsProfile).length, "Profile content hashes cannot exceed 64 chars");
        require(64 >= bytes(_ipfsBanner).length, "Banner content hashes cannot exceed 64 chars");

        uint date = block.timestamp;

        (, bytes memory data) = doggerAddress.call(
            abi.encodeWithSignature("addUser(string,string,string,string,string,uint256)", _displayName, _username, _bio, _ipfsProfile, _ipfsBanner, date)
        );

        uint userKey;
        assembly {
            userKey := mload(add(data, add(0x20, 0)))
        }

        uint[] memory empty;

        emit UserAdded(userKey, payable(msg.sender), _displayName, _username, _bio, "", "", _ipfsProfile, _ipfsBanner, empty, empty, false, false, date);
    }

    function updateUser(
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _website,
        string memory _location,
        string memory _ipfsProfile,
        string memory _ipfsBanner
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(bytes(_displayName).length >= 1 && 32 >= bytes(_displayName).length, "Display names must be 1-32 chars");
        require(bytes(_username).length >= 3 && 32 >= bytes(_username).length, "Usernames must be 3-32 chars");
        require(160 >= bytes(_bio).length, "Bios must be 160 chars or less");
        require(32 >= bytes(_website).length, "Website must be 32 chars or less");
        require(32 >= bytes(_location).length, "Location must be 32 chars or less");

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;

        if (dogger.isMediaEnabled()) {
            require(64 >= bytes(_ipfsProfile).length, "Profile content hashes cannot exceed 64 chars");
            require(64 >= bytes(_ipfsBanner).length, "Banner content hashes cannot exceed 64 chars");
        }

        doggerAddress.call(
            abi.encodeWithSignature("updateUser(uint,string,string,string,string,string,string,string,uint)", userKey, _displayName, _username, _bio, _website, _location, _ipfsProfile, _ipfsBanner)
        );

        User memory _user = dogger.retrieveUserByKey(userKey);

        emit UserUpdated(userKey, payable(msg.sender), _displayName, _username, _bio, _website, _location, _ipfsProfile, _ipfsBanner, _user.followers, _user.following, false, false, _user.date);
    }

    function removeUser() public nonReentrant {
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;

        doggerAddress.call(
            abi.encodeWithSignature("removeUser(uint256)", userKey)
        );

        User memory _user = dogger.retrieveUserByKey(userKey);

        emit UserRemoved(userKey, payable(msg.sender), _user.displayName, _user.username, _user.bio, _user.website, _user.location, _user.ipfsProfile, _user.ipfsBanner, _user.followers, _user.following, false, true, _user.date);
    }

    function followUser(
        uint _userKey
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(dogger.userExistsById(_userKey), "No such user exists");

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;

        require(userKey != _userKey, "You cannot follow yourself");
        require(!dogger.isFollowing(userKey, _userKey), "You are already following this user");

        doggerAddress.call(
            abi.encodeWithSignature("followUser(uint,uint)", _userKey, userKey)
        );
    }

    function unfollowUser(
        uint _userKey
    ) public nonReentrant {
        require(!dogger.isPaused(), "This contract is paused");
        require(dogger.userExists(payable(msg.sender)), "You don't have a profile");
        require(dogger.userExistsById(_userKey), "No such user exists");

        uint userKey = dogger.retrieveUserByAddress(payable(msg.sender)).userKey;

        require(userKey != _userKey, "You cannot unfollow yourself");
        require(dogger.isFollowing(userKey, _userKey), "You aren't already following this user");

        doggerAddress.call(
            abi.encodeWithSignature("unfollowUser(uint,uint)", _userKey, userKey)
        );
    }
}
