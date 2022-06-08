<script context="module">
    import { browser, dev } from '$app/env';
    export const hydrate = browser;
    export const router = browser;
    export const prerender = false;
</script>

<script>
    import '$lib/global.scss';
    import 'skeleton-elements/skeleton-elements.css';
    import 'sweetalert2/src/sweetalert2.scss';
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore } from 'svelte-web3';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import { onMount } from 'svelte';
    import { page } from '$app/stores';
    import Swal from 'sweetalert2';

    const connectWallet = () => {
        try {
            defaultChainStore.setBrowserProvider();
        } catch (e) {
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
                title: `Please install and enable an Ethereum wallet like MetaMask!`,
            });
        }
    };

    let doesExist = false;
    let loading = false;
    let pfp = ``;

    const userExists = async (addr) => {
        if (!!$connected) {
            isLoading = true;
            const contract = new $web3.eth.Contract(abi, config.address);
            const exists = await contract.methods.userExists(
                addr
            ).call();
            doesExist = exists;
            if (!!doesExist) {
                const user = await contract.methods.retrieveUserByAddress(
                    addr
                ).call();
                pfp = user.ipfsProfile;
                if (pfp == ``) {
                    pfp = null;
                }
            }
            hasLoaded = true;
            isLoading = false;
            return exists;
        }
    };

    const bark = () => {
        Swal.fire({
            html: `
                <div class="modal">
                    <div class="bark">
                        <textarea id="textarea" class="bark__textarea" placeholder="What's on your mind?" expandable="false" maxlength="280" onkeydown="window.update()" onkeyup="window.update()" onchange="window.update()" autofocus></textarea>
                        <div class="bark__bottom">
                            <span class="bark__characters">
                                <span id="chars" class="bark__characters__remaining">280</span>
                                characters remaining
                            </span>
                            <button id="button" class="bark__button" onclick="window.bark()">
                                Bark
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

    let isLoading = false;
    let hasLoaded = false;

    const load = async () => {
        await userExists($selectedAccount);
    };

    onMount(() => {
        connectWallet();
        (!!$connected && !isLoading && !hasLoaded) && (load());
        window.update = () => {
            document.getElementById(`chars`).innerHTML = 280 - document.getElementById(`textarea`).value.toString().length;
        };
        window.bark = async () => {
            if (!!$connected) {
                const exists = await userExists($selectedAccount);
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
                        const contract = new $web3.eth.Contract(abi, config.address);
                        contract.methods.addBark(
                            text,
                            false,
                            ``
                        ).send({
                            from: $selectedAccount,
                        }).then((tx) => {
                            setTimeout(() => {
                                document.getElementById(`textarea`).value = ``;
                                loading = false;
                                document.getElementById(`button`).innerHTML = `Bark`;
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
                                    title: `Bark published`,
                                }); // todo update barks if on home page
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
                            document.getElementById(`button`).innerHTML = `Bark`;
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
    });

    const cid = async () => {
        try {
            const currentChainId = await window.ethereum.request({
                method: `eth_chainId`,
            });
            console.log(currentChainId);
            if (currentChainId !== config.chainIdHex) {
                await window.ethereum.request({
                    method: `wallet_switchEthereumChain`,
                    params: [{ chainId: config.chainIdHex, }],
                });
            }
        } catch (e) {}
    };

    $: $connected, (!!$connected && !isLoading && !hasLoaded) && (load());
    $: $connected, (!!$connected) && (cid());
    $: $chainId, (!!$connected) && (cid());

    //let path = $page.url.pathname;
    //let params = $page.url.searchParams;

    //$: $page.url.pathname, (path !== $page.url.pathname && ($page.url.pathname.includes(`/profile`)) && typeof window !== `undefined`) && (window.location.href = $page.url.pathname);
    //$: $page.url.searchParams, (params !== $page.url.searchParams && ($page.url.pathname.includes(`/bark`) || $page.url.pathname.includes(`/profile`)) && typeof window !== `undefined`) && (window.location.href = `${$page.url.pathname}?${$page.url.searchParams}`);
</script>

<div class="wrapper">
    <div class="container">
        <div class="container__left">
            <div class="container__top">
                <h1><img src="/img/logo-blue.png" alt=""><span>Dogger</span></h1>
                <span class="beta">Public Beta</span>
            </div>
            <a class="sidebar__link" href="/">
                <svg height="24px" width="24px" viewBox="0 0 122.88 113.97">
                    <path fill="var(--darkGray)" fill-rule="evenodd" d="M18.69,73.37,59.18,32.86c2.14-2.14,2.41-2.23,4.63,0l40.38,40.51V114h-30V86.55a3.38,3.38,0,0,0-3.37-3.37H52.08a3.38,3.38,0,0,0-3.37,3.37V114h-30V73.37ZM60.17.88,0,57.38l14.84,7.79,42.5-42.86c3.64-3.66,3.68-3.74,7.29-.16l43.41,43,14.84-7.79L62.62.79c-1.08-1-1.24-1.13-2.45.09Z"></path>
                </svg>
                Home
            </a>
            <a class="sidebar__link" href="https://dogger.wtf" rel="external noopener" target="_blank">
                <svg height="24px" width="24px" x="0px" y="0px" viewBox="0 0 91.06 122.88" style="enable-background:new 0 0 91.06 122.88" xml:space="preserve">
                    <g>
                        <path fill="var(--darkGray)" d="M58.68,84.96H27.37v-3.12c0-5.32,0.59-9.65,1.8-12.97c1.21-3.35,3.01-6.36,5.4-9.11c2.39-2.76,7.76-7.6,16.12-14.52 c4.45-3.63,6.67-6.95,6.67-9.96c0-3.04-0.9-5.37-2.67-7.06c-1.8-1.66-4.5-2.5-8.13-2.5c-3.91,0-7.12,1.29-9.68,3.88 c-2.56,2.56-4.19,7.09-4.9,13.5L0,39.13c1.1-11.76,5.37-21.21,12.8-28.39C20.25,3.57,31.68,0,47.06,0c11.98,0,21.63,2.5,29,7.48 c9.99,6.78,15,15.78,15,27.04c0,4.67-1.29,9.2-3.88,13.53c-2.56,4.33-7.85,9.65-15.81,15.89c-5.54,4.42-9.06,7.93-10.52,10.61 C59.42,77.19,58.68,80.68,58.68,84.96L58.68,84.96z M26.28,93.29h33.56v29.6H26.28V93.29L26.28,93.29z"></path>
                    </g>
                </svg>
                About
            </a>
            {#if !$connected || $selectedAccount == null || $selectedAccount == ``}
                <a class="sidebar__link sidebar__link--button" role="button" on:click={connectWallet}>Connect</a>
            {:else}
                {#if !!doesExist}
                    <a class="sidebar__link sidebar__link--text" role="button">
                        <svg height="24px" width="24px" viewBox="0 0 311.39 507.11">
                            <title>ethereum-eth</title>
                            <polygon fill="var(--darkGray)"  points="155.65 0 152.25 11.56 152.25 346.87 155.65 350.26 311.3 258.26 155.65 0"></polygon>
                            <polygon fill="var(--darkGray)"  points="155.65 0 0 258.26 155.65 350.27 155.65 187.51 155.65 0"></polygon>
                            <polygon fill="var(--darkGray)"  points="155.65 379.74 153.73 382.07 153.73 501.52 155.65 507.11 311.39 287.78 155.65 379.74"></polygon>
                            <polygon fill="var(--darkGray)"  points="155.65 507.11 155.65 379.73 0 287.78 155.65 507.11"></polygon>
                            <polygon fill="var(--darkGray)"  points="155.65 350.26 311.3 258.26 155.65 187.51 155.65 350.26"></polygon>
                            <polygon fill="var(--darkGray)"  points="0 258.26 155.65 350.26 155.65 187.51 0 258.26"></polygon>
                        </svg>
                        {$selectedAccount.toString().toLowerCase().substring(0, 8)}
                    </a>
                    <a class="sidebar__link" href="/notifications/">
                        <svg height="24px" width="24px" x="0px" y="0px" viewBox="0 0 120.641 122.878" enable-background="new 0 0 120.641 122.878" xml:space="preserve">
                            <g>
                                <path fill="var(--darkGray)" fill-rule="evenodd" clip-rule="evenodd" d="M68.16,6.889c18.129,3.653,31.889,19.757,31.889,38.921 c0,22.594-2.146,39.585,20.592,54.716c-40.277,0-80.366,0-120.641,0C22.8,85.353,20.647,68.036,20.647,45.81 c0-19.267,13.91-35.439,32.182-38.979C53.883-2.309,67.174-2.265,68.16,6.889L68.16,6.889z M76.711,109.19 c-1.398,7.785-8.205,13.688-16.392,13.688c-8.187,0-14.992-5.902-16.393-13.688H76.711L76.711,109.19z"></path>
                            </g>
                        </svg>
                        Notifications
                    </a>
                    <a class="sidebar__link" href="/profile?u={$selectedAccount}">
                        {#if pfp == ``}
                            <span class="skeleton-avatar skeleton-effect-wave"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 100 100" preserveAspectRatio="none"><rect width="100" height="100" fillrule="evenodd" style="" rx="50%"></rect><path style="" d="M50.20054464285714,49.249180089285716 C56.179458125,49.249180089285716 61.32402178571428,43.90991107142857 61.32402178571428,36.95770821428572 C61.32402178571428,30.088916625000003 56.15169392857143,25 50.20054464285714,25 C44.24951401785714,25 39.0770675,30.200210723214283 39.0770675,37.01335526785714 C39.0770675,43.90991107142857 44.24951401785714,49.249180089285716 50.20054464285714,49.249180089285716 Z M32.73674488392857,75 L67.66446303571429,75 C72.03032401785714,75 73.58761080357144,73.74859401785716 73.58761080357144,71.30142901785715 C73.58761080357144,64.12675660714285 64.60541785714287,54.226921339285724 50.20054464285714,54.226921339285724 C35.76790723214286,54.226921339285724 26.785714285714285,64.12675660714285 26.785714285714285,71.30142901785715 C26.785714285714285,73.74859401785716 28.34288242857143,75 32.73674488392857,75 Z"></path></svg></span>
                        {:else}
                            <img height="24px" width="24px" src={pfp == null ? `/img/logo.png` : `https://cloudflare-ipfs.com/ipfs/${pfp}`} alt="" />
                        {/if}
                        Profile
                    </a>
                    <a class="sidebar__link" href="/settings/">
                        <svg height="24px" width="24px" viewBox="0 0 122.88 122.88">
                            <path fill="var(--darkGray)" fill-rule="evenodd" d="M73.48,15.84A46.87,46.87,0,0,1,84.87,21L91,14.84a7.6,7.6,0,0,1,10.72,0L108,21.15a7.6,7.6,0,0,1,0,10.72l-6.6,6.6a46.6,46.6,0,0,1,4.34,10.93h9.52A7.6,7.6,0,0,1,122.88,57V65.9a7.6,7.6,0,0,1-7.58,7.58h-9.61a46.83,46.83,0,0,1-4.37,10.81L108,91a7.6,7.6,0,0,1,0,10.72L101.73,108A7.61,7.61,0,0,1,91,108l-6.34-6.35a47.22,47.22,0,0,1-11.19,5v8.59a7.6,7.6,0,0,1-7.58,7.58H57a7.6,7.6,0,0,1-7.58-7.58v-7.76a47.39,47.39,0,0,1-12.35-4.68L31.87,108a7.62,7.62,0,0,1-10.72,0l-6.31-6.31a7.61,7.61,0,0,1,0-10.72l4.72-4.72A47.38,47.38,0,0,1,14,73.48H7.58A7.6,7.6,0,0,1,0,65.9V57A7.6,7.6,0,0,1,7.58,49.4h6.35a47.2,47.2,0,0,1,5.51-12.94l-4.6-4.59a7.62,7.62,0,0,1,0-10.72l6.31-6.31a7.6,7.6,0,0,1,10.72,0l5,5A46.6,46.6,0,0,1,49.4,15V7.58A7.6,7.6,0,0,1,57,0H65.9a7.6,7.6,0,0,1,7.58,7.58v8.26ZM59.86,36.68a24.6,24.6,0,1,1-24.6,24.59,24.59,24.59,0,0,1,24.6-24.59Z"></path>
                        </svg>
                        Settings
                    </a>
                    <a class="sidebar__link sidebar__link--button" role="button" on:click={bark}>Bark</a>
                {:else}
                    {#if !!hasLoaded}
                        <a class="sidebar__link sidebar__link--text" role="button">
                            <svg height="24px" width="24px" viewBox="0 0 311.39 507.11">
                                <title>ethereum-eth</title>
                                <polygon fill="var(--darkGray)"  points="155.65 0 152.25 11.56 152.25 346.87 155.65 350.26 311.3 258.26 155.65 0"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 0 0 258.26 155.65 350.27 155.65 187.51 155.65 0"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 379.74 153.73 382.07 153.73 501.52 155.65 507.11 311.39 287.78 155.65 379.74"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 507.11 155.65 379.73 0 287.78 155.65 507.11"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 350.26 311.3 258.26 155.65 187.51 155.65 350.26"></polygon>
                                <polygon fill="var(--darkGray)"  points="0 258.26 155.65 350.26 155.65 187.51 0 258.26"></polygon>
                            </svg>
                            {$selectedAccount.toString().toLowerCase().substring(0, 8)}
                        </a>
                        <a class="sidebar__link sidebar__link--button" href="/signup/">Sign Up</a>
                    {:else}
                        <a class="sidebar__link sidebar__link--text" role="button">
                            <svg height="24px" width="24px" viewBox="0 0 311.39 507.11">
                                <title>ethereum-eth</title>
                                <polygon fill="var(--darkGray)"  points="155.65 0 152.25 11.56 152.25 346.87 155.65 350.26 311.3 258.26 155.65 0"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 0 0 258.26 155.65 350.27 155.65 187.51 155.65 0"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 379.74 153.73 382.07 153.73 501.52 155.65 507.11 311.39 287.78 155.65 379.74"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 507.11 155.65 379.73 0 287.78 155.65 507.11"></polygon>
                                <polygon fill="var(--darkGray)"  points="155.65 350.26 311.3 258.26 155.65 187.51 155.65 350.26"></polygon>
                                <polygon fill="var(--darkGray)"  points="0 258.26 155.65 350.26 155.65 187.51 0 258.26"></polygon>
                            </svg>
                            {$selectedAccount.toString().toLowerCase().substring(0, 8)}
                        </a>
                        <a class="sidebar__link" role="button">
                            <svg height="24px" width="24px" x="0px" y="0px" viewBox="0 0 120.641 122.878" enable-background="new 0 0 120.641 122.878" xml:space="preserve">
                                <g>
                                    <path fill="var(--darkGray)" fill-rule="evenodd" clip-rule="evenodd" d="M68.16,6.889c18.129,3.653,31.889,19.757,31.889,38.921 c0,22.594-2.146,39.585,20.592,54.716c-40.277,0-80.366,0-120.641,0C22.8,85.353,20.647,68.036,20.647,45.81 c0-19.267,13.91-35.439,32.182-38.979C53.883-2.309,67.174-2.265,68.16,6.889L68.16,6.889z M76.711,109.19 c-1.398,7.785-8.205,13.688-16.392,13.688c-8.187,0-14.992-5.902-16.393-13.688H76.711L76.711,109.19z"></path>
                                </g>
                            </svg>
                            Notifications
                        </a>
                        <a class="sidebar__link" role="button">
                            <span class="skeleton-avatar skeleton-effect-wave"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 100 100" preserveAspectRatio="none"><rect width="100" height="100" fillrule="evenodd" style="" rx="50%"></rect><path style="" d="M50.20054464285714,49.249180089285716 C56.179458125,49.249180089285716 61.32402178571428,43.90991107142857 61.32402178571428,36.95770821428572 C61.32402178571428,30.088916625000003 56.15169392857143,25 50.20054464285714,25 C44.24951401785714,25 39.0770675,30.200210723214283 39.0770675,37.01335526785714 C39.0770675,43.90991107142857 44.24951401785714,49.249180089285716 50.20054464285714,49.249180089285716 Z M32.73674488392857,75 L67.66446303571429,75 C72.03032401785714,75 73.58761080357144,73.74859401785716 73.58761080357144,71.30142901785715 C73.58761080357144,64.12675660714285 64.60541785714287,54.226921339285724 50.20054464285714,54.226921339285724 C35.76790723214286,54.226921339285724 26.785714285714285,64.12675660714285 26.785714285714285,71.30142901785715 C26.785714285714285,73.74859401785716 28.34288242857143,75 32.73674488392857,75 Z"></path></svg></span>
                            Profile
                        </a>
                        <a class="sidebar__link" role="button">
                            <svg height="24px" width="24px" viewBox="0 0 122.88 122.88">
                                <path fill="var(--darkGray)" fill-rule="evenodd" d="M73.48,15.84A46.87,46.87,0,0,1,84.87,21L91,14.84a7.6,7.6,0,0,1,10.72,0L108,21.15a7.6,7.6,0,0,1,0,10.72l-6.6,6.6a46.6,46.6,0,0,1,4.34,10.93h9.52A7.6,7.6,0,0,1,122.88,57V65.9a7.6,7.6,0,0,1-7.58,7.58h-9.61a46.83,46.83,0,0,1-4.37,10.81L108,91a7.6,7.6,0,0,1,0,10.72L101.73,108A7.61,7.61,0,0,1,91,108l-6.34-6.35a47.22,47.22,0,0,1-11.19,5v8.59a7.6,7.6,0,0,1-7.58,7.58H57a7.6,7.6,0,0,1-7.58-7.58v-7.76a47.39,47.39,0,0,1-12.35-4.68L31.87,108a7.62,7.62,0,0,1-10.72,0l-6.31-6.31a7.61,7.61,0,0,1,0-10.72l4.72-4.72A47.38,47.38,0,0,1,14,73.48H7.58A7.6,7.6,0,0,1,0,65.9V57A7.6,7.6,0,0,1,7.58,49.4h6.35a47.2,47.2,0,0,1,5.51-12.94l-4.6-4.59a7.62,7.62,0,0,1,0-10.72l6.31-6.31a7.6,7.6,0,0,1,10.72,0l5,5A46.6,46.6,0,0,1,49.4,15V7.58A7.6,7.6,0,0,1,57,0H65.9a7.6,7.6,0,0,1,7.58,7.58v8.26ZM59.86,36.68a24.6,24.6,0,1,1-24.6,24.59,24.59,24.59,0,0,1,24.6-24.59Z"></path>
                            </svg>
                            Settings
                        </a>
                        <a class="sidebar__link sidebar__link--button" role="button">Bark</a>
                    {/if}
                {/if}
            {/if}
        </div>
        <div class="container__center">
            <slot />
        </div>
        <div class="container__right"></div>
    </div>
</div>

<style>
    .wrapper {
        align-items: flex-start;
        background-repeat: no-repeat;
        display: flex;
        justify-content: center;
        width: 100%;
        .container {
            align-items: flex-start;
            //background-color: var(--extraLightGray);
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            min-height: 100vh;
            max-width: 1200px;
            padding: 0 40px;
            width: 100%;
            .container__left {
                display: flex;
                flex-direction: column;
                max-width: 250px;
                row-gap: 16px;
                width: 100%;
                .container__top {
                    .beta {
                        color: #444;
                        font-size: 14px;
                        font-weight: 600;
                        margin-left: 52px;
                    }
                }
                h1 {
                    align-items: center;
                    column-gap: 8px;
                    display: flex;
                    margin-bottom: 2px;
                    margin-left: 16px;
                    img {
                        height: 28px;
                        width: 28px;
                    }
                    span {
                        font-size: 28px;
                    }
                }
                .sidebar__link {
                    align-items: center;
                    border-radius: 32px;
                    color: var(--black);
                    column-gap: 12px;
                    display: flex;
                    font-size: 24px;
                    font-weight: 700;
                    margin-right: 32px;
                    padding: 16px;
                    text-decoration: none;
                    transition: .1s all ease;
                    > svg {
                        padding-bottom: 4px;
                    }
                    > .skeleton-avatar {
                        height: 24px;
                        width: 24px;
                    }
                    > img {
                        border-radius: 50%;
                    }
                    &:hover {
                        background-color: var(--lightGray);
                    }
                    &:focus {
                        outline: 2px solid var(--darkGray);
                    }
                    &.sidebar__link--text {
                        color: var(--darkGray);
                        &:hover {
                            background: transparent;
                        }
                        &:focus {
                            outline: none;
                        }
                    }
                    &.sidebar__link--button {
                        background-color: var(--blue);
                        color: var(--white);
                        cursor: pointer;
                        justify-content: center;
                        text-align: center;
                        &:hover {
                            opacity: .8;
                        }
                        &:focus {
                            outline: 2px solid var(--blue); // todo - troubleshoot
                        }
                    }
                }
            }
            .container__center {
                background-color: var(--extraExtraLightGray);
                border-left: 1px solid var(--darkGray);
                border-right: 1px solid var(--darkGray);
                border-top: 1px solid var(--darkGray);
                display: flex;
                flex-direction: column;
                margin-top: 32px;
                max-width: 600px;
                min-height: 100vh;
                width: 100%;
            }
            .container__right {
                max-width: 350px;
                width: 100%;
            }
        }
    }
    @media screen and (min-width: 1100px) {
        .wrapper .container {
            flex-direction: row;
            .container__center {
                border-top: 0;
                margin-top: 0;
            }
        }
    }
</style>
