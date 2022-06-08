<script>
    import '$lib/global.scss';
    import { connected, web3, selectedAccount, chainId, chainData, defaultChainStore } from 'svelte-web3';
    import abi from '$lib/abi';
    import config from '$lib/config';
    import { Web3Storage } from 'web3.storage';
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
    import Swal from 'sweetalert2';

    const connectWallet = () => {
        defaultChainStore.setBrowserProvider();
    };

    let filesProfile;
    let filesBanner;

    const WEB3_STORAGE = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDdlZjdCMDgwNzhBOTEwODJmYzM3NTlGYmUzRDAxRTkxNGVmM2JEMWUiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2NDg2MDQ2MTQzNjQsIm5hbWUiOiJEb2dnZXIifQ.G2iC_OzkgBSBdVfZFnycKKoJhnTsKo-BheW07VaLS4c`;

    const uploadFiles = async (files) => {
        const client = new Web3Storage({
            token: WEB3_STORAGE,
        });
        const cid = await client.put(files, {
            wrapWithDirectory: false,
        });
        console.log(cid);
        return cid;
    };
    const retrieveFiles = async (hash) => {
        const client = new Web3Storage({ token: WEB3_STORAGE, });
        const res = await client.get(hash);
        if (res.ok) {
            const resFiles = await res.files();
            return resFiles;
        } else {
            return null;
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

    let displayName = ``;
    let username = ``;
    let bio = ``;
    let website = ``;
    let location = ``;
    let ipfsProfile = ``;
    let ipfsBanner = ``;

    let text;

    const retrieveUserByAddress = async () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            const user = await contract.methods.retrieveUserByAddress(
                $selectedAccount
            ).call();
            displayName = user.displayName;
            username = user.username;
            bio = user.bio;
            website = user.website;
            location = user.location;
            ipfsProfile = user.ipfsProfile;
            ipfsBanner = user.ipfsBanner;
        } else {
            console.log(`Not connected...`);
        }
    };

    let editing = false;

    const editProfile = async () => {
        if (!!$connected) {
            if (!editing) {
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
                        title: `Display name cannot be blank!`,
                    });
                    editing = false;
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
                    editing = false;
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
                    editing = false;
                    return;
                }
                editing = true;
                if (typeof filesProfile !== `undefined`) {
                    ipfsProfile = await uploadFiles(filesProfile);
                }
                if (typeof filesBanner !== `undefined`) {
                    ipfsBanner = await uploadFiles(filesBanner);
                }
                const contract = new $web3.eth.Contract(abi, config.address);
                const user = await contract.methods.retrieveUserByAddress(
                    $selectedAccount
                ).call();
                contract.methods.updateUser(
                    displayName,
                    username,
                    bio,
                    !!validateUrl(website) ? website : user.website,
                    location,
                    ipfsProfile,
                    ipfsBanner
                ).send({
                    from: $selectedAccount,
                });
                editing = false;
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

    const deleteAccount = () => {
        if (!!$connected) {
            const contract = new $web3.eth.Contract(abi, config.address);
            contract.methods.removeUser().send({
                from: $selectedAccount,
            });
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

    onMount(() => {
        if (!$connected) {
            goto(`/`);
        } else {
            retrieveUserByAddress();
        }
    });
</script>

<h1>Settings</h1>

<section>
    <h2>Update Profile</h2>
    <div class="signup">
        <label>Display Name</label>
        <input bind:value={displayName} class="signup__input" type="text" maxlength="32" required placeholder="example" />
        <label>Username</label>
        <input bind:value={username} class="signup__input" type="text" maxlength="32" required placeholder="example" />
        <label>Bio</label>
        <input bind:value={bio} class="signup__input" type="text" maxlength="160" required placeholder="I like dogs" />
        <label>Website</label>
        <input bind:value={website} class="signup__input" type="text" maxlength="32" placeholder="https://example.com" />
        <label>Location</label>
        <input bind:value={location} class="signup__input" type="text" maxlength="32" placeholder="Antarctica" />
        <label>Profile Pic</label>
        <input bind:files={filesProfile} type="file" multiple />
        <label>Profile Banner</label>
        <input bind:files={filesBanner} type="file" multiple />
        <button class="signup__button" on:click={editProfile}>
            Edit Profile
        </button>
    </div>
</section>

<section>
    <h2>Danger Zone</h2>
    <button class="button" on:click={deleteAccount}>
        Delete Account
    </button>
</section>

<style>
    h1, h2 {
        padding-left: 12px;
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
    .button {
        background-color: #fae4e4;
        border: 0;
        border-radius: 16px;
        color: #f00;
        cursor: pointer;
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 24px;
        margin-left: 12px;
        outline: none;
        padding: 16px 32px;
        transition: .1s all ease;
        width: 200px;
        &:hover {
            opacity: .8;
        }
        &:focus {
            outline: 2px solid #f00;
        }
    }
</style>
