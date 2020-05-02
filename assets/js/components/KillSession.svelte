<script>
    const csrfToken = document.querySelector('meta[csrf-param=_csrf_token]');

</script>

<style>
    form {
        display: flex;
        justify-content: center;
    }

    button {
        color: white;
        background: #ff4545;
        padding: 1rem;
        border: none;
        border-radius: .5rem;

        font-size: 1rem;
        font-weight: bold;
        text-transform: uppercase;
    }
</style>

<form action="/kill-session" method="post">
    <button>Kill session</button>
    <input type="hidden" name="_csrf_token" value="{csrfToken.content}">
</form>
