// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Dogger is Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _barks;
    Counters.Counter private _comments;
    Counters.Counter private _reposts;
    Counters.Counter private _likes;
    Counters.Counter private _users;

    address public deployerAddress;

    uint public totalBarks;
    uint public totalComments;
    uint public totalReposts;
    uint public totalLikes;
    uint public totalUsers;

    constructor() {
        deployerAddress = msg.sender;
    }

    struct Bark {
        uint barkKey;
        uint userKey;
        string text;
        uint comments;
        uint reposts;
        uint likes;
        bool isRemoved;
        uint date;
    }

    struct Comment {
        uint commentKey;
        uint barkKey;
        uint userKey;
        uint subcommentKey;
        bool isSubcomment;
        string text;
        uint comments;
        uint reposts;
        uint likes;
        bool isRemoved;
        uint date;
    }

    struct Repost {
        uint repostKey;
        uint postKey;
        uint userKey;
        bool isComment;
        bool isQuote;
        string text;
        bool isRemoved;
        uint date;
    }

    struct Like {
        uint likeKey;
        uint postKey;
        uint userKey;
        bool isComment;
        bool isRemoved;
        uint date;
    }

    struct User {
        uint userKey;
        address payable addr;
        string displayName;
        string username;
        string bio;
        string website;
        string location;
        uint[] followers;
        uint[] following;
        bool isEmpty;
        bool isRemoved;
        uint date;
    }

    mapping(uint => Bark) private bark;
    mapping(uint => Comment) private comment;
    mapping(uint => Repost) private repost;
    mapping(uint => Like) private like;
    mapping(uint => User) private user;

    mapping(address => bool) private restricted;

    event BarkAdded(uint indexed barkKey, uint indexed userKey, string text, uint comments, uint reposts, uint likes, bool isRemoved, uint date);
    event BarkRemoved(uint indexed barkKey, uint indexed userKey, string text, uint comments, uint reposts, uint likes, bool isRemoved, uint date);

    event CommentAdded(uint indexed commentKey, uint indexed barkKey, uint indexed userKey, uint subcommentKey, bool isSubcomment, string text, uint comments, uint reposts, uint likes, bool isRemoved, uint date);
    event CommentRemoved(uint indexed commentKey, uint indexed barkKey, uint indexed userKey, uint subcommentKey, bool isSubcomment, string text, uint comments, uint reposts, uint likes, bool isRemoved, uint date);

    event RepostAdded(uint indexed repostKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isQuote, string text, bool isRemoved, uint date);
    event RepostRemoved(uint indexed repostKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isQuote, string text, bool isRemoved, uint date);

    event LikeAdded(uint indexed likeKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isRemoved, uint date);
    event LikeRemoved(uint indexed likeKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isRemoved, uint date);

    event UserAdded(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);
    event UserUpdated(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);
    event UserRemoved(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);

    function addBark(
        string memory _text
    ) public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(280 >= bytes(_text).length, "Barks must be 280 chars or less");

        _barks.increment();
        uint barkKey = _barks.current();

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        uint date = block.timestamp;
    
        bark[barkKey] = Bark(barkKey, userKey, _text, 0, 0, 0, false, date);

        emit BarkAdded(barkKey, userKey, _text, 0, 0, 0, false, date);
    }

    function removeBark(
        uint _barkKey
    ) public nonReentrant {
        require(barkExists(_barkKey), "This bark doesn't exist");
        require(bark[_barkKey].isRemoved == false, "This bark is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(bark[_barkKey].userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your bark");

        bark[_barkKey].isRemoved = true;

        emit BarkRemoved(_barkKey, bark[_barkKey].userKey, bark[_barkKey].text, bark[_barkKey].comments, bark[_barkKey].reposts, bark[_barkKey].likes, true, block.timestamp);
    }

    function addComment(
        uint _barkKey,
        uint _commentKey,
        bool _isSubcomment,
        string memory _text
    ) public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(barkExists(_barkKey), "This bark doesn't exist");

        if (_isSubcomment) {
            require(commentExists(_commentKey), "This comment doesn't exist");
        }

        require(280 >= bytes(_text).length, "Comments must be 280 chars or less");

        _comments.increment();
        uint commentKey = _comments.current();

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        uint date = block.timestamp;

        uint replyKey = _isSubcomment ? _commentKey : _barkKey;

        bark[_barkKey].comments++;
        if (_isSubcomment) {
            comment[_commentKey].comments++;

            comment[commentKey] = Comment(commentKey, replyKey, userKey, _commentKey, true, _text, 0, 0, 0, false, date);

            emit CommentAdded(commentKey, replyKey, userKey, _commentKey, true, _text, 0, 0, 0, false, date);
        } else {
            comment[commentKey] = Comment(commentKey, replyKey, userKey, 0, false, _text, 0, 0, 0, false, date);

            emit CommentAdded(commentKey, replyKey, userKey, 0, false, _text, 0, 0, 0, false, date);
        }
    }

    function removeComment(
        uint _commentKey
    ) public nonReentrant {
        require(commentExists(_commentKey), "This comment doesn't exist");
        require(comment[_commentKey].isRemoved == false, "This comment is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(comment[_commentKey].userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your comment");

        if (comment[_commentKey].isSubcomment) {
            comment[comment[_commentKey].subcommentKey].comments--;
        }

        bark[comment[_commentKey].barkKey].comments--;

        comment[_commentKey].isRemoved = true;

        emit CommentRemoved(_commentKey, comment[_commentKey].barkKey, comment[_commentKey].userKey, comment[_commentKey].subcommentKey, comment[_commentKey].isSubcomment, comment[_commentKey].text, comment[_commentKey].comments, comment[_commentKey].reposts, comment[_commentKey].likes, true, block.timestamp);
    }

    function addRepost(
        uint _postKey,
        bool _isComment,
        bool _isQuote,
        string memory _text
    ) public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");

        if (_isComment) {
            require(commentExists(_postKey), "This comment doesn't exist");
        } else {
            require(barkExists(_postKey), "This bark doesn't exist");
        }

        if (_isQuote) {
            require(280 >= bytes(_text).length, "Reposts must be 280 chars or less");
        } else {
            _text = "";
        }

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;
        require(!hasReposted(_postKey, _isComment, userKey), "You have already reposted this");

        _reposts.increment();
        uint repostKey = _reposts.current();

        if (_isComment) {
            comment[_postKey].reposts++;
        } else {
            bark[_postKey].reposts++;
        }

        uint date = block.timestamp;
    
        repost[repostKey] = Repost(repostKey, _postKey, userKey, _isComment, _isQuote, _text, false, date);

        emit RepostAdded(repostKey, _postKey, userKey, _isComment, _isQuote, _text, false, date);
    }

    function removeRepost(
        uint _repostKey
    ) public nonReentrant {
        require(repostExists(_repostKey), "This repost doesn't exist");
        require(repost[_repostKey].isRemoved == false, "This repost is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(repost[_repostKey].userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your repost");

        repost[_repostKey].isRemoved = true;

        if (repost[_repostKey].isComment) {
            comment[repost[_repostKey].postKey].reposts--;
        } else {
            bark[repost[_repostKey].postKey].reposts--;
        }

        emit RepostRemoved(_repostKey, repost[_repostKey].postKey, repost[_repostKey].userKey, repost[_repostKey].isComment, repost[_repostKey].isQuote, repost[_repostKey].text, true, block.timestamp);
    }

    function addLike(
        uint _postKey,
        bool _isComment
    ) public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");

        if (_isComment) {
            require(commentExists(_postKey), "This comment doesn't exist");
        } else {
            require(barkExists(_postKey), "This bark doesn't exist");
        }

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;
        require(!hasLiked(_postKey, _isComment, userKey), "You have already liked this");

        _likes.increment();
        uint likeKey = _likes.current();

        uint date = block.timestamp;
    
        like[likeKey] = Like(likeKey, _postKey, userKey, _isComment, false, date);

        emit LikeAdded(likeKey, _postKey, userKey, _isComment, false, date);
    }

    function removeLike(
        uint _likeKey
    ) public nonReentrant {
        require(likeExists(_likeKey), "This like doesn't exist");
        require(like[_likeKey].isRemoved == false, "This like is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(like[_likeKey].userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your like");

        like[_likeKey].isRemoved = true;

        if (like[_likeKey].isComment) {
            comment[like[_likeKey].postKey].likes--;
        } else {
            bark[like[_likeKey].postKey].likes--;
        }

        emit LikeRemoved(_likeKey, like[_likeKey].postKey, like[_likeKey].userKey, like[_likeKey].isComment, true, block.timestamp);
    }

    function addUser(
        string memory _displayName,
        string memory _username,
        string memory _bio
    ) public nonReentrant {
        require(!userExists(payable(msg.sender)), "You already have a profile");
        require(!restricted[msg.sender], "Restricted");
        require(bytes(_displayName).length >= 1 && 32 >= bytes(_displayName).length, "Display names must be 1-32 chars");
        require(bytes(_username).length >= 3 && 32 >= bytes(_username).length, "Usernames must be 3-32 chars");
        require(160 >= bytes(_bio).length, "Bios must be 160 chars or less");

        _users.increment();
        uint userKey = _users.current();

        uint date = block.timestamp;

        uint[] memory empty;

        user[userKey] = User(userKey, payable(msg.sender), _displayName, _username, _bio, "", "", empty, empty, false, false, date);

        emit UserAdded(userKey, payable(msg.sender), _displayName, _username, _bio, "", "", empty, empty, false, false, date);
    }

    function updateUser(
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _website,
        string memory _location
    ) public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(bytes(_displayName).length >= 1 && 32 >= bytes(_displayName).length, "Display names must be 1-32 chars");
        require(bytes(_username).length >= 3 && 32 >= bytes(_username).length, "Usernames must be 3-32 chars");
        require(160 >= bytes(_bio).length, "Bios must be 160 chars or less");
        require(32 >= bytes(_website).length, "Website must be 32 chars or less");
        require(32 >= bytes(_location).length, "Location must be 32 chars or less");

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        user[userKey].displayName = _displayName;
        user[userKey].username = _username;
        user[userKey].bio = _bio;
        user[userKey].website = _website;
        user[userKey].location = _location;

        emit UserUpdated(userKey, payable(msg.sender), _displayName, _username, _bio, _website, _location, user[userKey].followers, user[userKey].following, false, false, user[userKey].date);
    }

    function removeUser() public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        user[userKey].isRemoved = true;

        emit UserRemoved(userKey, payable(msg.sender), user[userKey].displayName, user[userKey].username, user[userKey].bio, user[userKey].website, user[userKey].location, user[userKey].followers, user[userKey].following, false, true, user[userKey].date);
    }

    function followUser(
        uint _userKey
    ) public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(userExistsById(_userKey), "No such user exists");

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        require(!isFollowing(userKey, _userKey), "You are already following this user");

        user[userKey].following.push(_userKey);
        user[_userKey].followers.push(userKey);
    }

    function unfollowUser(
        uint _userKey
    ) public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(userExistsById(_userKey), "No such user exists");

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        require(isFollowing(userKey, _userKey), "You aren't already following this user");

        int followingIndexOf = _indexOf(user[userKey].following, _userKey);
        require (followingIndexOf != -1, "There is an issue with your following list");
        int followersIndexOf = _indexOf(user[_userKey].followers, userKey);
        require (followersIndexOf != -1, "There is an issue with their follower list");

        user[userKey].following[uint(followingIndexOf)] = user[userKey].following[user[userKey].following.length - 1];
        user[userKey].following.pop();
        user[_userKey].followers[uint(followersIndexOf)] = user[_userKey].followers[user[_userKey].followers.length - 1];
        user[_userKey].followers.pop();
    }

    function forceRemoveBark(
        uint _barkKey
    ) external nonReentrant onlyOwner {
        bark[_barkKey].isRemoved = true;

        emit BarkRemoved(_barkKey, bark[_barkKey].userKey, bark[_barkKey].text, bark[_barkKey].comments, bark[_barkKey].reposts, bark[_barkKey].likes, true, block.timestamp);
    }

    function forceRemoveComment(
        uint _commentKey
    ) external nonReentrant onlyOwner {
        comment[_commentKey].isRemoved = true;

        emit CommentRemoved(_commentKey, comment[_commentKey].barkKey, comment[_commentKey].userKey, comment[_commentKey].subcommentKey, comment[_commentKey].isSubcomment, comment[_commentKey].text, comment[_commentKey].comments, comment[_commentKey].reposts, comment[_commentKey].likes, true, block.timestamp);
    }

    function forceRemoveRepost(
        uint _repostKey
    ) external nonReentrant onlyOwner {
        repost[_repostKey].isRemoved = true;

        emit RepostRemoved(_repostKey, repost[_repostKey].postKey, repost[_repostKey].userKey, repost[_repostKey].isComment, repost[_repostKey].isQuote, repost[_repostKey].text, true, block.timestamp);
    }

    function forceRemoveLike(
        uint _likeKey
    ) external nonReentrant onlyOwner {
        like[_likeKey].isRemoved = true;

        emit LikeRemoved(_likeKey, like[_likeKey].postKey, like[_likeKey].userKey, like[_likeKey].isComment, true, block.timestamp);
    }

    function forceRemoveUser(
        uint _userKey
    ) external nonReentrant onlyOwner {
        user[_userKey].isRemoved = true;

        emit UserRemoved(_userKey, user[_userKey].addr, user[_userKey].displayName, user[_userKey].username, user[_userKey].bio, user[_userKey].website, user[_userKey].location, user[_userKey].followers, user[_userKey].following, false, true, user[_userKey].date);
    }

    function restrict(
        address _addr
    ) external nonReentrant onlyOwner {
        restricted[_addr] = !restricted[_addr];
    }

    function sweep() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function isRestricted(
        address _addr
    ) public view returns (bool) {
        return restricted[_addr];
    }

    function retrieveBarksFrom(
        uint _dateFrom
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].isRemoved == false) {
                Bark storage currentItem = bark[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveBarksFromTo(
        uint _dateFrom,
        uint _dateTo
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].date <= _dateTo && bark[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].date <= _dateTo && bark[i + 1].isRemoved == false) {
                Bark storage currentItem = bark[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveBarksFromWithLimit(
        uint _dateFrom,
        uint _limit
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].isRemoved == false) {
                matches += 1;
                if (matches >= _limit) {
                    break;
                }
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].isRemoved == false) {
                Bark storage currentItem = bark[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveBarksFromToWithLimit(
        uint _dateFrom,
        uint _dateTo,
        uint _limit
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].date <= _dateTo && bark[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].date >= _dateFrom && bark[i + 1].date <= _dateTo && bark[i + 1].isRemoved == false) {
                Bark storage currentItem = bark[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
                if (matches >= _limit) {
                    break;
                }
            }
        }

        return items;
    }

    function retrieveBarksWithLimit(
        uint _limit
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].isRemoved == false) {
                matches += 1;
                if (matches >= _limit) {
                    break;
                }
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].isRemoved == false) {
                Bark storage currentItem = bark[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
                if (matches >= _limit) {
                    break;
                }
            }
        }

        return items;
    }

    function retrieveBarksByUser(
        uint _userKey
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].userKey == _userKey && bark[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].userKey == _userKey && bark[i + 1].isRemoved == false) {
                Bark storage currentItem = bark[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveRepostsByUser(
        uint _userKey
    ) public view returns (Repost[] memory) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numReposts; i++) {
            if (repost[i + 1].userKey == _userKey && repost[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Repost[] memory items = new Repost[](matches);
        for (uint i = 0; i < numReposts; i++) {
            if (repost[i + 1].userKey == _userKey && repost[i + 1].isRemoved == false) {
                Repost storage currentItem = repost[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveCommentsByUser(
        uint _userKey
    ) public view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].userKey == _userKey && comment[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].userKey == _userKey && comment[i + 1].isRemoved == false) {
                Comment storage currentItem = comment[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveLikesByUser(
        uint _userKey
    ) public view returns (Like[] memory) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numLikes; i++) {
            if (like[i + 1].userKey == _userKey && like[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Like[] memory items = new Like[](matches);
        for (uint i = 0; i < numLikes; i++) {
            if (like[i + 1].userKey == _userKey && like[i + 1].isRemoved == false) {
                Like storage currentItem = like[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveCommentsByBark(
        uint _barkKey
    ) public view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].barkKey == _barkKey && !comment[i + 1].isSubcomment && comment[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].barkKey == _barkKey && !comment[i + 1].isSubcomment && comment[i + 1].isRemoved == false) {
                Comment storage currentItem = comment[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveCommentsAndSubcommentsByBark(
        uint _barkKey
    ) public view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].barkKey == _barkKey && comment[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].barkKey == _barkKey && comment[i + 1].isRemoved == false) {
                Comment storage currentItem = comment[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveRepostsByBark(
        uint _barkKey
    ) public view returns (Repost[] memory) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numReposts; i++) {
            if (repost[i + 1].postKey == _barkKey && !repost[i + 1].isComment && repost[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Repost[] memory items = new Repost[](matches);
        for (uint i = 0; i < numReposts; i++) {
            if (repost[i + 1].postKey == _barkKey && !repost[i + 1].isComment && repost[i + 1].isRemoved == false) {
                Repost storage currentItem = repost[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveLikesByBark(
        uint _barkKey
    ) public view returns (Like[] memory) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numLikes; i++) {
            if (like[i + 1].postKey == _barkKey && !like[i + 1].isComment && like[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Like[] memory items = new Like[](matches);
        for (uint i = 0; i < numLikes; i++) {
            if (like[i + 1].postKey == _barkKey && !like[i + 1].isComment && like[i + 1].isRemoved == false) {
                Like storage currentItem = like[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveCommentsByComment(
        uint _commentKey
    ) public view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].subcommentKey == _commentKey && comment[i + 1].isSubcomment && comment[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].subcommentKey == _commentKey && comment[i + 1].isSubcomment && comment[i + 1].isRemoved == false) {
                Comment storage currentItem = comment[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveRepostsByComment(
        uint _commentKey
    ) public view returns (Repost[] memory) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numReposts; i++) {
            if (repost[i + 1].postKey == _commentKey && repost[i + 1].isComment && repost[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Repost[] memory items = new Repost[](matches);
        for (uint i = 0; i < numReposts; i++) {
            if (repost[i + 1].postKey == _commentKey && repost[i + 1].isComment && repost[i + 1].isRemoved == false) {
                Repost storage currentItem = repost[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveLikesByComment(
        uint _commentKey
    ) public view returns (Like[] memory) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numLikes; i++) {
            if (like[i + 1].postKey == _commentKey && like[i + 1].isComment && like[i + 1].isRemoved == false) {
                matches += 1;
            }
        }

        Like[] memory items = new Like[](matches);
        for (uint i = 0; i < numLikes; i++) {
            if (like[i + 1].postKey == _commentKey && like[i + 1].isComment && like[i + 1].isRemoved == false) {
                Like storage currentItem = like[i + 1];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function barkExists(
        uint _barkKey
    ) public view returns (bool) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numBarks; i++) {
            if (bark[i + 1].barkKey == _barkKey && bark[i + 1].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function commentExists(
        uint _commentKey
    ) public view returns (bool) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numComments; i++) {
            if (comment[i + 1].commentKey == _commentKey && comment[i + 1].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function repostExists(
        uint _repostKey
    ) public view returns (bool) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numReposts; i++) {
            if (repost[i + 1].repostKey == _repostKey && repost[i + 1].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function likeExists(
        uint _likeKey
    ) public view returns (bool) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numLikes; i++) {
            if (like[i + 1].likeKey == _likeKey && like[i + 1].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function userExists(
        address payable _addr
    ) public view returns (bool) {
        uint numUsers = _users.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numUsers; i++) {
            if (user[i + 1].addr == _addr && user[i + 1].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function userExistsById(
        uint _userKey
    ) public view returns (bool) {
        uint numUsers = _users.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numUsers; i++) {
            if (user[i + 1].userKey == _userKey && user[i + 1].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function hasLiked(
        uint _postKey,
        bool _isComment,
        uint _userKey
    ) public view returns (bool) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        if (_isComment) {
            for (uint i = 0; i < numLikes; i++) {
                if (like[i + 1].postKey == _postKey && like[i + 1].isComment && like[i + 1].userKey == _userKey && like[i + 1].isRemoved == false) {
                    return true;
                }
            }
        } else {
            for (uint i = 0; i < numLikes; i++) {
                if (like[i + 1].postKey == _postKey && !like[i + 1].isComment && like[i + 1].userKey == _userKey && like[i + 1].isRemoved == false) {
                    return true;
                }
            }
        }

        return false;
    }

    function hasReposted(
        uint _postKey,
        bool _isComment,
        uint _userKey
    ) public view returns (bool) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        if (_isComment) {
            for (uint i = 0; i < numReposts; i++) {
                if (repost[i + 1].postKey == _postKey && repost[i + 1].isComment && repost[i + 1].userKey == _userKey && repost[i + 1].isRemoved == false) {
                    return true;
                }
            }
        } else {
            for (uint i = 0; i < numReposts; i++) {
                if (repost[i + 1].postKey == _postKey && !repost[i + 1].isComment && repost[i + 1].userKey == _userKey && repost[i + 1].isRemoved == false) {
                    return true;
                }
            }
        }

        return false;
    }

    function retrieveUserByAddress(
        address payable _addr
    ) public view returns (User memory) {
        uint numUsers = _users.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numUsers; i++) {
            if (user[i + 1].addr == _addr && user[i + 1].isRemoved == false) {
                return user[i + 1];
            }
        }

        User memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function retrieveUserByKey(
        uint _userKey
    ) public view returns (User memory) {
        uint numUsers = _users.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = 0; i < numUsers; i++) {
            if (user[i + 1].userKey == _userKey && user[i + 1].isRemoved == false) {
                return user[i + 1];
            }
        }

        User memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function isFollowing(
        uint _followerUserKey,
        uint _followingUserKey
    ) public view returns (bool) {
        uint numUsers = _users.current();
        uint matches = 0;
        uint cursor = 0;

        uint[] memory followers = user[_followingUserKey].followers;
        uint numFollowers = followers.length;

        for (uint i = 0; i < numFollowers; i++) {
            if (user[followers[i]].isRemoved == false) {
                matches += 1;
            }
        }

        User[] memory items = new User[](matches);
        for (uint i = 0; i < numFollowers; i++) {
            if (user[followers[i]].isRemoved == false) {
                User storage currentItem = user[followers[i]];
                items[cursor] = currentItem;
                cursor += 1;
                if (currentItem.userKey == _followerUserKey) {
                    return true;
                }
            }
        }

        return false;
    }

    function retrieveFollowersByUser(
        uint _userKey
    ) public view returns (User[] memory) {
        uint numUsers = _users.current();
        uint matches = 0;
        uint cursor = 0;

        uint[] memory followers = user[_userKey].followers;
        uint numFollowers = followers.length;

        for (uint i = 0; i < numFollowers; i++) {
            if (user[followers[i]].isRemoved == false) {
                matches += 1;
            }
        }

        User[] memory items = new User[](matches);
        for (uint i = 0; i < numFollowers; i++) {
            if (user[followers[i]].isRemoved == false) {
                User storage currentItem = user[followers[i]];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveFollowingByUser(
        uint _userKey
    ) public view returns (User[] memory) {
        uint numUsers = _users.current();
        uint matches = 0;
        uint cursor = 0;

        uint[] memory following = user[_userKey].following;
        uint numFollowers = following.length;

        for (uint i = 0; i < numFollowers; i++) {
            if (user[following[i]].isRemoved == false) {
                matches += 1;
            }
        }

        User[] memory items = new User[](matches);
        for (uint i = 0; i < numFollowers; i++) {
            if (user[following[i]].isRemoved == false) {
                User storage currentItem = user[following[i]];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function _indexOf(uint[] memory arr, uint searchFor) private pure returns (int) {
        uint len = arr.length;
        for (uint i = 0; i < len; i++) {
            if (arr[i] == searchFor) {
                return int(i);
            }
        }
        return -1;
    }

    function exportBarks() public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint cursor = 0;
    
        Bark[] memory items = new Bark[](numBarks);
        for (uint i = 0; i < numBarks; i++) {
            Bark storage currentItem = bark[i + 1];
            items[cursor] = currentItem;
            cursor += 1;
        }

        return items;
    }

    function exportComments() public view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint cursor = 0;
    
        Comment[] memory items = new Comment[](numComments);
        for (uint i = 0; i < numComments; i++) {
            Comment storage currentItem = comment[i + 1];
            items[cursor] = currentItem;
            cursor += 1;
        }

        return items;
    }

    function exportReposts() public view returns (Repost[] memory) {
        uint numReposts = _reposts.current();
        uint cursor = 0;
    
        Repost[] memory items = new Repost[](numReposts);
        for (uint i = 0; i < numReposts; i++) {
            Repost storage currentItem = repost[i + 1];
            items[cursor] = currentItem;
            cursor += 1;
        }

        return items;
    }

    function exportLikes() public view returns (Like[] memory) {
        uint numLikes = _likes.current();
        uint cursor = 0;
    
        Like[] memory items = new Like[](numLikes);
        for (uint i = 0; i < numLikes; i++) {
            Like storage currentItem = like[i + 1];
            items[cursor] = currentItem;
            cursor += 1;
        }

        return items;
    }

    function exportUsers() public view returns (User[] memory) {
        uint numUsers = _users.current();
        uint cursor = 0;
    
        User[] memory items = new User[](numUsers);
        for (uint i = 0; i < numUsers; i++) {
            User storage currentItem = user[i + 1];
            items[cursor] = currentItem;
            cursor += 1;
        }

        return items;
    }

    function getDeployerAddress() public view returns (address payable) {
        return payable(deployerAddress);
    }
}
