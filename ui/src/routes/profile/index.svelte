<script context="module">
    export const prerender = false;
</script>

<script>
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore, defaultEvmStores } from 'svelte-web3';
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
    import { page } from '$app/stores';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import Barks from '$lib/components/Barks.svelte';
    import Swal from 'sweetalert2';

    let profile = ``;

    let hasLoaded = false;
    let isLoading = false;

    let output = ``;
    let tab = 0;

    let following = false;
    let followsYou = false;

    const userExists = async () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const doesExist = await contract.methods.userExists(
                profile
            ).call();
            if (!doesExist) {
                goto(`/`);
            }
        } else {
            console.log(`Not connected...`);
        }
    };

    const isFollower = async () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const userKey = await contract.methods.retrieveUserByAddress(
                profile
            ).call();
            const userKey2 = await contract.methods.retrieveUserByAddress(
                $selectedAccount
            ).call();
            const isFollowing = await contract.methods.isFollowing(
                userKey2.userKey,
                userKey.userKey
            ).call();
            const isFollower = await contract.methods.isFollowing(
                userKey.userKey,
                userKey2.userKey
            ).call();
            following = isFollowing;
            followsYou = isFollower;
            return following;
        } else {
            console.log(`Not connected...`);
            return false;
        }
    };

    const validateUrl = (str) => {
        let url;
        try {
            url = new URL(str);
        } catch (e) {
            return false;
        }
        return url.protocol === `http:` || url.protocol === `https:`;
    };

    const block = () => {
        if (u.addr.toLowerCase() !== $selectedAccount.toLowerCase()) {
            if (typeof localStorage !== `undefined`) {
                let blockList = localStorage.getItem(`blockList`);
                try {
                    blockList.toString().split(`,`);
                    blockList.push(u.addr);
                    localStorage.setItem(`blockList`, blockList.toString());
                    goto(`/`);
                } catch (e) {
                    localStorage.setItem(`blockList`, u.addr);
                }
            } else {
                const Toast = Swal.mixin({
                    didOpen: (toast) => {
                        toast.addEventListener(`mouseenter`, Swal.stopTimer);
                        toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                    },
                    position: `top-end`,
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    toast: true,
                });
                Toast.fire({
                    icon: `error`,
                    title: `To use the block feature, your web browser must support the localStorage API.`,
                });
            }
        } else {
            const Toast = Swal.mixin({
                didOpen: (toast) => {
                    toast.addEventListener(`mouseenter`, Swal.stopTimer);
                    toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                },
                position: `top-end`,
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true,
                toast: true,
            });
            Toast.fire({
                icon: `error`,
                title: `You cannot block yourself!`,
            });
        }
    };

    const toggleFollow = async () => {
        if (!!$connected) {
            if ($selectedAccount == profile) {
                const Toast = Swal.mixin({
                    didOpen: (toast) => {
                        toast.addEventListener(`mouseenter`, Swal.stopTimer);
                        toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                    },
                    position: `top-end`,
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    toast: true,
                });
                Toast.fire({
                    icon: `error`,
                    title: `You cannot follow yourself!`,
                });
                return;
            }
            const contract = new $web3.eth.Contract(abi, config.address);
            const userKey = await contract.methods.retrieveUserByAddress(
                profile
            ).call();
            const userKey2 = await contract.methods.retrieveUserByAddress(
                $selectedAccount
            ).call();
            const isFollowing = await contract.methods.isFollowing(
                userKey2.userKey,
                userKey.userKey
            ).call();
            following = isFollowing;
            if (!following) {
                contract.methods.followUser(
                    userKey.userKey
                ).send({
                    from: $selectedAccount,
                }).then((tx) => {
                    //console.log(tx);
                    load();
                    const Toast = Swal.mixin({
                        didOpen: (toast) => {
                            toast.addEventListener(`mouseenter`, Swal.stopTimer);
                            toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                        },
                        position: `top-end`,
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        toast: true,
                    });
                    Toast.fire({
                        icon: `success`,
                        title: `Followed!`,
                    });
                }).catch((e) => {
                    const Toast = Swal.mixin({
                        didOpen: (toast) => {
                            toast.addEventListener(`mouseenter`, Swal.stopTimer);
                            toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                        },
                        position: `top-end`,
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        toast: true,
                    });
                    Toast.fire({
                        icon: `error`,
                        title: `Error following user`,
                    });
                });
            } else {
                contract.methods.unfollowUser(
                    userKey.userKey
                ).send({
                    from: $selectedAccount,
                }).then((tx) => {
                    //console.log(tx);
                    load();
                    const Toast = Swal.mixin({
                        didOpen: (toast) => {
                            toast.addEventListener(`mouseenter`, Swal.stopTimer);
                            toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                        },
                        position: `top-end`,
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        toast: true,
                    });
                    Toast.fire({
                        icon: `success`,
                        title: `Unfollowed!`,
                    });
                }).catch((e) => {
                    const Toast = Swal.mixin({
                        didOpen: (toast) => {
                            toast.addEventListener(`mouseenter`, Swal.stopTimer);
                            toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                        },
                        position: `top-end`,
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        toast: true,
                    });
                    Toast.fire({
                        icon: `error`,
                        title: `Error unfollowing user`,
                    });
                });
            }
        } else {
            const Toast = Swal.mixin({
                didOpen: (toast) => {
                    toast.addEventListener(`mouseenter`, Swal.stopTimer);
                    toast.addEventListener(`mouseleave`, Swal.resumeTimer);
                },
                position: `top-end`,
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true,
                toast: true,
            });
            Toast.fire({
                icon: `error`,
                title: `You must connect your wallet to follow users!`,
            });
        }
    };

    const retrieveUserByAddress = async () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const result = await contract.methods.retrieveUserByAddress(
                profile.toString()
            ).call();
            const date = new Date();
            const timestamp = date.getTime();
            const seconds = Math.floor(timestamp / 1000);
            const difference = seconds - parseInt(result.date);
            if (difference < 60) {
                output = `${difference} seconds ago`;
            } else if (difference < 3600) {
                output = `${Math.floor(difference / 60)} minutes ago`;
            } else if (difference < 86400) {
                output = `${Math.floor(difference / 3600)} hours ago`;
            } else if (difference < 2620800) {
                output = `${Math.floor(difference / 86400)} hours ago`;
            } else if (difference < 31449600) {
                output = `${Math.floor(difference / 2620800)} months ago`;
            } else {
                output = `${Math.floor(difference / 31449600)} years ago`;
            }
            return result;
        } else {
            console.log(`Not connected...`);
        }
    };

    let u = {
        addr: ``,
        displayName: ``,
        username: ``,
        date: 0,
        followers: [],
        following: [],
        website: ``,
        location: ``,
        ipfsProfile: ``,
        ipfsBanner: ``,
    };

    const load = async () => {
        const urlParams = $page.url.searchParams;
        if (urlParams.get(`u`) === null) {
            goto(`/`);
            return;
        } else {
            profile = urlParams.get(`u`);
        }
        isLoading = true;
        const r = await retrieveUserByAddress(profile);
        u = r;
        //console.log(u);
        userExists();
        isFollower();
        if (typeof localStorage !== `undefined`) {
            try {
                let blockList = localStorage.getItem(`blockList`);
                blockList = blockList.toString().split(`,`);
                const blockListLen = blockList.length;
                !!blockList.includes(u.addr) && (goto(`/`));
            } catch (e) {
                localStorage.setItem(`blockList`, ``);
            }
        }
        hasLoaded = true;
        isLoading = false;
    };

    onMount(() => {
        if (!$connected) {
            try {
                defaultChainStore.setBrowserProvider();
            } catch (e) {
                console.log(`Error connecting`);
            }
        }
        (!!$connected && !isLoading && !hasLoaded) && (load());
    });

    $: $connected, (!!$connected && !isLoading && !hasLoaded) && (load());

    let params = $page.url.searchParams;
    $: $page.url.searchParams, (params !== $page.url.searchParams && ($page.url.pathname.includes(`/bark`) || $page.url.pathname.includes(`/profile`)) && typeof window !== `undefined`) && (window.location.href = `${$page.url.pathname}?${$page.url.searchParams}`);
