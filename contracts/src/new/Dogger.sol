// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

import "./ReentrancyGuard.sol";

abstract contract AccessController is Context, ReentrancyGuard {
    mapping(address => bool) private mod;
    mapping(address => bool) private admin;
    address private platform = 0xA718C46D3468Ccf685CC2aFEC5d541EB45D7127d;

    modifier onlyMod() {
        require(isMod(_msgSender()) || isAdmin(_msgSender()), "Caller is not a mod");
        _;
    }

    modifier onlyAdmin() {
        require(isAdmin(_msgSender()), "Caller is not an admin");
        _;
    }

    modifier onlyPlatform() {
        require(_msgSender() == platform, "Caller is not the platform");
        _;
    }

    function isMod(
        address _addr
    ) public view returns (bool) {
        return mod[_addr];
    }

    function isAdmin(
        address _addr
    ) public view returns (bool) {
        return admin[_addr];
    }

    function isPlatform(
        address _addr
    ) public view returns (bool) {
        return platform == _addr;
    }

    function getPlatform() external view returns (address) {
        return platform;
    }

    function toggleMod(
        address _addr
    ) external nonReentrant onlyAdmin {
        mod[_addr] = !mod[_addr];
    }

    function toggleAdmin(
        address _addr
    ) external nonReentrant onlyPlatform {
        admin[_addr] = !admin[_addr];
    }

    function changePlatform(
        address _addr
    ) external nonReentrant onlyPlatform {
        platform = _addr;
    }
}

import "./Structs.sol";
import "./Ownable.sol";
import "./IERC20.sol";

library Barks {
    using Counters for Counters.Counter;

    struct BarkSet {
        Counters.Counter _barks;
        Bark[] barks;
    }

    struct Bark {
        uint barkKey;
        uint userKey;
        string text;
        bool isMedia;
        string ipfs;
        uint comments;
        uint reposts;
        uint likes;
        bool isEmpty;
        bool isRemoved;
        uint date;
    }

    function add(
        uint userKey,
        string memory _text,
        bool _isMedia,
        string memory _ipfs,
        uint date
    ) public returns (uint) {
        _barks.increment();
        uint barkKey = _barks.current();
        bark[barkKey] = Bark(barkKey, userKey, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);

        return barkKey;
    }

    function remove(
        uint _barkKey
    ) public {
        bark[_barkKey].isRemoved = true;
    }

    function get(
        uint _barkKey
    ) public view returns (Bark memory) {
        //
    }

    function current() public view returns (uint) {
        return _barks.current();
    }

    function incComments(
        uint _barkKey
    ) public {
        bark[_barkKey].comments++;
    }

    function decComments(
        uint _barkKey
    ) public {
        bark[_barkKey].comments--;
    }

    function incReposts(
        uint _barkKey
    ) public {
        bark[_barkKey].reposts++;
    }

    function decReposts(
        uint _barkKey
    ) public {
        bark[_barkKey].reposts--;
    }

    function incLikes(
        uint _barkKey
    ) public {
        bark[_barkKey].likes++;
    }

    function decLikes(
        uint _barkKey
    ) public {
        bark[_barkKey].likes--;
    }

    function retrieveBarksWithLimit(
        uint _limit
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].isRemoved == false) {
                matches += 1;
                if (matches >= _limit) {
                    break;
                }
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].isRemoved == false) {
                Bark storage currentItem = bark[i];
                items[cursor] = currentItem;
                cursor += 1;
                if (cursor >= _limit) {
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

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].userKey == _userKey && bark[i].isRemoved == false) {
                matches += 1;
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].userKey == _userKey && bark[i].isRemoved == false) {
                Bark storage currentItem = bark[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveBarkByKey(
        uint _barkKey
    ) public view returns (Bark memory) {
        uint numBarks = _barks.current();

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].barkKey == _barkKey && bark[i].isRemoved == false) {
                return bark[i];
            }
        }

        Bark memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function barkExists(
        uint _barkKey
    ) public view returns (bool) {
        uint numBarks = _barks.current();

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].barkKey == _barkKey && bark[i].isRemoved == false) {
                return true;
            }
        }

        return false;
    }
}

