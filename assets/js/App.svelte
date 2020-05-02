<script>
    import SetUsername from './components/SetUsername.svelte'
    import Chat from "./components/Chat.svelte";
    import Ipad from "./components/Ipad.svelte";
    import {chat, messages, currentRoom} from './store/chat';
    import {user, userName, refreshSession} from './store/user';
    import KillSession from "./components/KillSession.svelte";
    import RefreshSession from "./components/RefreshSession.svelte";

    let refresh;
    let noName;
    let allSet;

    $: refresh = $user.isConnected && $refreshSession === true;
    $: noName = $user.isConnected && $userName === null;
    $: allSet = $chat.isConnected && $userName !== null;
</script>

<style>
    :global(.node-info) {
        display: flex;
        justify-content: center;
        color: #ff4545;
        font-size: 2rem;
        padding: 2rem;
    }

    :global(*) {
        box-sizing: border-box;
    }

    :global(body) {
        font-family: "Quicksand", sans-serif;
    }
</style>

<Ipad>
    {#if refresh}
        <RefreshSession />
    {:else}
        {#if noName}
            <SetUsername />
        {/if}

        {#if allSet}
            <Chat roomName={$currentRoom}
                  userName={$userName}
                  messages={$messages} />
        {/if}
    {/if}
</Ipad>

<KillSession />
