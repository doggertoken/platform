<script>
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore } from 'svelte-web3';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import { onMount } from 'svelte';
    import Barks from '$lib/components/Barks.svelte';
    import { goto } from '$app/navigation';
    import Swal from 'sweetalert2';

    let text = ``;
    let remainingCharacters = 280;

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

    const bark = async () => {
        if (!!$connected) {
            const exists = await userExists($selectedAccount);
            if (!!exists) {
                if (text == ``) {
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
                contract.methods.addBark(
                    text,
                    false,
                    ``
                ).send({
                    from: $selectedAccount,
                }).then((tx) => {
                    showBarks = false;
                    setTimeout(() => {
                        showBarks = true;
                        text = ``;
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

    const charAlert = () => {
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
    };

    $: text, remainingCharacters = 280 - text.length;
</script>

<div class="bark">
    <textarea bind:value={text} class="bark__textarea" placeholder="What's on your mind?" expandable="false" maxlength="280" autofocus />
    <div class="bark__bottom">
        <span class="bark__characters">
            <span class="bark__characters__remaining {remainingCharacters <= 80 ? `bark__characters__remaining--orange` : ``} {remainingCharacters <= 0 ? `bark__characters__remaining--red` : ``}">{remainingCharacters}</span>
            characters remaining
        </span>
        {#if !!loading}
            <button class="bark__button" on:click={bark}>
                Posting...
            </button>
        {:else}
            {#if remainingCharacters < 0}
                <button class="bark__button" on:click={charAlert}>
                    Bark
                </button>
            {:else}
                <button class="bark__button" on:click={bark}>
                    Bark
                </button>
            {/if}
        {/if}
    </div>
</div>

{#if showBarks}
    <Barks type="default" user="" />
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
            align-items: center;
            display: flex;
            justify-content: space-between;
        }
    }
    .bark__characters {
        color: var(--darkGray);
        margin: 8px 0 8px 8px;
        .bark__characters__remaining {
            color: #000;
            font-weight: 600;
            transition: .2s all ease;
            &.bark__characters__remaining--orange {
                color: darkorange;
            }
            &.bark__characters__remaining--red {
                color: #f00 !important;
            }
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
</style>
