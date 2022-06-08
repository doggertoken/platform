<script context="module">
    export const prerender = false;
</script>

<script>
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore } from 'svelte-web3';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import { onMount } from 'svelte';
    import Barks from '$lib/components/Barks.svelte';
    import { goto } from '$app/navigation';
    import { page } from '$app/stores';
    import Swal from 'sweetalert2';

    let mode = ``;

    let textB = ``;
    let textC = ``;

    const userExists = async (addr) => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const exists = await contract.methods.userExists(
                addr
            ).call();
            return exists;
        } else {
            console.log(`Not connected...`);
        }
    };

    let loading = false;
    let errored = false;
    let showBarks = true;

    const replyB = async () => {
        if (!!$connected) {
            const exists = await userExists($selectedAccount);
            if (!!exists) {
                if (textB == ``) {
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
                        title: `You can't publish an empty Bark!`,
                    });
                    return;
                }
                const contract = new $web3.eth.Contract(abi, config.address);
                loading = true;
                contract.methods.addComment(
                    parseInt($page.params.slug),
                    0,
                    false,
                    textB,
                    false,
                    ``,
                ).send({
                    from: $selectedAccount,
                }).then((tx) => {
                    showBarks = false;
                    setTimeout(() => {
                        showBarks = true;
                        textB = ``;
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
                            title: `Replied!`,
                        });
                        loading = false;
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
                        title: `Error posting Bark. Are you signed in?`,
                    });
                    loading = false;
                });
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
                title: `You must connect your wallet to do this!`,
            });
        }
    };

    const replyC = async () => {
        if (!!$connected) {
            const exists = await userExists($selectedAccount);
            if (!!exists) {
                if (textC == ``) {
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
                        title: `You can't publish an empty Bark!`,
                    });
                    return;
                }
                const contract = new $web3.eth.Contract(abi, config.address);
                loading = true;
                contract.methods.addComment(
                    parseInt($page.url.pathname.split(`/`)[3]),
                    parseInt($page.params.slug),
                    true,
                    textC,
                    false,
                    ``,
                ).send({
                    from: $selectedAccount,
                }).then((tx) => {
                    showBarks = false;
                    setTimeout(() => {
                        showBarks = true;
                        textC = ``;
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
                            title: `Replied!`,
                        });
                        loading = false;
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
                        title: `Error posting Bark. Are you signed in?`,
                    });
                    loading = false;
                });
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
                title: `You must connect your wallet to do this!`,
            });
        }
    };

    let urlParams;

    onMount(() => {
        urlParams = $page.url.searchParams;
        if (urlParams.get(`u`) !== null) {
            if (urlParams.get(`b`) !== null) {
                if (!$connected) {
                    try {
                        defaultChainStore.setBrowserProvider();
                    } catch (e) {}
                }
                if (urlParams.get(`c`) !== null) {
                    mode = `comment`;
                } else {
                    mode = `bark`;
                }
            } else {
                goto (`/`);
            }
        } else {
            goto(`/`);
        }
    });

    let params = $page.url.searchParams;
    $: $page.url.searchParams, (params !== $page.url.searchParams && ($page.url.pathname.includes(`/bark`) || $page.url.pathname.includes(`/profile`)) && typeof window !== `undefined`) && (window.location.href = `${$page.url.pathname}?${$page.url.searchParams}`);
</script>

{#if mode === `bark`}
    {#if !!$connected}
        <Barks type="comment" user="" data={[urlParams.get(`u`), urlParams.get(`b`)]} />
        <div class="bark">
            <textarea bind:value={textB} class="bark__textarea" placeholder="What's on your mind?" expandable="false" autofocus />
            <div class="bark__bottom">
                {#if !!loading}
                    <button class="bark__button" on:click={replyB}>
                        Posting...
                    </button>
                {:else}
                    <button class="bark__button" on:click={replyB}>
                        Reply
                    </button>
                {/if}
            </div>
        </div>
        {#if showBarks}
            <Barks type="comments" user="" data={[urlParams.get(`u`), urlParams.get(`b`)]} />
        {/if}
    {:else}
        <p>You must connect your wallet to use Dogger!</p>
    {/if}
{:else if mode === `comment`}
    {#if !!$connected}
    <!--
        <Barks type="bark" user="" data={[$page.url.pathname.split(`/`)[2], $page.url.pathname.split(`/`)[3]]} />
        <Barks type="subcomment" user="" data={[$page.url.pathname.split(`/`)[2], $page.url.pathname.split(`/`)[3], $page.params.slug]} />
    -->
        <Barks type="thread" user="" data={[urlParams.get(`u`), urlParams.get(`b`), urlParams.get(`c`)]} />
        <div class="bark">
            <textarea bind:value={textC} class="bark__textarea" placeholder="What's on your mind?" expandable="false" autofocus />
            <div class="bark__bottom">
                {#if !!loading}
                    <button class="bark__button" on:click={replyC}>
                        Posting...
                    </button>
                {:else}
                    <button class="bark__button" on:click={replyC}>
                        Reply
                    </button>
                {/if}
            </div>
        </div>
        {#if showBarks}
            <Barks type="subcomments" user="" data={[urlParams.get(`u`), urlParams.get(`b`), urlParams.get(`c`)]} />
        {/if}
    {:else}
        <p>You must connect your wallet to use Dogger!</p>
    {/if}
{/if}

<style>
    .bark {
        border-bottom: 1px solid var(--darkGray);
        display: flex;
        flex-direction: column;
        height: 160px;
        .bark__textarea {
            background-color: var(--extraExtraLightGray);
            border: 0;
            font-family: 'CircularXX', sans-serif;
            font-size: 17px;
            height: 80px;
            outline: none;
            padding: 16px;
            resize: none;
            &:focus {
                outline: 2px solid var(--blue);
            }
        }
        .bark__bottom {
            display: flex;
            flex-direction: row-reverse;
        }
    }
    .bark__button {
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
        &:hover {
            opacity: .8;
        }
        &:focus {
            outline: 2px solid var(--blue);
        }
    }
    p {
        font-size: 17px;
        font-weight: 700;
        margin-top: 40px;
        text-align: center;
    }
</style>