contract Dogger is ReentrancyGuard, Ownable, AccessController {
    using Counters for Counters.Counter;
    Counters.Counter private _comments;
    Counters.Counter private _reposts;
    Counters.Counter private _likes;
    Counters.Counter private _users;

    using Barks for Barks.Bark;
    Barks.Bark private _barks;

    address private immutable deployerAddress;
    bool private mediaEnabled = true;
    bool private paused = false;

    //uint public totalBarks;
    //uint public totalComments;
    //uint public totalReposts;
    //uint public totalLikes;
    //uint public totalUsers;

    constructor() {
        deployerAddress = msg.sender;
    }

    mapping(uint => Comment) private comment;
    mapping(uint => Repost) private repost;
    mapping(uint => Like) private like;
    mapping(uint => User) private user;

    mapping(address => bool) private restricted;

    mapping(address => bool) private whitelist;

    function toggleWhitelist(
        address _whitelist
    ) external nonReentrant onlyOwner {
        whitelist[_whitelist] = !whitelist[_whitelist];
    }

    function isWhitelisted(
        address _whitelist
    ) external view returns (bool) {
        return whitelist[_whitelist];
    }

    function addBark(
        uint userKey,
        string memory _text,
        bool _isMedia,
        string memory _ipfs,
        uint date
    ) external nonReentrant returns (uint) {
        require(whitelist[msg.sender]);
        return _barks.add(userKey, _text, _isMedia, _ipfs, date);
    }

    function removeBark(
        uint _barkKey
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        _barks.remove(_barkKey);
    }

    function addComment(
        uint userKey,
        uint _barkKey,
        bool _isSubcomment,
        uint _commentKey,
        string memory _text,
        bool _isMedia,
        string memory _ipfs,
        uint date
    ) external nonReentrant returns (uint) {
        _comments.increment();
        uint commentKey = _comments.current();

        _barks.incComments(_barkKey);

        if (!_isSubcomment) {
            _commentKey = 0;
        } else {
            comment[_commentKey].comments++;
        }

        comment[commentKey] = Comment(commentKey, _barkKey, userKey, _commentKey, _isSubcomment, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);

        return commentKey;
    }

    function removeComment(
        uint _commentKey
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        Comment memory _comment = retrieveCommentByKey(_commentKey);

        if (_comment.isSubcomment) {
            comment[_comment.subcommentKey].comments--;
        }

        _barks.decComments(_commentKey);

        comment[_commentKey].isRemoved = true;
    }

    function addRepost(
        bool _isComment,
        uint _postKey,
        uint userKey,
        bool _isQuote,
        string memory _text,
        uint date
    ) external nonReentrant returns (uint) {
        require(whitelist[msg.sender]);
        _reposts.increment();
        uint repostKey = _reposts.current();

        if (_isComment) {
            comment[_postKey].reposts++;
        } else {
            _barks.incReposts(_postKey);
        }

        repost[repostKey] = Repost(repostKey, _postKey, userKey, _isComment, _isQuote, _text, false, false, date);

        return repostKey;
    }

    function removeRepost(
        uint _repostKey
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        repost[_repostKey].isRemoved = true;

        Repost memory _repost = repost[_repostKey];

        if (_repost.isComment) {
            comment[_repost.postKey].reposts--;
        } else {
            _barks.decReposts(_repost.postKey);
        }
    }

    function addLike(
        bool _isComment,
        uint _postKey,
        uint userKey,
        uint date
    ) external nonReentrant returns (uint) {
        require(whitelist[msg.sender]);
        _likes.increment();
        uint likeKey = _likes.current();

        if (_isComment) {
            comment[_postKey].likes++;
        } else {
            _barks.incComments(_postKey);
        }
    
        like[likeKey] = Like(likeKey, _postKey, userKey, _isComment, false, false, date);

        return likeKey;
    }

    function removeLike(
        uint _likeKey
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        like[_likeKey].isRemoved = true;
        Like memory _like = like[_likeKey];

        if (_like.isComment) {
            comment[_like.postKey].likes--;
        } else {
            _barks.decLikes(_like.postKey);
        }
    }

    function addUser(
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _ipfsProfile,
        string memory _ipfsBanner,
        uint date
    ) external nonReentrant returns (uint) {
        require(whitelist[msg.sender]);
        _users.increment();
        uint userKey = _users.current();

        uint[] memory empty;

        user[userKey] = User(userKey, payable(msg.sender), _displayName, _username, _bio, "", "", _ipfsProfile, _ipfsBanner, empty, empty, false, false, date);

        return userKey;
    }

    function updateUser(
        uint userKey,
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _website,
        string memory _location,
        string memory _ipfsProfile,
        string memory _ipfsBanner
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        user[userKey].displayName = _displayName;
        user[userKey].username = _username;
        user[userKey].bio = _bio;
        user[userKey].website = _website;
        user[userKey].location = _location;
        if (mediaEnabled) {
            user[userKey].ipfsProfile = _ipfsProfile;
            user[userKey].ipfsBanner = _ipfsBanner;
        }
    }

    function removeUser(
        uint _userKey
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        user[_userKey].isRemoved = true;
    }

    function followUser(
        uint _userKey,
        uint userKey
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        user[userKey].following.push(_userKey);
        user[_userKey].followers.push(userKey);
    }

    function unfollowUser(
        uint _userKey,
        uint userKey
    ) external nonReentrant {
        require(whitelist[msg.sender]);
        int followingIndexOf = _indexOf(user[userKey].following, _userKey);
        require (followingIndexOf != -1);
        int followersIndexOf = _indexOf(user[_userKey].followers, userKey);
        require (followersIndexOf != -1);

        user[userKey].following[uint(followingIndexOf)] = user[userKey].following[user[userKey].following.length - 1];
        user[userKey].following.pop();
        user[_userKey].followers[uint(followersIndexOf)] = user[_userKey].followers[user[_userKey].followers.length - 1];
        user[_userKey].followers.pop();
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

    function forceRemoveBarks(
        uint[] memory _barkKeys
    ) external nonReentrant onlyMod {
        uint numBarks = _barkKeys.length;

        for (uint i = 0; i < numBarks; i++) {
            _barks.remove(_barkKeys[i]);

            //Bark memory _bark = bark[_barkKeys[i]];
        }
    }

    function forceRemoveComments(
        uint[] memory _commentKeys
    ) external nonReentrant onlyMod {
        uint numComments = _commentKeys.length;

        for (uint i = 0; i < numComments; i++) {
            comment[_commentKeys[i]].isRemoved = true;

            //Comment memory _comment = comment[_commentKeys[i]];
        }
    }

    function forceRemoveReposts(
        uint[] memory _repostKeys
    ) external nonReentrant onlyMod {
        uint numReposts = _repostKeys.length;

        for (uint i = 0; i < numReposts; i++) {
            repost[_repostKeys[i]].isRemoved = true;

            //Repost memory _repost = repost[_repostKeys[i]];
        }
    }

    function forceRemoveLikes(
        uint[] memory _likeKeys
    ) external nonReentrant onlyMod {
        uint numLikes = _likeKeys.length;

        for (uint i = 0; i < numLikes; i++) {
            like[_likeKeys[i]].isRemoved = true;

            //Like memory _like = like[_likeKeys[i]];
        }
    }

    function forceRemoveUsers(
        uint[] memory _userKeys
    ) external nonReentrant onlyMod {
        uint numUsers = _userKeys.length;

        for (uint i = 0; i < numUsers; i++) {
            user[_userKeys[i]].isRemoved = true;

            //User memory _user = user[_userKeys[i]];
        }
    }

    function restrict(
        address _addr
    ) external nonReentrant onlyMod {
        restricted[_addr] = !restricted[_addr];
    }

    function toggleMedia() external nonReentrant onlyAdmin {
        mediaEnabled = !mediaEnabled;
    }

    function togglePaused() external nonReentrant onlyOwner {
        paused = !paused;
    }

    function sweep() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function approveToken(
        address _token,
        address _spender,
        uint _amount
    ) external onlyOwner {
        IERC20(_token).approve(_spender, _amount);
    }

    function rescueToken(
        address _token,
        uint _amount
    ) external onlyOwner {
        IERC20(_token).transfer(msg.sender, _amount);
    }

    function isRestricted(
        address _addr
    ) external view returns (bool) {
        return restricted[_addr];
    }

    function isMediaEnabled() external view returns (bool) {
        return mediaEnabled;
    }

    function isPaused() external view returns (bool) {
        return paused;
    }

    function retrieveRepostsByUser(
        uint _userKey
    ) external view returns (Repost[] memory) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].userKey == _userKey && repost[i].isRemoved == false) {
                matches += 1;
            }
        }

        Repost[] memory items = new Repost[](matches);
        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].userKey == _userKey && repost[i].isRemoved == false) {
                Repost storage currentItem = repost[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveRepostByKey(
        uint _repostKey
    ) external view returns (Repost memory) {
        uint numReposts = _reposts.current();

        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].repostKey == _repostKey && repost[i].isRemoved == false) {
                return repost[i];
            }
        }

        Repost memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function retrieveCommentsByUser(
        uint _userKey
    ) external view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numComments; i > 0; i--) {
            if (comment[i].userKey == _userKey && comment[i].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = numComments; i > 0; i--) {
            if (comment[i].userKey == _userKey && comment[i].isRemoved == false) {
                Comment storage currentItem = comment[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveCommentByKey(
        uint _commentKey
    ) public view returns (Comment memory) {
        uint numComments = _comments.current();

        for (uint i = numComments; i > 0; i--) {
            if (comment[i].commentKey == _commentKey && comment[i].isRemoved == false) {
                return comment[i];
            }
        }

        Comment memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function retrieveLikesByUser(
        uint _userKey
    ) external view returns (Like[] memory) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numLikes; i > 0; i--) {
            if (like[i].userKey == _userKey && like[i].isRemoved == false) {
                matches += 1;
            }
        }

        Like[] memory items = new Like[](matches);
        for (uint i = numLikes; i > 0; i--) {
            if (like[i].userKey == _userKey && like[i].isRemoved == false) {
                Like storage currentItem = like[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveLikeByKey(
        uint _likeKey
    ) external view returns (Like memory) {
        uint numLikes = _likes.current();

        for (uint i = numLikes; i > 0; i--) {
            if (like[i].likeKey == _likeKey && like[i].isRemoved == false) {
                return like[i];
            }
        }

        Like memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function retrieveCommentsByBark(
        uint _barkKey
    ) external view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numComments; i > 0; i--) {
            if (comment[i].barkKey == _barkKey && !comment[i].isSubcomment && comment[i].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = numComments; i > 0; i--) {
            if (comment[i].barkKey == _barkKey && !comment[i].isSubcomment && comment[i].isRemoved == false) {
                Comment storage currentItem = comment[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveCommentsAndSubcommentsByBark(
        uint _barkKey
    ) external view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numComments; i > 0; i--) {
            if (comment[i].barkKey == _barkKey && comment[i].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = numComments; i > 0; i--) {
            if (comment[i].barkKey == _barkKey && comment[i].isRemoved == false) {
                Comment storage currentItem = comment[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveRepostsByBark(
        uint _barkKey
    ) external view returns (Repost[] memory) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].postKey == _barkKey && !repost[i].isComment && repost[i].isRemoved == false) {
                matches += 1;
            }
        }

        Repost[] memory items = new Repost[](matches);
        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].postKey == _barkKey && !repost[i].isComment && repost[i].isRemoved == false) {
                Repost storage currentItem = repost[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveLikesByBark(
        uint _barkKey
    ) external view returns (Like[] memory) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numLikes; i > 0; i--) {
            if (like[i].postKey == _barkKey && !like[i].isComment && like[i].isRemoved == false) {
                matches += 1;
            }
        }

        Like[] memory items = new Like[](matches);
        for (uint i = numLikes; i > 0; i--) {
            if (like[i].postKey == _barkKey && !like[i].isComment && like[i].isRemoved == false) {
                Like storage currentItem = like[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveCommentsByComment(
        uint _commentKey
    ) external view returns (Comment[] memory) {
        uint numComments = _comments.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numComments; i > 0; i--) {
            if (comment[i].subcommentKey == _commentKey && comment[i].isSubcomment && comment[i].isRemoved == false) {
                matches += 1;
            }
        }

        Comment[] memory items = new Comment[](matches);
        for (uint i = numComments; i > 0; i--) {
            if (comment[i].subcommentKey == _commentKey && comment[i].isSubcomment && comment[i].isRemoved == false) {
                Comment storage currentItem = comment[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveRepostsByComment(
        uint _commentKey
    ) external view returns (Repost[] memory) {
        uint numReposts = _reposts.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].postKey == _commentKey && repost[i].isComment && repost[i].isRemoved == false) {
                matches += 1;
            }
        }

        Repost[] memory items = new Repost[](matches);
        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].postKey == _commentKey && repost[i].isComment && repost[i].isRemoved == false) {
                Repost storage currentItem = repost[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveLikesByComment(
        uint _commentKey
    ) external view returns (Like[] memory) {
        uint numLikes = _likes.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numLikes; i > 0; i--) {
            if (like[i].postKey == _commentKey && like[i].isComment && like[i].isRemoved == false) {
                matches += 1;
            }
        }

        Like[] memory items = new Like[](matches);
        for (uint i = numLikes; i > 0; i--) {
            if (like[i].postKey == _commentKey && like[i].isComment && like[i].isRemoved == false) {
                Like storage currentItem = like[i];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function commentExists(
        uint _commentKey
    ) external view returns (bool) {
        uint numComments = _comments.current();

        for (uint i = numComments; i > 0; i--) {
            if (comment[i].commentKey == _commentKey && comment[i].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function repostExists(
        uint _repostKey
    ) external view returns (bool) {
        uint numReposts = _reposts.current();

        for (uint i = numReposts; i > 0; i--) {
            if (repost[i].repostKey == _repostKey && repost[i].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function likeExists(
        uint _likeKey
    ) external view returns (bool) {
        uint numLikes = _likes.current();

        for (uint i = numLikes; i > 0; i--) {
            if (like[i].likeKey == _likeKey && like[i].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function userExists(
        address payable _addr
    ) external view returns (bool) {
        uint numUsers = _users.current();

        for (uint i = numUsers; i > 0; i--) {
            if (user[i].addr == _addr && user[i].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function userExistsById(
        uint _userKey
    ) external view returns (bool) {
        uint numUsers = _users.current();

        for (uint i = numUsers; i > 0; i--) {
            if (user[i].userKey == _userKey && user[i].isRemoved == false) {
                return true;
            }
        }

        return false;
    }

    function hasLiked(
        uint _postKey,
        bool _isComment,
        uint _userKey
    ) external view returns (int) {
        uint numLikes = _likes.current();

        if (_isComment) {
            for (uint i = numLikes; i > 0; i--) {
                if (like[i].postKey == _postKey && like[i].isComment && like[i].userKey == _userKey && like[i].isRemoved == false) {
                    return int(like[i].likeKey);
                }
            }
        } else {
            for (uint i = numLikes; i > 0; i--) {
                if (like[i].postKey == _postKey && !like[i].isComment && like[i].userKey == _userKey && like[i].isRemoved == false) {
                    return int(like[i].likeKey);
                }
            }
        }

        return -1;
    }

    function hasReposted(
        uint _postKey,
        bool _isComment,
        uint _userKey
    ) external view returns (int) {
        uint numReposts = _reposts.current();

        if (_isComment) {
            for (uint i = numReposts; i > 0; i--) {
                if (repost[i].postKey == _postKey && repost[i].isComment && repost[i].userKey == _userKey && repost[i].isRemoved == false) {
                    return int(repost[i].repostKey);
                }
            }
        } else {
            for (uint i = numReposts; i > 0; i--) {
                if (repost[i].postKey == _postKey && !repost[i].isComment && repost[i].userKey == _userKey && repost[i].isRemoved == false) {
                    return int(repost[i].repostKey);
                }
            }
        }

        return -1;
    }

    function retrieveUserByAddress(
        address payable _addr
    ) external view returns (User memory) {
        uint numUsers = _users.current();

        for (uint i = numUsers; i > 0; i--) {
            if (user[i].addr == _addr && user[i].isRemoved == false) {
                return user[i];
            }
        }

        User memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function retrieveUserByKey(
        uint _userKey
    ) external view returns (User memory) {
        uint numUsers = _users.current();

        for (uint i = numUsers; i > 0; i--) {
            if (user[i].userKey == _userKey && user[i].isRemoved == false) {
                return user[i];
            }
        }

        User memory emptyObj;
        emptyObj.isEmpty = true;
        return emptyObj;
    }

    function isFollowing(
        uint _followerUserKey,
        uint _followingUserKey
    ) external view returns (bool) {
        uint matches = 0;
        uint cursor = 0;

        uint[] memory followers = user[_followingUserKey].followers;
        uint numFollowers = followers.length;

        for (uint i = numFollowers; i > 0; i--) {
            if (user[followers[i - 1]].isRemoved == false) {
                matches += 1;
            }
        }

        User[] memory items = new User[](matches);
        for (uint i = numFollowers; i > 0; i--) {
            if (user[followers[i - 1]].isRemoved == false) {
                User storage currentItem = user[followers[i - 1]];
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
    ) external view returns (User[] memory) {
        uint matches = 0;
        uint cursor = 0;

        uint[] memory followers = user[_userKey].followers;
        uint numFollowers = followers.length;

        for (uint i = numFollowers; i > 0; i--) {
            if (user[followers[i - 1]].isRemoved == false) {
                matches += 1;
            }
        }

        User[] memory items = new User[](matches);
        for (uint i = numFollowers; i > 0; i--) {
            if (user[followers[i - 1]].isRemoved == false) {
                User storage currentItem = user[followers[i - 1]];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function retrieveFollowingByUser(
        uint _userKey
    ) external view returns (User[] memory) {
        uint matches = 0;
        uint cursor = 0;

        uint[] memory following = user[_userKey].following;
        uint numFollowing = following.length;

        for (uint i = numFollowing; i > 0; i--) {
            if (user[following[i - 1]].isRemoved == false) {
                matches += 1;
            }
        }

        User[] memory items = new User[](matches);
        for (uint i = numFollowing; i > 0; i--) {
            if (user[following[i - 1]].isRemoved == false) {
                User storage currentItem = user[following[i - 1]];
                items[cursor] = currentItem;
                cursor += 1;
            }
        }

        return items;
    }

    function getDeployerAddress() external view returns (address payable) {
        return payable(deployerAddress);
    }
}
