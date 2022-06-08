<script>
    import Bark from '$lib/components/Bark.svelte';
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore } from 'svelte-web3';
    import { onMount } from 'svelte';
    import abi from '$lib/abi';
    import config from '$lib/config';

    export let type;
    export let user;
    export let data;

    let address = user;

    let hasLoaded = false;
    let isLoading = false;
    let barks = [];
    let comments = [];
    let subcomments = [];
    let userObj = null;

    const load = async () => {
        if (!!$connected) {
            if (type === `user`) {
                isLoading = true;
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    address
                ).call();
                userObj = u;
                const results = await contract.methods.retrieveBarksByUser(
                    u.userKey
                ).call();
                barks = [];
                results.forEach((result) => {
                    let r = structuredClone(result);
                    r._userObj = userObj;
                    r._isComment = false;
                    r._isRepost = false;
                    r._quote = null;
                    r._isLike = false;
                    barks.push(r);
                });
                const results2 = await contract.methods.retrieveRepostsByUser(
                    u.userKey
                ).call();
                results2.forEach(async (result) => {
                    let r = structuredClone(result);
                    if (!!r.isComment) {
                        const op = await contract.methods.retrieveCommentByKey(
                            r.postKey
                        ).call();
                        const userObjRepost = await contract.methods.retrieveUserByKey(
                            op.userKey
                        ).call();
                        const b = await contract.methods.retrieveCommentByKey(
                            r.postKey
                        ).call();
                        let b_ = structuredClone(b);
                        b_._userObj = userObjRepost;
                        b_._isComment = true;
                        b_._isRepost = true;
                        b_._isLike = false;
                        b_._quote = !!r.isQuote ? r : null;
                        b_.date = r.date;
                        barks.push(b_);
                        barks = barks;
                        barks.sort((x, y) => y.date - x.date);
                    } else {
                        const op = await contract.methods.retrieveBarkByKey(
                            r.postKey
                        ).call();
                        const userObjRepost = await contract.methods.retrieveUserByKey(
                            op.userKey
                        ).call();
                        const b = await contract.methods.retrieveBarkByKey(
                            r.postKey
                        ).call();
                        let b_ = structuredClone(b);
                        b_._userObj = userObjRepost;
                        b_._isComment = false;
                        b_._isRepost = true;
                        b_._isLike = false;
                        b_._quote = !!r.isQuote ? r : null;
                        b_.date = r.date;
                        barks.push(b_);
                        barks = barks;
                        barks.sort((x, y) => y.date - x.date);
                    }
                });
                barks.sort((x, y) => y.date - x.date);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `userWithComments`) {
                isLoading = true;
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    address
                ).call();
                userObj = u;
                const results = await contract.methods.retrieveBarksByUser(
                    u.userKey
                ).call();
                barks = [];
                results.forEach((result) => {
                    let r = structuredClone(result);
                    r._userObj = userObj;
                    r._isComment = false;
                    r._isRepost = false;
                    r._quote = null;
                    r._isLike = false;
                    barks.push(r);
                });
                const results2 = await contract.methods.retrieveCommentsByUser(
                    u.userKey
                ).call();
                results2.forEach((result) => {
                    let r = structuredClone(result);
                    r._userObj = userObj;
                    r._isComment = true;
                    r._isRepost = false;
                    r._quote = null;
                    r._isLike = false;
                    r._bkey = r.barkKey;
                    barks.push(r);
                });
                barks.sort((x, y) => y.date - x.date);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `thread`) {
                isLoading = true;
                let userAddress = data[0];
                let barkKey = data[1];
                let commentKey = data[2];
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    userAddress
                ).call();
                userObj = u;
                barks = [];
                const result = await contract.methods.retrieveBarkByKey(
                    barkKey
                ).call();
                let b = structuredClone(result);
                b._userObj = userObj;
                b._isComment = false;
                b._isRepost = false;
                b._isLike = false;
                b._quote = null;
                b._bkey = barkKey;
                barks.push(b);
                barks = barks;
                comments = [];
                const result2 = await contract.methods.retrieveCommentByKey(
                    commentKey
                ).call();
                let c = structuredClone(result2);
                c._userObj = userObj;
                c._isComment = true;
                c._isRepost = false;
                c._isLike = false;
                c._quote = null;
                c._bkey = barkKey;
                let nextKey = c.commentKey;
                subcomments = [];
                async function p() {
                    const res = await contract.methods.retrieveCommentByKey(
                        nextKey
                    ).call();
                    let re = structuredClone(res);
                    re._userObj = userObj;
                    re._isComment = true;
                    re._isRepost = false;
                    re._isLike = false;
                    re._quote = null;
                    re._bkey = barkKey;
                    if (!res.isSubcomment) {
                        comments.push(re);
                        comments = comments;
                        //subcomments.push(c);
                        //subcomments = subcomments;
                        return true;
                    } else {
                        subcomments.push(re);
                        subcomments = subcomments;
                        nextKey = res.subcommentKey;
                        await p();
                    }
                }
                if (!c.isSubcomment) {
                    comments.push(c);
                    comments = comments;
                } else {
                    await p();
                }
                /*
                const results3 = await contract.methods.retrieveCommentsByComment(
                    commentKey
                ).call();
                for (let i = 0; i < results3.length; i++) {
                    let r = structuredClone(results3[i]);
                    const userObjComment = await contract.methods.retrieveUserByKey(
                        r.userKey
                    ).call();
                    r._userObj = userObjComment;
                    r._isComment = true;
                    r._isRepost = false;
                    r._isLike = false;
                    r._quote = null;
                    r._bkey = barkKey;
                    subcomments.push(r);
                    subcomments = subcomments;
                }
                */
                subcomments.sort((x, y) => x.date - y.date);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `bark`) {
                isLoading = true;
                let userAddress = data[0];
                let barkKey = data[1];
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    userAddress
                ).call();
                userObj = u;
                const result = await contract.methods.retrieveBarkByKey(
                    barkKey
                ).call();
                barks = [];
                let r = structuredClone(result);
                r._userObj = userObj;
                r._isComment = false;
                r._isRepost = false;
                r._quote = null;
                r._isLike = false;
                barks.push(r);
                barks = barks;
                barks.sort((x, y) => y.date - x.date);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `comment`) {
                isLoading = true;
                let userAddress = data[0];
                let barkKey = data[1];
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    userAddress
                ).call();
                userObj = u;
                const results = await contract.methods.retrieveBarksByUser(
                    u.userKey
                ).call();
                barks = [];
                results.forEach((result) => {
                    if (result.barkKey == barkKey) {
                        let r = structuredClone(result);
                        r._userObj = userObj;
                        r._isComment = false;
                        r._isRepost = false;
                        r._isLike = false;
                        r._quote = null;
                        barks.push(r);
                        barks = barks;
                    }
                });
                //barks.sort((x, y) => y.date - x.date);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `comments`) {
                isLoading = true;
                let userAddress = data[0];
                let barkKey = data[1];
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    userAddress
                ).call();
                userObj = u;
                comments = [];
                const results2 = await contract.methods.retrieveCommentsByBark(
                    barkKey
                ).call();
                for (let i = 0; i < results2.length; i++) {
                    let r = structuredClone(results2[i]);
                    const userObjComment = await contract.methods.retrieveUserByKey(
                        r.userKey
                    ).call();
                    r._userObj = userObjComment;
                    r._isComment = true;
                    r._isRepost = false;
                    r._isLike = false;
                    r._quote = null;
                    r._bkey = barkKey;
                    comments.push(r);
                }
                comments.sort((x, y) => x.likes - y.likes);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `subcomment`) {
                isLoading = true;
                let userAddress = data[0];
                let barkKey = data[1];
                let commentKey = data[2];
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    userAddress
                ).call();
                userObj = u;
                const results = await contract.methods.retrieveCommentsByUser(
                    u.userKey
                ).call();
                comments = [];
                results.forEach((result) => {
                    if (result.commentKey == commentKey) {
                        let r = structuredClone(result);
                        r._userObj = userObj;
                        r._isComment = false;
                        r._isRepost = false;
                        r._isLike = false;
                        r._quote = null;
                        comments.push(r);
                        comments = comments;
                    }
                });
                //comments.sort((x, y) => y.date - x.date);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `subcomments`) {
                isLoading = true;
                let userAddress = data[0];
                let barkKey = data[1];
                let commentKey = data[2];
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    userAddress
                ).call();
                userObj = u;
                subcomments = [];
                const results2 = await contract.methods.retrieveCommentsByComment(
                    commentKey
                ).call();
                for (let i = 0; i < results2.length; i++) {
                    let r = structuredClone(results2[i]);
                    const userObjComment = await contract.methods.retrieveUserByKey(
                        r.userKey
                    ).call();
                    r._userObj = userObjComment;
                    r._isComment = true;
                    r._isRepost = false;
                    r._isLike = false;
                    r._quote = null;
                    r._bkey = barkKey;
                    comments.push(r);
                }
                subcomments.sort((x, y) => x.likes - y.likes);
                hasLoaded = true;
                isLoading = false;
            } else if (type === `likes`) {
                isLoading = true;
                const contract = new $web3.eth.Contract(abi, config.address);
                const u = await contract.methods.retrieveUserByAddress(
                    address
                ).call();
                userObj = u;
                barks = [];
                const results = await contract.methods.retrieveLikesByUser(
                    u.userKey
                ).call();
                results.forEach(async (result) => {
                    let r = structuredClone(result);
                    r._userObj = userObj;
                    r._isComment = false;
                    r._isRepost = false;
                    r._isLike = true;
                    r._quote = null;
                    if (!!r.isComment) {
                        const b = await contract.methods.retrieveCommentByKey(
                            r.postKey
                        ).call();
                        let b_ = structuredClone(b);
                        b_._userObj = userObj;
                        b_._isComment = true;
                        b_._isRepost = false;
                        b_._isLike = true;
                        b_._quote = null;
                        b_.date = r.date;
                        barks.push(b_);
                        barks = barks;
                        barks.sort((x, y) => y.date - x.date);
                    } else {
                        const b = await contract.methods.retrieveBarkByKey(
                            r.postKey
                        ).call();
                        let b_ = structuredClone(b);
                        b_._userObj = userObj;
                        b_._isComment = false;
                        b_._isRepost = false;
                        b_._isLike = true;
                        b_._quote = null;
                        b_.date = r.date;
                        barks.push(b_);
                        barks = barks;
                        barks.sort((x, y) => y.date - x.date);
                    }
                });
                barks.sort((x, y) => x.date - y.date);
                hasLoaded = true;
                isLoading = false;
            } else {
                isLoading = true;
                const contract = new $web3.eth.Contract(abi, config.address);
                const results = await contract.methods.retrieveBarksWithLimit(
                    50
                ).call();
                barks = [];
                results.forEach(async (result) => {
                    let r = structuredClone(result);
                    r._userObj = await contract.methods.retrieveUserByKey(parseInt(result.userKey)).call();
                    r._isComment = false;
                    r._isRepost = false;
                    r._isLike = false;
                    r._quote = null;
                    barks.push(r);
                    barks = barks;
                    barks.sort((x, y) => y.date - x.date);
                });
                userObj = ``;
                /*
                const u = await contract.methods.retrieveUserByAddress(
                    address
                ).call();
                userObj = u;
                userObj = ``;
                */
                //barks.sort((x, y) => x.date - y.date);
                hasLoaded = true;
                isLoading = false;
            }
        } else {
            console.log(`Not connected...`);
        }
    };

    onMount(() => {
        (!!$connected && !isLoading && !hasLoaded) && (load());
    });

    $: $connected, (!!$connected && !isLoading && !hasLoaded) && (load());
    //$: type, (!!$connected && !isLoading) && (load());
