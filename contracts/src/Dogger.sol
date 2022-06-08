// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

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

    function getPlatform() public view returns (address) {
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

struct Comment {
    uint commentKey;
    uint barkKey;
    uint userKey;
    uint subcommentKey;
    bool isSubcomment;
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
    string ipfsProfile;
    string ipfsBanner;
    uint[] followers;
    uint[] following;
    bool isEmpty;
    bool isRemoved;
    uint date;
}

contract Dogger is Ownable, ReentrancyGuard, AccessController {
    using Counters for Counters.Counter;
    Counters.Counter internal _barks;
    Counters.Counter internal _comments;
    Counters.Counter internal _reposts;
    Counters.Counter internal _likes;
    Counters.Counter internal _users;

    address public immutable deployerAddress;
    bool public mediaEnabled = true;
    bool public paused = false;

    constructor() {
        deployerAddress = msg.sender;
    }

    mapping(uint => Bark) internal bark;
    mapping(uint => Comment) internal comment;
    mapping(uint => Repost) internal repost;
    mapping(uint => Like) internal like;
    mapping(uint => User) internal user;

    mapping(address => bool) private restricted;

    event BarkAdded(uint indexed barkKey, uint indexed userKey, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isRemoved, bool isEmpty, uint date);
    event BarkRemoved(uint indexed barkKey, uint indexed userKey, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isRemoved, bool isEmpty, uint date);

    event CommentAdded(uint indexed commentKey, uint indexed barkKey, uint indexed userKey, uint subcommentKey, bool isSubcomment, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isEmpty, bool isRemoved, uint date);
    event CommentRemoved(uint indexed commentKey, uint indexed barkKey, uint indexed userKey, uint subcommentKey, bool isSubcomment, string text, bool isMedia, string ipfs, uint comments, uint reposts, uint likes, bool isEmpty, bool isRemoved, uint date);

    event RepostAdded(uint indexed repostKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isQuote, string text, bool isRemoved, uint date);
    event RepostRemoved(uint indexed repostKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isQuote, string text, bool isRemoved, uint date);

    event LikeAdded(uint indexed likeKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isRemoved, uint date);
    event LikeRemoved(uint indexed likeKey, uint indexed postKey, uint indexed userKey, bool isComment, bool isRemoved, uint date);

    event UserAdded(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, string ipfsProfile, string ipfsBanner, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);
    event UserUpdated(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, string ipfsProfile, string ipfsBanner, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);
    event UserRemoved(uint indexed userKey, address payable addr, string displayName, string username, string bio, string website, string location, string ipfsProfile, string ipfsBanner, uint[] followers, uint[] following, bool isEmpty, bool isRemoved, uint date);

    function addBark(
        string memory _text,
        bool _isMedia,
        string memory _ipfs
    ) public nonReentrant {
        require(!paused, "This contract is paused");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(280 >= bytes(_text).length, "Barks must be 280 chars or less");

        if (_isMedia) {
            require(mediaEnabled, "Media posting is currently disabled");
            require(64 >= bytes(_ipfs).length, "Content hash cannot exceed 64 chars");
        } else {
            _ipfs = "";
        }

        _barks.increment();
        uint barkKey = _barks.current();

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        uint date = block.timestamp;

        bark[barkKey] = Bark(barkKey, userKey, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);

        emit BarkAdded(barkKey, userKey, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);
    }

    function removeBark(
        uint _barkKey
    ) public nonReentrant {
        require(barkExists(_barkKey), "This bark doesn't exist");
        Bark memory _bark = bark[_barkKey];
        require(_bark.isRemoved == false, "This bark is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(_bark.userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your bark");

        bark[_barkKey].isRemoved = true;

        emit BarkRemoved(_barkKey, _bark.userKey, _bark.text, _bark.isMedia, _bark.ipfs, _bark.comments, _bark.reposts, _bark.likes, false, true, block.timestamp);
    }

    function addComment(
        uint _barkKey,
        uint _commentKey,
        bool _isSubcomment,
        string memory _text,
        bool _isMedia,
        string memory _ipfs
    ) public nonReentrant {
        require(!paused, "This contract is paused");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(barkExists(_barkKey), "This bark doesn't exist");

        if (_isMedia) {
            require(mediaEnabled, "Media posting is currently disabled");
            require(64 >= bytes(_ipfs).length, "Content hash cannot exceed 64 chars");
        } else {
            _ipfs = "";
        }

        if (_isSubcomment) {
            require(commentExists(_commentKey), "This comment doesn't exist");
        }

        require(280 >= bytes(_text).length, "Comments must be 280 chars or less");

        _comments.increment();
        uint commentKey = _comments.current();

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        uint date = block.timestamp;

        bark[_barkKey].comments++;

        if (!_isSubcomment) {
            _commentKey = 0;
        } else {
            comment[_commentKey].comments++;
        }

        comment[commentKey] = Comment(commentKey, _barkKey, userKey, _commentKey, _isSubcomment, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);

        emit CommentAdded(commentKey, _barkKey, userKey, _commentKey, _isSubcomment, _text, _isMedia, _ipfs, 0, 0, 0, false, false, date);
    }

    function removeComment(
        uint _commentKey
    ) public nonReentrant {
        require(commentExists(_commentKey), "This comment doesn't exist");
        Comment memory _comment = comment[_commentKey];
        require(_comment.isRemoved == false, "This comment is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(_comment.userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your comment");

        if (_comment.isSubcomment) {
            comment[_comment.subcommentKey].comments--;
        }

        bark[_comment.barkKey].comments--;

        comment[_commentKey].isRemoved = true;

        emit CommentRemoved(_commentKey, _comment.barkKey, _comment.userKey, _comment.subcommentKey, _comment.isSubcomment, _comment.text, _comment.isMedia, _comment.ipfs, _comment.comments, _comment.reposts, _comment.likes, false, true, block.timestamp);
    }

    function addRepost(
        uint _postKey,
        bool _isComment,
        bool _isQuote,
        string memory _text
    ) public nonReentrant {
        require(!paused, "This contract is paused");
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
        require(hasReposted(_postKey, _isComment, userKey) == -1, "You have already reposted this");

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
        Repost memory _repost = repost[_repostKey];
        require(repost[_repostKey].isRemoved == false, "This repost is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(repost[_repostKey].userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your repost");

        repost[_repostKey].isRemoved = true;

        if (_repost.isComment) {
            comment[_repost.postKey].reposts--;
        } else {
            bark[_repost.postKey].reposts--;
        }

        emit RepostRemoved(_repostKey, _repost.postKey, _repost.userKey, _repost.isComment, _repost.isQuote, _repost.text, true, block.timestamp);
    }

    function addLike(
        uint _postKey,
        bool _isComment
    ) public nonReentrant {
        require(!paused, "This contract is paused");
        require(userExists(payable(msg.sender)), "You don't have a profile");

        if (_isComment) {
            require(commentExists(_postKey), "This comment doesn't exist");
        } else {
            require(barkExists(_postKey), "This bark doesn't exist");
        }

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;
        require(hasLiked(_postKey, _isComment, userKey) == -1, "You have already liked this");

        _likes.increment();
        uint likeKey = _likes.current();

        if (_isComment) {
            comment[_postKey].likes++;
        } else {
            bark[_postKey].likes++;
        }

        uint date = block.timestamp;
    
        like[likeKey] = Like(likeKey, _postKey, userKey, _isComment, false, date);

        emit LikeAdded(likeKey, _postKey, userKey, _isComment, false, date);
    }

    function removeLike(
        uint _likeKey
    ) public nonReentrant {
        require(likeExists(_likeKey), "This like doesn't exist");
        Like memory _like = like[_likeKey];
        require(_like.isRemoved == false, "This like is already removed");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(_like.userKey == retrieveUserByAddress(payable(msg.sender)).userKey, "This is not your like");

        like[_likeKey].isRemoved = true;

        if (_like.isComment) {
            comment[_like.postKey].likes--;
        } else {
            bark[_like.postKey].likes--;
        }

        emit LikeRemoved(_likeKey, _like.postKey, _like.userKey, _like.isComment, true, block.timestamp);
    }

    function addUser(
        string memory _displayName,
        string memory _username,
        string memory _bio,
        string memory _ipfsProfile,
        string memory _ipfsBanner
    ) public nonReentrant {
        require(!paused, "This contract is paused");
        require(!userExists(payable(msg.sender)), "You already have a profile");
        require(!restricted[msg.sender], "Restricted");
        require(bytes(_displayName).length >= 1 && 32 >= bytes(_displayName).length, "Display names must be 1-32 chars");
        require(bytes(_username).length >= 3 && 32 >= bytes(_username).length, "Usernames must be 3-32 chars");
        require(160 >= bytes(_bio).length, "Bios must be 160 chars or less");
        require(64 >= bytes(_ipfsProfile).length, "Profile content hashes cannot exceed 64 chars");
        require(64 >= bytes(_ipfsBanner).length, "Banner content hashes cannot exceed 64 chars");

        _users.increment();
        uint userKey = _users.current();

        uint date = block.timestamp;

        uint[] memory empty;

        user[userKey] = User(userKey, payable(msg.sender), _displayName, _username, _bio, "", "", _ipfsProfile, _ipfsBanner, empty, empty, false, false, date);

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
        require(!paused, "This contract is paused");
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
        if (mediaEnabled) {
            require(64 >= bytes(_ipfsProfile).length, "Profile content hashes cannot exceed 64 chars");
            require(64 >= bytes(_ipfsBanner).length, "Banner content hashes cannot exceed 64 chars");
            user[userKey].ipfsProfile = _ipfsProfile;
            user[userKey].ipfsBanner = _ipfsBanner;
        }

        User memory _user = user[userKey];

        emit UserUpdated(userKey, payable(msg.sender), _displayName, _username, _bio, _website, _location, _ipfsProfile, _ipfsBanner, _user.followers, _user.following, false, false, _user.date);
    }

    function removeUser() public nonReentrant {
        require(userExists(payable(msg.sender)), "You don't have a profile");

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        user[userKey].isRemoved = true;

        User memory _user = user[userKey];

        emit UserRemoved(userKey, payable(msg.sender), _user.displayName, _user.username, _user.bio, _user.website, _user.location, _user.ipfsProfile, _user.ipfsBanner, _user.followers, _user.following, false, true, _user.date);
    }

    function followUser(
        uint _userKey
    ) public nonReentrant {
        require(!paused, "This contract is paused");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(userExistsById(_userKey), "No such user exists");

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        require(userKey != _userKey, "You cannot follow yourself");
        require(!isFollowing(userKey, _userKey), "You are already following this user");

        user[userKey].following.push(_userKey);
        user[_userKey].followers.push(userKey);
    }

    function unfollowUser(
        uint _userKey
    ) public nonReentrant {
        require(!paused, "This contract is paused");
        require(userExists(payable(msg.sender)), "You don't have a profile");
        require(userExistsById(_userKey), "No such user exists");

        uint userKey = retrieveUserByAddress(payable(msg.sender)).userKey;

        require(userKey != _userKey, "You cannot unfollow yourself");
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

    function forceRemoveBarks(
        uint[] memory _barkKeys
    ) external nonReentrant onlyMod {
        uint numBarks = _barkKeys.length;

        for (uint i = 0; i < numBarks; i++) {
            bark[_barkKeys[i]].isRemoved = true;

            Bark memory _bark = bark[_barkKeys[i]];

            emit BarkRemoved(_barkKeys[i], _bark.userKey, _bark.text, _bark.isMedia, _bark.ipfs, _bark.comments, _bark.reposts, _bark.likes, false, true, block.timestamp);
        }
    }

    function forceRemoveComments(
        uint[] memory _commentKeys
    ) external nonReentrant onlyMod {
        uint numComments = _commentKeys.length;

        for (uint i = 0; i < numComments; i++) {
            comment[_commentKeys[i]].isRemoved = true;

            Comment memory _comment = comment[_commentKeys[i]];

            emit CommentRemoved(_commentKeys[i], _comment.barkKey, _comment.userKey, _comment.subcommentKey, _comment.isSubcomment, _comment.text, _comment.isMedia, _comment.ipfs, _comment.comments, _comment.reposts, _comment.likes, false, true, block.timestamp);
        }
    }

    function forceRemoveReposts(
        uint[] memory _repostKeys
    ) external nonReentrant onlyMod {
        uint numReposts = _repostKeys.length;

        for (uint i = 0; i < numReposts; i++) {
            repost[_repostKeys[i]].isRemoved = true;

            Repost memory _repost = repost[_repostKeys[i]];

            emit RepostRemoved(_repostKeys[i], _repost.postKey, _repost.userKey, _repost.isComment, _repost.isQuote, _repost.text, true, block.timestamp);
        }
    }

    function forceRemoveLikes(
        uint[] memory _likeKeys
    ) external nonReentrant onlyMod {
        uint numLikes = _likeKeys.length;

        for (uint i = 0; i < numLikes; i++) {
            like[_likeKeys[i]].isRemoved = true;

            Like memory _like = like[_likeKeys[i]];

            emit LikeRemoved(_likeKeys[i], _like.postKey, _like.userKey, _like.isComment, true, block.timestamp);
        }
    }

    function forceRemoveUsers(
        uint[] memory _userKeys
    ) external nonReentrant onlyMod {
        uint numUsers = _userKeys.length;

        for (uint i = 0; i < numUsers; i++) {
            user[_userKeys[i]].isRemoved = true;

            User memory _user = user[_userKeys[i]];

            emit UserRemoved(_userKeys[i], _user.addr, _user.displayName, _user.username, _user.bio, _user.website, _user.location, _user.ipfsProfile, _user.ipfsBanner, _user.followers, _user.following, false, true, _user.date);
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
    ) public view returns (bool) {
        return restricted[_addr];
    }

    function retrieveBarksFrom(
        uint _dateFrom
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].isRemoved == false) {
                matches += 1;
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].isRemoved == false) {
                Bark storage currentItem = bark[i];
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

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].date <= _dateTo && bark[i].isRemoved == false) {
                matches += 1;
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].date <= _dateTo && bark[i].isRemoved == false) {
                Bark storage currentItem = bark[i];
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

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].isRemoved == false) {
                matches += 1;
                if (matches >= _limit) {
                    break;
                }
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].isRemoved == false) {
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

    function retrieveBarksFromToWithLimit(
        uint _dateFrom,
        uint _dateTo,
        uint _limit
    ) public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint matches = 0;
        uint cursor = 0;

        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].date <= _dateTo && bark[i].isRemoved == false) {
                matches += 1;
                if (matches >= _limit) {
                    break;
                }
            }
        }

        Bark[] memory items = new Bark[](matches);
        for (uint i = numBarks; i > 0; i--) {
            if (bark[i].date >= _dateFrom && bark[i].date <= _dateTo && bark[i].isRemoved == false) {
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

    function retrieveRepostsByUser(
        uint _userKey
    ) public view returns (Repost[] memory) {
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

    function retrieveCommentsByUser(
        uint _userKey
    ) public view returns (Comment[] memory) {
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
    ) public view returns (Like[] memory) {
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

    function retrieveCommentsByBark(
        uint _barkKey
    ) public view returns (Comment[] memory) {
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
    ) public view returns (Comment[] memory) {
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
    ) public view returns (Repost[] memory) {
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
    ) public view returns (Like[] memory) {
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
    ) public view returns (Comment[] memory) {
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
    ) public view returns (Repost[] memory) {
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
    ) public view returns (Like[] memory) {
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

    function commentExists(
        uint _commentKey
    ) public view returns (bool) {
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
    ) public view returns (bool) {
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
    ) public view returns (bool) {
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
    ) public view returns (bool) {
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
    ) public view returns (bool) {
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
    ) public view returns (int) {
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
    ) public view returns (int) {
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
    ) public view returns (User memory) {
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
    ) public view returns (User memory) {
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
    ) public view returns (bool) {
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
    ) public view returns (User[] memory) {
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
    ) public view returns (User[] memory) {
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

    function _indexOf(uint[] memory arr, uint searchFor) private pure returns (int) {
        uint len = arr.length;
        for (uint i = 0; i < len; i++) {
            if (arr[i] == searchFor) {
                return int(i);
            }
        }
        return -1;
    }

    /*
    function exportBarks() public view returns (Bark[] memory) {
        uint numBarks = _barks.current();
        uint cursor = 0;
    
        Bark[] memory items = new Bark[](numBarks);
        for (uint i = 0; i < numBarks; i++) {
            Bark storage currentItem = bark[i];
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
            Comment storage currentItem = comment[i];
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
            Repost storage currentItem = repost[i];
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
            Like storage currentItem = like[i];
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
            User storage currentItem = user[i];
            items[cursor] = currentItem;
            cursor += 1;
        }

        return items;
    }
    */

    function getMediaEnabled() public view returns (bool) {
        return mediaEnabled;
    }

    function getDeployerAddress() public view returns (address payable) {
        return payable(deployerAddress);
    }
}
