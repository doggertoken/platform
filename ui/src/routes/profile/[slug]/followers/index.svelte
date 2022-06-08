<script>
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore, defaultEvmStores } from 'svelte-web3';
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
    import { page } from '$app/stores';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import Barks from '$lib/components/Barks.svelte';

    let hasLoaded = false;
    let isLoading = false;

    let users = [];
    let followers = [];

    const load = async () => {
        isLoading = true;
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const doesExist = await contract.methods.userExists(
                $page.params.slug
            ).call();
            if (!doesExist) {
                goto(`/`);
            } else {
                const user = await contract.methods.retrieveUserByAddress($page.params.slug).call();
                followers = await contract.methods.retrieveFollowersByUser(parseInt(user.userKey)).call();
                const followersLen = followers.length;
                for (let i = 0; i < followersLen; i++) {
                    const follower = await contract.methods.retrieveUserByKey(parseInt(followers[i].userKey)).call();
                    users.push(follower);
                    users = users;
                    if (i === followersLen - 1) { // todo optimize a bit
                        hasLoaded = true;
                        isLoading = false;
                    }
                }
            }
        } else {
            console.log(`Not connected...`);
            isLoading = false;
        }
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
</script>

{#if !!hasLoaded}
    {#each users as user}
        <div class="bark">
            <div class="bark__profile">
                <a href="/profile?u={user.addr}">
                    <img class="bark__picture" src={user.ipfsProfile == `` ? `/img/logo.png` : `https://cloudflare-ipfs.com/ipfs/${user.ipfsProfile}`} alt="" />
                </a>
            </div>
            <div class="bark__content">
                <div class="bark__top">
                    <div class="bark__left">
                        <div class="bark__name"><a href="/profile?u={user.addr}">{user.displayName}</a></div>
                        <div class="bark__username"><a href="/profile?u={user.addr}">@{user.username}</a></div>
                    </div>
                    <div class="bark__right">
                        <div class="bark__more"></div>
                    </div>
                </div>
                <div class="bark__text">{user.bio}</div>
                <div class="bark__bottom" />
            </div>
        </div>
    {/each}
{/if}

<style>
    .bark {
        border-bottom: 1px solid var(--darkGray);
        cursor: pointer;
        display: flex;
        &:hover {
            background-color: var(--extraLightGray);
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
                    .bark__icon {
                        height: 16px;
                        width: 16px;
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
</style>