</script>

{#if !!hasLoaded}

    <div class="top">
        <div class="banner">
            {#if u.ipfsBanner != ``}
                <img class="banner__img" src="https://cloudflare-ipfs.com/ipfs/{u.ipfsBanner}" alt="" />
            {/if}
        </div>
        <div class="bottom">
            <div class="image">
                <img class="img" src={u.ipfsProfile == `` ? `/img/logo.png` : `https://cloudflare-ipfs.com/ipfs/${u.ipfsProfile}`} alt="" />
            </div>
            <div class="flex">
                <div>
                    <h1 class="displayName">{u.displayName}{#if !!followsYou}<span class="followsYou">Follows You</span>{/if}</h1>
                    <div class="username">@{u.username}</div>
                </div>
                <div>
                    <button class="btn block" on:click={block}>
                        Block
                    </button>
                    <button class="btn {!!following && (`following`)}" on:click={toggleFollow}>
                        {!!following ? `Unfollow` : `Follow`}
                    </button>
                </div>
            </div>
            <div class="bio">{u.bio}</div>
            <div class="bar">
                {#if u.website != `` && !!validateUrl(u.website)}
                    <div class="website">
                        <a href={u.website} rel="external noopener" target="_blank">{u.website}</a>
                    </div>
                {/if}
                {#if u.location != ``}
                    <div class="location">{u.location}</div>
                {/if}
                <div class="date">Joined {output}</div>
            </div>
            <div class="followBar">
                <a class="following" href="/profile?u={profile}&following=true">
                    <span class="bold">{u.following.length}</span> Following
                </a>
                <a class="followers" href="/profile?u={profile}&followers=true">
                    <span class="bold">{u.followers.length}</span> Followers
                </a>
            </div>
            <div class="tabs">
                <button class="tab {tab === 0 && (`tab--selected`)}" on:click={() => tab = 0}>
                    Barks
                </button>
                <button class="tab {tab === 1 && (`tab--selected`)}" on:click={() => tab = 1}>
                    Barks & Replies
                </button>
                <button class="tab {tab === 2 && (`tab--selected`)}" on:click={() => tab = 2}>
                    Likes
                </button>
            </div>
        </div>
    </div>

    {#if tab === 0}
        <Barks type="user" user={profile} />
    {:else if tab === 1}
        <Barks type="userWithComments" user={profile} />
    {:else if tab === 2}
        <Barks type="likes" user={profile} />
    {/if}

{:else if !$connected}

    <p>You must connect your wallet to use Dogger!</p>

{/if}

<style>
    .top {
        .banner {
            .banner__img {
                height: 180px;
                object-fit: contain;
                width: 100%;
            }
        }
        .bottom {
            padding: 16px;
            .image {
                .img {
                    border-radius: 50%;
                    height: 134px;
                    width: 134px;
                }
            }
            .displayName {
                color: var(_-black);
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 4px;
                .followsYou {
                    background-color: var(--extraLightGray);
                    color: var(--darkGray);
                    font-size: 10px;
                    margin-left: 8px;
                    padding: 4px;
                    text-transform: uppercase;
                }
            }
            .username {
                color: var(--darkGray);
                margin-bottom: 16px;
            }
            .flex {
                align-items: flex-start;
                display: flex;
                justify-content: space-between;
                .btn {
                    background-color: var(--blue);
                    border: 0;
                    border-radius: 28px;
                    color: var(--white);
                    cursor: pointer;
                    font-size: 16px;
                    font-weight: 700;
                    outline: none;
                    padding: 12px 24px;
                    text-align: center;
                    &:hover {
                        opacity: .8;
                    }
                    &:focus {
                        outline: 2px solid var(--lightGray);
                    }
                    &.following {
                        background-color: #eee;
                        color: var(--blue);
                        &:focus {
                            outline: 2px solid var(--blue);
                        }
                    }
                    &.block {
                        background-color: #fae4e4;
                        color: #f00;
                        margin-right: 4px;
                        &:focus {
                            outline: 2px solid #f00;
                        }
                    }
                }
            }
            .bio {
                color: var(--black);
                margin-bottom: 16px;
                width: 100%;
            }
            .bar {
                align-items: center;
                column-gap: 12px;
                display: flex;
                justify-content: flex-start;
                margin-bottom: 16px;
            }
            .followBar {
                align-items: center;
                column-gap: 12px;
                display: flex;
                justify-content: flex-start;
                margin-bottom: 24px;
                .bold {
                    font-weight: 900;
                }
                a {
                    color: var(--black);
                    text-decoration: none;
                    &:hover {
                        text-decoration: underline;
                    }
                }
            }
            .tabs {
                align-items: flex-start;
                display: flex;
                justify-content: space-around;
                .tab {
                    background: transparent;
                    border: none;
                    cursor: pointer;
                    font-size: 16px;
                    outline: none;
                    padding: 16px 0;
                    transition: .1s all ease;
                    width: 100%;
                    &.tab--selected {
                        border-bottom: 4px solid var(--blue);
                        font-size: 18px;
                        font-weight: 700;
                    }
                    &:hover {
                        background-color: #eee;
                    }
                    &:focus {
                        outline: 2px solid var(--blue);
                    }
                }
            }
        }
    }
    p {
        font-size: 17px;
        font-weight: 700;
        margin-top: 40px;
        text-align: center;
    }
</style>
