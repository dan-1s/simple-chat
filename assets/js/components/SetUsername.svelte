<script>
    import {fade} from 'svelte/transition'

    let form;
    let username = "";
    let csrfInput = { value: "" };

    let invalid = false;
    const resetInvalid = () => invalid = false;

    function validate(str) {
        const trimmed = str.trim();
        const len = trimmed.length;
        const re =/^([a-zA-Z0-9åäöÅÄÖ]+\s)*[a-zA-Z0-9åäöÅÄÖ]+$/g

        return len >= 2 && len <= 20 ? Boolean(trimmed.match(re)) : false;
    }

    function onSubmit(e) {
        e.preventDefault();
        const isValid = validate(username);
        const token = document.querySelector('meta[csrf-param=_csrf_token]');
        csrfInput.value = token.content

        if (!isValid) {
            invalid = true;
            return;
        }

        form.submit();
    }

</script>

<style>
    form {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100%;
    }

    input {
        font-size: 1.2rem;
        border: 1px solid #eee;
        border-radius: .5rem;
        padding: 1rem;
    }

    input[type="text"] {
        margin: 1rem 0;
    }

    label {
        display: block;
    }

    button {
        color: white;
        background: #39c0e0;
        padding: 1rem;
        border: none;
        border-radius: .5rem;

        font-size: 1rem;
        font-weight: bold;
        text-transform: uppercase;
    }

    .invalid {
        visibility: hidden;
        color: #ff4545;
    }

    .invalid.show {
        visibility: visible;
    }
</style>

<form in:fade={{delay: 300}} bind:this={form} action="/set-name" method="post" on:submit={onSubmit}>
    <p class="invalid" class:show={invalid}>Please enter a valid username, between 2-20 characters (a-öA-Ö0-9) </p>
    <label for="username">What's your name ?</label>
    <input on:input="{resetInvalid}" bind:value={username} name="username" id="username" type="text">
    <button type="submit">Set name</button>
    <input type="hidden" name="_csrf_token" bind:this={csrfInput}>
</form>

