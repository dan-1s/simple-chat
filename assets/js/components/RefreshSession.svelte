<script>
    import {fade} from 'svelte/transition'
</script>

<style>
    div {
        display: flex;
        flex-direction: column;
        height: 100%;
        justify-content: center;
        align-items: center;
    }

    button {
        color: white;
        background: #7a3691;
        padding: 1rem;
        border: none;
        border-radius: .5rem;

        font-size: 1rem;
        font-weight: bold;
        text-transform: uppercase;
    }
</style>

<div in:fade={{delay: 500}}>
    <p>Session data has changed!</p>
    <button on:click={() => window.location.reload()}>Reload page</button>
</div>