</script>

{#if !!$connected}
    {#if !!hasLoaded && userObj !== null}
        {#if type !== `thread`}
            {#if barks.length > 0}
                {#each barks as bark}
                    <Bark {bark} user={bark._userObj} isComment={bark._isComment} isRepost={bark._isRepost} isLike={bark._isLike} quote={bark._quote} bkey={!!bark._isComment ? bark._bkey : 0} />
                {/each}
            {:else if comments.length > 0}
                {#each comments as comment}
                    <Bark bark={comment} user={comment._userObj} isComment={true} isRepost={comment._isRepost} isLike={comment._isLike} quote={comment._quote} bkey={comment._bkey} />
                {/each}
            {:else if subcomments.length > 0}
                {#each subcomments as subcomment}
                    <Bark bark={subcomment} user={subcomment._userObj} isComment={true} isRepost={subcomment._isRepost} isLike={subcomment._isLike} quote={subcomment._quote} bkey={subcomment._bkey} ckey={subcomment._ckey} />
                {/each}
            {:else}
                <p>There are no barks to display here</p>
            {/if}
        {:else}
            {#if barks.length > 0}
                {#each barks as bark}
                    <Bark {bark} user={bark._userObj} isComment={bark._isComment} isRepost={bark._isRepost} isLike={bark._isLike} quote={bark._quote} bkey={!!bark._isComment ? bark._bkey : 0} />
                {/each}
            {/if}
            {#if comments.length > 0}
                {#each comments as comment}
                    <Bark bark={comment} user={comment._userObj} isComment={true} isRepost={comment._isRepost} isLike={comment._isLike} quote={comment._quote} bkey={comment._bkey} />
                {/each}
            {/if}
            {#if subcomments.length > 0}
                {#each subcomments as subcomment}
                    <Bark bark={subcomment} user={subcomment._userObj} isComment={true} isRepost={subcomment._isRepost} isLike={subcomment._isLike} quote={subcomment._quote} bkey={subcomment._bkey} ckey={subcomment._ckey} />
                {/each}
            {/if}
            {#if barks.length === 0 && comments.length === 0 && subcomments.length === 0}
                <p>There are no barks to display here</p>
            {/if}
        {/if}
    {:else}
        <p>Loading...</p>
    {/if}
{:else}
    <p>You must connect your wallet to use Dogger</p>
{/if}

<style>
    p {
        font-size: 17px;
        font-weight: 700;
        margin-top: 40px;
        text-align: center;
    }
</style>
