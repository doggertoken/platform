// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
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
*/

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
    bool isEmpty;
    bool isRemoved;
    uint date;
}

struct Like {
    uint likeKey;
    uint postKey;
    uint userKey;
    bool isComment;
    bool isEmpty;
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
