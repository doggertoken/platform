export default [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_text",
				"type": "string"
			},
			{
				"internalType": "bool",
				"name": "_isMedia",
				"type": "bool"
			},
			{
				"internalType": "string",
				"name": "_ipfs",
				"type": "string"
			}
		],
		"name": "addBark",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_commentKey",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "_isSubcomment",
				"type": "bool"
			},
			{
				"internalType": "string",
				"name": "_text",
				"type": "string"
			},
			{
				"internalType": "bool",
				"name": "_isMedia",
				"type": "bool"
			},
			{
				"internalType": "string",
				"name": "_ipfs",
				"type": "string"
			}
		],
		"name": "addComment",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_postKey",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "_isComment",
				"type": "bool"
			}
		],
		"name": "addLike",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_postKey",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "_isComment",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "_isQuote",
				"type": "bool"
			},
			{
				"internalType": "string",
				"name": "_text",
				"type": "string"
			}
		],
		"name": "addRepost",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_displayName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_username",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_bio",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_ipfsProfile",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_ipfsBanner",
				"type": "string"
			}
		],
		"name": "addUser",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_token",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "approveToken",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "barkKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "text",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isMedia",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfs",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "comments",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "reposts",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "likes",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isEmpty",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "BarkAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "barkKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "text",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isMedia",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfs",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "comments",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "reposts",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "likes",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isEmpty",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "BarkRemoved",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "commentKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "barkKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "subcommentKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isSubcomment",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "text",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isMedia",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfs",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "comments",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "reposts",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "likes",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isEmpty",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "CommentAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "commentKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "barkKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "subcommentKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isSubcomment",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "text",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isMedia",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfs",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "comments",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "reposts",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "likes",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isEmpty",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "CommentRemoved",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "followUser",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "_barkKeys",
				"type": "uint256[]"
			}
		],
		"name": "forceRemoveBarks",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "_commentKeys",
				"type": "uint256[]"
			}
		],
		"name": "forceRemoveComments",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "_likeKeys",
				"type": "uint256[]"
			}
		],
		"name": "forceRemoveLikes",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "_repostKeys",
				"type": "uint256[]"
			}
		],
		"name": "forceRemoveReposts",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "_userKeys",
				"type": "uint256[]"
			}
		],
		"name": "forceRemoveUsers",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "likeKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "postKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isComment",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "LikeAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "likeKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "postKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isComment",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "LikeRemoved",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			}
		],
		"name": "removeBark",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_commentKey",
				"type": "uint256"
			}
		],
		"name": "removeComment",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_likeKey",
				"type": "uint256"
			}
		],
		"name": "removeLike",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_repostKey",
				"type": "uint256"
			}
		],
		"name": "removeRepost",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "removeUser",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "repostKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "postKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isComment",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isQuote",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "text",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "RepostAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "repostKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "postKey",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isComment",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isQuote",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "text",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "RepostRemoved",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_token",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "rescueToken",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "restrict",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "sweep",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "toggleAdmin",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "toggleMedia",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "toggleMod",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "togglePaused",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "unfollowUser",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_displayName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_username",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_bio",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_website",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_location",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_ipfsProfile",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_ipfsBanner",
				"type": "string"
			}
		],
		"name": "updateUser",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "address payable",
				"name": "addr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "displayName",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "username",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "bio",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "website",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "location",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfsProfile",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfsBanner",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256[]",
				"name": "followers",
				"type": "uint256[]"
			},
			{
				"indexed": false,
				"internalType": "uint256[]",
				"name": "following",
				"type": "uint256[]"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isEmpty",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "UserAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "address payable",
				"name": "addr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "displayName",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "username",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "bio",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "website",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "location",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfsProfile",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfsBanner",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256[]",
				"name": "followers",
				"type": "uint256[]"
			},
			{
				"indexed": false,
				"internalType": "uint256[]",
				"name": "following",
				"type": "uint256[]"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isEmpty",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "UserRemoved",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "userKey",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "address payable",
				"name": "addr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "displayName",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "username",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "bio",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "website",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "location",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfsProfile",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "ipfsBanner",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256[]",
				"name": "followers",
				"type": "uint256[]"
			},
			{
				"indexed": false,
				"internalType": "uint256[]",
				"name": "following",
				"type": "uint256[]"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isEmpty",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "isRemoved",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "date",
				"type": "uint256"
			}
		],
		"name": "UserUpdated",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			}
		],
		"name": "barkExists",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_commentKey",
				"type": "uint256"
			}
		],
		"name": "commentExists",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "deployerAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getDeployerAddress",
		"outputs": [
			{
				"internalType": "address payable",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getMediaEnabled",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_postKey",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "_isComment",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "hasLiked",
		"outputs": [
			{
				"internalType": "int256",
				"name": "",
				"type": "int256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_postKey",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "_isComment",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "hasReposted",
		"outputs": [
			{
				"internalType": "int256",
				"name": "",
				"type": "int256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "isAdmin",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_followerUserKey",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_followingUserKey",
				"type": "uint256"
			}
		],
		"name": "isFollowing",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "isMod",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "isRestricted",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_likeKey",
				"type": "uint256"
			}
		],
		"name": "likeExists",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "mediaEnabled",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "paused",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_repostKey",
				"type": "uint256"
			}
		],
		"name": "repostExists",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			}
		],
		"name": "retrieveBarkByKey",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Bark",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "retrieveBarksByUser",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Bark[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_dateFrom",
				"type": "uint256"
			}
		],
		"name": "retrieveBarksFrom",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Bark[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_dateFrom",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_dateTo",
				"type": "uint256"
			}
		],
		"name": "retrieveBarksFromTo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Bark[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_dateFrom",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_dateTo",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_limit",
				"type": "uint256"
			}
		],
		"name": "retrieveBarksFromToWithLimit",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Bark[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_dateFrom",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_limit",
				"type": "uint256"
			}
		],
		"name": "retrieveBarksFromWithLimit",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Bark[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_limit",
				"type": "uint256"
			}
		],
		"name": "retrieveBarksWithLimit",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Bark[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_commentKey",
				"type": "uint256"
			}
		],
		"name": "retrieveCommentByKey",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "commentKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "subcommentKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isSubcomment",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Comment",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			}
		],
		"name": "retrieveCommentsAndSubcommentsByBark",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "commentKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "subcommentKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isSubcomment",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Comment[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			}
		],
		"name": "retrieveCommentsByBark",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "commentKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "subcommentKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isSubcomment",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Comment[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_commentKey",
				"type": "uint256"
			}
		],
		"name": "retrieveCommentsByComment",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "commentKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "subcommentKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isSubcomment",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Comment[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "retrieveCommentsByUser",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "commentKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "barkKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "subcommentKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isSubcomment",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isMedia",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "ipfs",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "comments",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "reposts",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "likes",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Comment[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "retrieveFollowersByUser",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "address payable",
						"name": "addr",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "displayName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "username",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "bio",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "website",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "location",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsProfile",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsBanner",
						"type": "string"
					},
					{
						"internalType": "uint256[]",
						"name": "followers",
						"type": "uint256[]"
					},
					{
						"internalType": "uint256[]",
						"name": "following",
						"type": "uint256[]"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.User[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "retrieveFollowingByUser",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "address payable",
						"name": "addr",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "displayName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "username",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "bio",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "website",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "location",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsProfile",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsBanner",
						"type": "string"
					},
					{
						"internalType": "uint256[]",
						"name": "followers",
						"type": "uint256[]"
					},
					{
						"internalType": "uint256[]",
						"name": "following",
						"type": "uint256[]"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.User[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			}
		],
		"name": "retrieveLikesByBark",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "likeKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isComment",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Like[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_commentKey",
				"type": "uint256"
			}
		],
		"name": "retrieveLikesByComment",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "likeKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isComment",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Like[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "retrieveLikesByUser",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "likeKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isComment",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Like[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_barkKey",
				"type": "uint256"
			}
		],
		"name": "retrieveRepostsByBark",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "repostKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isComment",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isQuote",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Repost[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_commentKey",
				"type": "uint256"
			}
		],
		"name": "retrieveRepostsByComment",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "repostKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isComment",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isQuote",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Repost[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "retrieveRepostsByUser",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "repostKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "postKey",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isComment",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isQuote",
						"type": "bool"
					},
					{
						"internalType": "string",
						"name": "text",
						"type": "string"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.Repost[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address payable",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "retrieveUserByAddress",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "address payable",
						"name": "addr",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "displayName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "username",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "bio",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "website",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "location",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsProfile",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsBanner",
						"type": "string"
					},
					{
						"internalType": "uint256[]",
						"name": "followers",
						"type": "uint256[]"
					},
					{
						"internalType": "uint256[]",
						"name": "following",
						"type": "uint256[]"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.User",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "retrieveUserByKey",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "userKey",
						"type": "uint256"
					},
					{
						"internalType": "address payable",
						"name": "addr",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "displayName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "username",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "bio",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "website",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "location",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsProfile",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "ipfsBanner",
						"type": "string"
					},
					{
						"internalType": "uint256[]",
						"name": "followers",
						"type": "uint256[]"
					},
					{
						"internalType": "uint256[]",
						"name": "following",
						"type": "uint256[]"
					},
					{
						"internalType": "bool",
						"name": "isEmpty",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "isRemoved",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Dogger.User",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalBarks",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalComments",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalLikes",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalReposts",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalUsers",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address payable",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "userExists",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_userKey",
				"type": "uint256"
			}
		],
		"name": "userExistsById",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];
