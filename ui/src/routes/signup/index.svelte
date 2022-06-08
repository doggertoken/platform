<script>
    import '$lib/global.scss';
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore } from 'svelte-web3';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
    import Swal from 'sweetalert2';

    const connectWallet = () => {
        defaultChainStore.setBrowserProvider();
    };

    let displayName = ``;
    let username = ``;
    let bio = ``;

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

    let signingUp = false;
    let loading = false;

    let errored = false;

    const signup = () => {
        if (!!$connected) {
            if (!signingUp) {
                signingUp = true;
                if (displayName.length <= 0) {
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
                        title: `Display Name cannot be blank!`,
                    });
                    signingUp = false;
                    return;
                } else if (username.length <= 0) {
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
                        title: `Username cannot be blank!`,
                    });
                    signingUp = false;
                    return;
                } else if (bio.length <= 0) {
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
                        title: `Bio cannot be blank!`,
                    });
                    signingUp = false;
                    return;
                }
                const contract = new $web3.eth.Contract(abi, config.address);
                loading = true;
                contract.methods.addUser(
                    displayName,
                    username,
                    bio,
                    ``,
                    ``
                ).send({
                    from: $selectedAccount,
                }).then((tx) => {
                    loading = false;
                    goto(`/profile?u=${$selectedAccount}`);
                }).catch((e) => {
                    errored = true;
                });
                //console.log(tx);
                //trx = tx;
                signingUp = false;
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

    const load = async () => {
        if (!!$connected) {
            const exists = await userExists($selectedAccount);
            if (!!exists) {
                goto(`/profile?u=${$selectedAccount}`);
            }
        }
    };

    onMount(() => {
        load();
    });

    $: $connected, load();
    $: $selectedAccount, load();
</script>

<h1>Sign Up</h1>

<section>
    <h2 /><!-- TODO remove-->
    <div class="signup">
        <label>Display Name</label>
        <input bind:value={displayName} class="signup__input" type="text" maxlength="32" required placeholder="Example" />
        <label>Username</label>
        <input bind:value={username} class="signup__input" type="text" maxlength="32" required placeholder="example" />
        <label>Bio</label>
        <input bind:value={bio} class="signup__input" type="text" maxlength="160" required placeholder="I like dogs" />
        <button class="signup__button" on:click={signup}>
            Create Account
        </button>
    </div>
</section>

{#if !!loading}
    <p class="p">Transaction pending...</p>
{/if}

{#if !!errored}
    <p class="p">Transaction unsuccessful. Please try again!</p>
{/if}

<style>
    h1, h2 {
        padding-left: 12px;
    }
    .p {
        font-size: 17px;
        font-weight: 700;
        margin-top: 40px;
        text-align: center;
    }
    section {
        border-top: 1px solid var(--darkGray);
        &:last-child {
            border-bottom: 1px solid var(--darkGray);
        }
    }
    .signup {
        display: flex;
        flex-direction: column;
        margin: 0 12px 24px 12px;
        label {
            margin-bottom: 4px;
        }
        input {
            margin-bottom: 12px;
        }
        .signup__button {
            background-color: #e4eefa;
            border: 0;
            border-radius: 16px;
            color: var(--blue);
            cursor: pointer;
            font-size: 18px;
            font-weight: 700;
            margin-top: 8px;
            outline: none;
            padding: 16px 32px;
            transition: .1s all ease;
            width: 200px;
            &:hover {
                opacity: .8;
            }
            &:focus {
                outline: 2px solid var(--blue);
            }
        }
    }
    label {
        font-size: 18px;
        padding-bottom: 2px;
    }
    input {
        border: 2px solid var(--darkGray);
        border-radius: 18px;
        font-size: 16px;
        outline: none;
        padding: 8px;
        transition: .1s all ease;
        &:hover {
            border-color: var(--black);
        }
        &:focus {
            border-color: var(--blue);
        }
    }
</style>
