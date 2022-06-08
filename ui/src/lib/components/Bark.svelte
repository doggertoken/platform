<script>
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore } from 'svelte-web3';
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import Swal from 'sweetalert2';

    export let bark;
    export let user;
    export let isComment;
    export let isRepost;
    export let quote;
    //export let isLike;
    //export let bkey;
    //export let ckey;

    let reposts = 0;
    let likes = 0;

    const date = new Date();
    const timestamp = date.getTime();
    const seconds = Math.floor(timestamp / 1000);
    const difference = seconds - parseInt(bark.date);
    let output = ``;
    if (difference < 60) {
        output = `${difference}s`;
    } else if (difference < 3600) {
        output = `${Math.floor(difference / 60)}m`;
    } else if (difference < 86400) {
        output = `${Math.floor(difference / 3600)}h`;
    } else if (difference < 2620800) {
        output = `${Math.floor(difference / 86400)}d`;
    } else if (difference < 31449600) {
        output = `${Math.floor(difference / 2620800)}mo`;
    } else {
        output = `${Math.floor(difference / 31449600)}yr`;
    }

    let hasLoaded = false;
    let isLoading = false;

    const retrieveUserByKey = async () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const result = await contract.methods.retrieveUserByKey(
                user.userKey
            ).call();
            return result;
        } else {
            console.log(`Not connected...`);
        }
    };

    const retrieveSelf = async () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const result = await contract.methods.retrieveUserByAddress(
                $selectedAccount
            ).call();
            return result;
        } else {
            console.log(`Not connected...`);
        }
    };

    const hasLiked = async () => {
        if (!!$connected) {
            const me = await retrieveSelf();
            const contract = new $web3.eth.Contract(abi, config.address);
            const result = await contract.methods.hasLiked(
                bark.barkKey,
                isComment,
                me.userKey
            ).call();
            if (!!isComment) {
                const result2 = await contract.methods.retrieveLikesByComment(
                    bark.barkKey
                ).call();
                likes = result2.length;
            } else {
                const result2 = await contract.methods.retrieveLikesByBark(
                    bark.barkKey
                ).call();
                likes = result2.length;
            }
            return result;
        } else {
            console.log(`Not connected...`);
        }
    };

    const hasReposted = async () => {
        if (!!$connected) {
            const me = await retrieveSelf();
            const contract = new $web3.eth.Contract(abi, config.address);
            const result = await contract.methods.hasReposted(
                bark.barkKey,
                isComment,
                me.userKey
            ).call();
            if (!!isComment) {
                const result2 = await contract.methods.retrieveRepostsByComment(
                    bark.barkKey
                ).call();
                reposts = result2.length;
            } else {
                const result2 = await contract.methods.retrieveRepostsByBark(
                    bark.barkKey
                ).call();
                reposts = result2.length;
            }
            return result;
        } else {
            console.log(`Not connected...`);
        }
    };

    const comment = async () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            if (!!isComment) {
                const b = await contract.methods.retrieveBarkByKey(
                    bark.barkKey
                ).call(); // THIS WONT WORK IF ITS A SUBCOMMENT
                const addr = await contract.methods.retrieveUserByKey(
                    b.userKey
                ).call();
                //goto(`/bark/${addr.addr}/${bark.barkKey}/${bark.commentKey}`);
                goto(`/bark?u=${addr.addr}&b=${bark.barkKey}&c=${bark.commentKey}`);
            } else {
                //goto(`/bark/${user.addr}/${bark.barkKey}/`);
                goto(`/bark?u=${user.addr}&b=${bark.barkKey}`);
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
                title: `You must connect your wallet to do this!`,
            });
        }
    };

    const repost = async () => {
        if (!!$connected) {
            const hr = await hasReposted();
            const contract = new $web3.eth.Contract(abi, config.address);
            if (hr > -1) {
                contract.methods.removeRepost(
                    hr
                ).send({
                    from: $selectedAccount,
                }).then(() => {
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
                        title: `Reposted!`,
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
                        title: `Error removing repost`,
                    });
                });
            } else {
                contract.methods.addRepost(
                    bark.barkKey,
                    isComment,
                    false,
                    ``
                ).send({
                    from: $selectedAccount,
                }).then(() => {
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
                        title: `Reposted!`,
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
                        title: `Error reposting ${!!isComment ? `comment` : `Bark`}`,
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
                title: `You must connect your wallet to do this!`,
            });
        }
    };

    const like = async () => {
        if (!!$connected) {
            const hl = await hasLiked();
            const contract = new $web3.eth.Contract(abi, config.address);
            if (hl > -1) {
                contract.methods.removeLike(
                    hl
                ).send({
                    from: $selectedAccount,
                }).then(() => {
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
                        title: `Liked!`,
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
                        title: `Error removing like`,
                    });
                });
            } else {
                contract.methods.addLike(
                    bark.barkKey,
                    isComment
                ).send({
                    from: $selectedAccount,
                }).then(() => {
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
                        title: `Liked!`,
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
                        title: `Error liking ${!!isComment ? `comment` : `Bark`}`,
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
                title: `You must connect your wallet to do this!`,
            });
        }
    };

    const quoteRepost = () => {
        Swal.fire({
            html: `
                <div class="modal">
                    <div class="bark">
                        <textarea id="textarea" class="bark__textarea" placeholder="What's on your mind?" expandable="false" maxlength="280" onkeydown="window.updateQuote()" onkeyup="window.update()" onchange="window.update()" autofocus></textarea>
                        <div class="bark__bottom">
                            <span class="bark__characters">
                                <span id="chars" class="bark__characters__remaining">280</span>
                                characters remaining
                            </span>
                            <button id="button" class="bark__button" onclick="window.quote()">
                                Quote
                            </button>
                        </div>
                    </div>
                </div>
                <style>
                    .modal .bark {
                        padding: 40px;
                    }
                    .modal .bark {
                        display: flex;
                        flex-direction: column;
                        height: 160px;
                    }
                    .modal .bark__textarea {
                        background-color: var(--extraExtraLightGray);
                        border: 0;
                        font-family: 'CircularXX', sans-serif;
                        font-size: 17px;
                        height: 80px;
                        outline: none;
                        padding: 16px;
                        resize: none;
                    }
                    .modal .bark__textarea:focus {
                        outline: 2px solid var(--blue);
                    }
                    .modal .bark__bottom {
                        align-items: center;
                        display: flex;
                        justify-content: space-between;
                    }
                    .modal .bark__characters {
                        color: var(--darkGray);
                        margin: 8px 0 8px 8px;
                    }
                    .modal .bark__characters__remaining {
                        color: #000;
                        font-weight: 600;
                        transition: .2s all ease;
                    }
                    .modal .bark__characters__remaining--orange {
                        color: darkorange;
                    }
                    .modal .bark__characters__remaining--red {
                        color: #f00 !important;
                    }
                    .modal .bark__button {
                        background-color: #e4eefa;
                        border: 0;
                        border-radius: 16px;
                        color: var(--blue);
                        cursor: pointer;
                        font-size: 18px;
                        font-weight: 700;
                        margin: 8px 8px 8px 0;
                        outline: none;
                        padding: 8px 12px;
                        transition: .1s all ease;
                        width: 100px;
                    }
                    .modal .bark__button:hover {
                        opacity: .8;
                    }
                    .modal .bark__button:focus {
                        outline: 2px solid var(--blue);
                    }
                </style>
            `,
            showCloseButton: true,
            showConfirmButton: false,
        });
    };

    let sharing = false;

    const share = async () => {
        sharing = !sharing;
    };

    const copy = (text) => {
        if (!navigator.clipboard) return;
        navigator.clipboard.writeText(text).then().catch((e) => {
            // TODO ?
        });
    }

    let reposted = -1;
    let liked = -1;

    let u = {
        addr: ``,
        displayName: ``,
        username: ``,
    };

    let hidden = false;

    let loading = false;

    const load = async () => {
        reposted = await hasReposted();
        liked = await hasLiked();
        u = await retrieveUserByKey();
        if (typeof localStorage !== `undefined`) {
            try {
                let blockList = localStorage.getItem(`blockList`);
                blockList = blockList.toString().split(`,`);
                !!blockList.includes(u.addr) && (hidden = true);
            } catch (e) {
                localStorage.setItem(`blockList`, ``);
            }
        }
        window.updateQuote = () => {
            document.getElementById(`chars`).innerHTML = 280 - document.getElementById(`textarea`).value.toString().length;
        };
        window.quote = async () => {
            if (!!$connected) {
                const contract = new $web3.eth.Contract(abi, config.address);
                const exists = await contract.methods.userExists(
                    $selectedAccount
                ).call();
                if (!!exists) {
                    const text = document.getElementById(`textarea`).value.toString();
                    if (text.length == 0 || text == null || text == ``) {
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
                            title: `You can't publish an empty bark!`,
                        });
                    } else if (text.length > 280) {
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
                            title: `Barks must be 280 characters or less!`,
                        });
                    } else if (!loading) { // ? is this the best place to check? maybe it should be higher up?
                        loading = true;
                        document.getElementById(`button`).innerHTML = `Posting`;
                        contract.methods.addRepost(
                            bark.barkKey,
                            isComment,
                            true,
                            text
                        ).send({
                            from: $selectedAccount,
                        }).then((tx) => {
                            setTimeout(() => {
                                //document.getElementById(`textarea`).value = ``;
                                loading = false;
                                document.getElementById(`button`).innerHTML = `Quote`;
                                Swal.close();
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
                                    title: `Quote published`,
                                }); // todo update barks/quotes if on home page
                            }, 200);
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
                                title: `Error posting Bark! Are you signed in?`,
                            });
                            loading = false;
                            document.getElementById(`button`).innerHTML = `Quote`;
                        });
                    }
                } else {
                    goto(`/signup/`);
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
                    title: `You must connect your wallet to do this!!`,
                });
            }
        };
        hasLoaded = true;
    };

    const closeDetails = () => {
        if (typeof document !== `undefined`) {
            const details = document.querySelectorAll(`details`);
            details.forEach((detail) => detail.removeAttribute(`open`));
        }
    };

    onMount(() => {
        likes = bark.likes;
        reposts = bark.reposts;
        (!!$connected && !isLoading && !hasLoaded) && (load());
    });

    $: $connected, (!isLoading && !hasLoaded) && (load());
