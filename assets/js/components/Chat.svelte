<script>
    import {fade} from 'svelte/transition'
    import { sendChatMsgToRoom } from "../socket";
    import { afterUpdate } from 'svelte';
    import formatDistance from 'date-fns/formatDistance'

    export let roomName;
    export let userName;
    export let messages;

    let msg = "";
    const resetMsg = () => msg = "";

    let input;
    let container;

    const scrollToInput = () => {
        // TODO: Disable this when scrolling up a bit ?
        container.scrollTop = input.offsetTop + input.getBoundingClientRect().height;
    }

    let handleKeyDown = (e) => {
        const key = e.key;

        if (key === 'Enter') {
            e.preventDefault();
            sendChatMsgToRoom(msg, userName)
            resetMsg();
        }
    }

    const getTimeAgo = (timestamp) => formatDistance(Date.now(), new Date(timestamp)) + " ago";

    afterUpdate(scrollToInput);
</script>

<style>
    .chat {
        padding: 2rem;
        font-size: .8rem;
        border-radius: .2rem;
        height: 100%;
        overflow: scroll;

        display: grid;
        grid-template-rows: 10fr 1fr 1fr;
        grid-template-areas:
                "chat chat chat chat"
                "you you you you"
                "input input input input";

        letter-spacing: .075rem;
    }

    .current-room {
        position: absolute;
        top: 0;
        right: 25px;
    }

    .current-room span {
        font-weight: bold;
    }

    label {
        grid-area: you;
        margin-top: 2rem;
        margin-bottom: 1rem;
    }

    .you {
        font-weight: bold;
    }

    textarea {
        grid-area: input;
        width: 100%;
        box-sizing: border-box;

        resize: none;
        outline: none;

        border-radius: .5rem;
        font-family: inherit;
        border: 2px solid rgba(176, 176, 176, 0.5);
        background: rgba(255,255,255,.5);

        padding: 1rem;
        font-size: 1rem;
        height: 3.5rem;
        letter-spacing: 0.1rem;
    }

    ul {
        margin: 0;
        padding: 0;
    }

    li {
        list-style: none;
        padding: 1rem;
    }

    .messages {
        grid-area: chat;
        height: 100%
    }

    .user {
        margin-bottom: .2rem;
        font-weight: bold;
        font-size: 1rem;

        display: inline-block;
        border-radius: 1rem;
        position: relative;
    }

    .user:before,
    .user:after {
        position: absolute;
        content: "";
        background: yellow;
        top: calc(50% - 8px);
        right: -36px;
        transform: rotate(45deg);
        width: 16px;
        height: 16px;
    }

    .user:after {
        z-index: 2;
    }

    .user:before {
        z-index: 0;
        box-shadow: 1px 0 10px -2px black
    }

    .message {
        display: inline-block;
        line-height: 1.8rem;

        background: yellow;
        box-shadow: 0 1px 10px -4px black;

        margin-left: 20px;
        padding: 1rem;
        border-radius: 1rem;

        z-index: 1;
        position: relative;
    }
</style>

<p class="current-room">
    Room:
    <span>{roomName === "" ? "Lobby" : roomName }</span>
</p>

<div in:fade={{delay: 100}} class="chat" bind:this={container}>
    <ul class="messages">
        {#each messages as {id, user, msg, timestamp}, index (id) }
            <li>
                <span class="user">{user}</span>
                <span class="message">{msg}</span>
                <p class="time">{getTimeAgo(timestamp)}</p>
            </li>
        {/each}
    </ul>


    <label for="input">
        You are writing as <span class="you">{userName}</span>
    </label>
    <textarea id="input" on:keydown={handleKeyDown} bind:this={input} bind:value={msg}></textarea>
</div>