</script>

<svelte:window on:click={closeDetails} />

{#if !hidden}
    <div class="bark">
        <div class="bark__profile">
            <a href="/profile?u={u.addr}">
                {#if !!hasLoaded}
                    <img class="bark__picture" src={u.ipfsProfile == `` ? `/img/logo.png` : `https://cloudflare-ipfs.com/ipfs/${u.ipfsProfile}`} alt="" />
                {:else}
                    <span class="bark__picture skeleton-avatar skeleton-effect-wave"><svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100" preserveAspectRatio="none"><rect width="100" height="100" fillrule="evenodd" style="" rx="50%"></rect><path style="" d="M50.20054464285714,49.249180089285716 C56.179458125,49.249180089285716 61.32402178571428,43.90991107142857 61.32402178571428,36.95770821428572 C61.32402178571428,30.088916625000003 56.15169392857143,25 50.20054464285714,25 C44.24951401785714,25 39.0770675,30.200210723214283 39.0770675,37.01335526785714 C39.0770675,43.90991107142857 44.24951401785714,49.249180089285716 50.20054464285714,49.249180089285716 Z M32.73674488392857,75 L67.66446303571429,75 C72.03032401785714,75 73.58761080357144,73.74859401785716 73.58761080357144,71.30142901785715 C73.58761080357144,64.12675660714285 64.60541785714287,54.226921339285724 50.20054464285714,54.226921339285724 C35.76790723214286,54.226921339285724 26.785714285714285,64.12675660714285 26.785714285714285,71.30142901785715 C26.785714285714285,73.74859401785716 28.34288242857143,75 32.73674488392857,75 Z"></path></svg></span>
                {/if}
            </a>
        </div>
        <div class="bark__content">
            {#if !!isRepost}
                <div class="bark__top">
                    <div class="bark__left">
                        <div class="bark__name bark__repost">
                            <img class="bark__icon" src="/img/repost.svg" alt="" /> <span>{#if quote != null}Quote{/if} Reposted</span>
                        </div>
                    </div>
                    <div class="bark__right">
                        <div class="bark__more"></div>
                    </div>
                </div>
                {#if quote != null}
                    <p>{quote.text}</p>
                {/if}
            {/if}
            {#if quote == null}
                <div class="bark__top">
                    <div class="bark__left">
                        {#if !!hasLoaded}
                            <div class="bark__name"><a href="/profile?u={u.addr}">{u.displayName}</a></div>
                        {:else}
                            <div class="bark__name skeleton-text skeleton-effect-wave">Example</div>
                        {/if}
                        {#if !!hasLoaded}
                            <div class="bark__username"><a href="/profile?u={u.addr}">@{u.username}</a></div>
                        {:else}
                            <div class="bark__username skeleton-text skeleton-effect-wave">@example</div>
                        {/if}
                        <div class="bark__time">· {output}</div>
                    </div>
                    <div class="bark__right">
                        <div class="bark__more"></div>
                    </div>
                </div>
                <div class="bark__text">{bark.text}</div>
                <div class="bark__bottom">
                    <button class="bark__button" on:click={comment}>
                        <img class="bark__icon" src="/img/comment.svg" alt="" /> {bark.comments}
                    </button>
                    <details>
                        <summary class="bark__button {reposted > -1 && (`bark__button--reposted`)}">
                            <img class="bark__icon" src={reposted > -1 ? `/img/reposted.svg` : `/img/repost.svg`} alt="" />
                            {#if !!hasLoaded}
                                {reposts}
                            {:else}
                                <div class="skeleton-text skeleton-effect-wave">0</div>
                            {/if}
                        </summary>
                        <div class="repost__menu">
                            <button class="repost__menu__button" on:click={repost}>Repost</button>
                            <button class="repost__menu__button" on:click={quoteRepost}>Quote Repost</button>
                        </div>
                    </details>
                    <button class="bark__button {liked > -1 && (`bark__button--liked`)}" on:click={like}>
                        <img class="bark__icon" src={liked > -1 ? `/img/liked.svg` : `/img/like.svg`} alt="" />
                        {#if !!hasLoaded}
                            {likes}
                        {:else}
                            <div class="skeleton-text skeleton-effect-wave">0</div>
                        {/if}
                    </button>
                    <button class="bark__button" on:click={share}>
                        <img class="bark__icon" src="/img/share.svg" alt="" />
                    </button>
                </div>
            {:else}
                <div class="bark__quote">
                    <div class="bark__top">
                        <div class="bark__left">
                            {#if !!hasLoaded}
                                <div class="bark__name"><a href="/profile?u={u.addr}">{u.displayName}</a></div>
                            {:else}
                                <div class="bark__name skeleton-text skeleton-effect-wave">Example</div>
                            {/if}
                            {#if !!hasLoaded}
                                <div class="bark__username"><a href="/profile?u={u.addr}">@{u.username}</a></div>
                            {:else}
                                <div class="bark__username skeleton-text skeleton-effect-wave">@example</div>
                            {/if}
                            <div class="bark__time">· {output}</div>
                        </div>
                        <div class="bark__right">
                            <div class="bark__more"></div>
                        </div>
                    </div>
                    <div class="bark__text">{bark.text}</div>
                    <div class="bark__bottom">
                        <button class="bark__button" on:click={comment}>
                            <img class="bark__icon" src="/img/comment.svg" alt="" /> {bark.comments}
                        </button>
                        <details>
                            <summary class="bark__button {reposted > -1 && (`bark__button--reposted`)}">
                                <img class="bark__icon" src={reposted > -1 ? `/img/reposted.svg` : `/img/repost.svg`} alt="" />
                                {#if !!hasLoaded}
                                    {reposts}
                                {:else}
                                    <div class="skeleton-text skeleton-effect-wave">0</div>
                                {/if}
                            </summary>
                            <div class="repost__menu">
                                <button class="repost__menu__button" on:click={repost}>Repost</button>
                                <button class="repost__menu__button" on:click={quoteRepost}>Quote Repost</button>
                            </div>
                        </details>
                        <button class="bark__button {liked > -1 && (`bark__button--liked`)}" on:click={like}>
                            <img class="bark__icon" src={liked > -1 ? `/img/liked.svg` : `/img/like.svg`} alt="" />
                            {#if !!hasLoaded}
                                {likes}
                            {:else}
                                <div class="skeleton-text skeleton-effect-wave">0</div>
                            {/if}
                        </button>
                        <button class="bark__button" on:click={share}>
                            <img class="bark__icon" src="/img/share.svg" alt="" />
                        </button>
                    </div>
                </div>
            {/if}
        </div>
    </div>
    {#if !!sharing}
        <div class="bark share">
            <input class="share__input" type="text" value="https://dogger.cc/bark/{user.addr}/{bark.barkKey}/{!!isComment ? `${bark.commentKey}/` : ``}" disabled />
            <button class="share__button" on:click={() => copy(`https://dogger.cc/bark/${user.addr}/${bark.barkKey}/${!!isComment ? `${bark.commentKey}/` : ``}`)}>
                Copy
            </button>
        </div>
    {/if}
{/if}

<style>
    .repost__menu {
        background: var(--extraLightGray);
        border: 1px solid var(--blue);
        border-radius: 12px;
        box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px;
        display: flex;
        flex-direction: column;
        height: 80px;
        position: absolute;
        width: 120px;
        z-index: 1;
        .repost__menu__button {
            align-items: center;
            border: 0;
            border-radius: 12px 12px 0 0;
            column-gap: 12px;
            cursor: pointer;
            display: flex;
            font-size: 16px;
            height: 40px;
            justify-content: flex-start;
            outline: none;
            width: 100%;
            &:last-child {
                border-radius: 0 0 12px 12px;
            }
            &:hover {
                background-color: var(--lightGray);
            }
        }
    }
    .bark {
        border-bottom: 1px solid var(--darkGray);
        cursor: pointer;
        display: flex;
        &:hover {
            background-color: var(--extraLightGray);
        }
        .bark__quote {
            border: 1px solid var(--darkGray);
            border-radius: 6px;
            margin-bottom: 30px;
            max-width: 480px;
            padding: 8px;
        }
        .bark__profile {
            width: 72px;
            .bark__picture {
                border-radius: 50%;
                height: 48px;
                margin: 12px 12px 0 12px;
                width: 48px;
                &:hover {
                    opacity: .8;
                }
            }
        }
        .bark__content {
            width: 100%;
            p {
                margin-top: 6px;
            }
            .bark__top {
                display: flex;
                justify-content: space-between;
                margin-top: 12px;
                .bark__left {
                    align-items: center;
                    column-gap: 8px;
                    display: flex;
                    .bark__repost {
                        align-items: center;
                        column-gap: 8px;
                        display: flex;
                        justify-content: flex-start;
                        span {
                            padding-top: 1px;
                        }
                    }
                    .bark__name {
                        font-size: 16px;
                        font-weight: 700;
                        a {
                            color: inherit;
                            text-decoration: none;
                            &:hover {
                                text-decoration: underline;
                            }
                        }
                    }
                    .bark__username a {
                        color: inherit;
                        text-decoration: none;
                        &:hover {
                            text-decoration: underline;
                        }
                    }
                }
                .bark__right {
                    .bark__more {}
                }
            }
            .bark__text {
                font-size: 17px;
                font-weight: 500;
                line-height: 1.4;
                margin-top: 4px;
            }
            .bark__bottom {
                align-items: center;
                column-gap: 100px;
                display: flex;
                justify-content: flex-start;
                padding: 12px 0 8px;
                .bark__button {
                    align-items: center;
                    background: transparent;
                    border: 0;
                    column-gap: 12px;
                    cursor: pointer;
                    display: flex;
                    outline: none;
                    transition: .1s all ease;
                    &.bark__button--reposted {
                        color: var(--blue);
                    }
                    &.bark__button--liked {
                        color: red;
                    }
                    &:hover {
                        opacity: .6;
                    }
                }
            }
        }
    }
    .bark__icon {
        height: 16px;
        width: 16px;
    }
    .share {
        align-items: center;
        column-gap: 8px;
        display: flex;
        justify-content: space-between;
        padding: 8px;
        .share__input {
            border: 2px solid var(--darkGray);
            border-radius: 18px;
            font-size: 16px;
            outline: none;
            padding: 8px;
            transition: .1s all ease;
            width: 100%;
            &:hover {
                border-color: var(--black);
            }
            &:focus {
                border-color: var(--blue);
            }
        }
        .share__button {
            background-color: #e4eefa;
            border: 0;
            border-radius: 16px;
            color: var(--blue);
            cursor: pointer;
            font-size: 18px;
            font-weight: 700;
            outline: none;
            padding: 8px 12px;
            transition: .1s all ease;
            width: 100px;
            &:hover {
                opacity: .8;
            }
            &:focus {
                outline: 2px solid var(--blue);
            }
        }
    }
</style>
