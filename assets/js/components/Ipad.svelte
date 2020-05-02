
<style>
    .shell {
        width: 780px;
        height: 599px;
        box-shadow:
                0 0 0 28px black,
                0 0 0 29px #bbb,
                0 0 0 31px #ccc,
                0 0 0 32px #fff,
                0 0 20px 35px rgba(0,0,0,.5);
        margin: 0 auto 100px auto;
        border-radius: 5px;
        position: relative;
        z-index: 1;
    }

    .shell:before,
    .shell:after {
        position: absolute;
        content: "";
    }

    @keyframes gradient {
        0% {
            background-position: 0 50%;
        }
        50% {
            background-position: 100% 50%;
        }
        100% {
            background-position: 0 50%;
        }
    }

    .shell:before {
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        background: white;
        box-shadow: 0 0 0 20px black;
        border-radius: 25px;
        z-index: 0;
    }

    .shell:after{
        left: 812px;
        top: 500px;
        height: 35px;
        width: 2px;
        background: #888;
        box-shadow:
                1px 0 0 0 #bbb,
                2px 0 10px 0 rgba(0,0,0,.5);
        border-radius: 15%;
    }

    .bottom-btns,
    .bottom-btns:after {
        position: absolute;
        content: "";
        height: 2px;
        width: 70px;
        background: #888;

        box-shadow:
                0 1px 0 0 #bbb,
                0 2px 10px 0 rgba(0,0,0,.5);
        border-radius: 15%;
    }

    .bottom-btns {
        bottom: -35px;
        left: 530px;
    }

    .bottom-btns:after {
        left: 100px;
    }


    .ipad-content {
        position: absolute;
        top: 0;
        left: 0;

        border-radius: 15px;
        padding-bottom: 2rem;

        height: 100%;
        width: 100%;
    }

    :global(.webplossless .ipad-content) {
        background: url("/images/pen.webp");
        background-size: cover;
    }

    :global(html:not(.webplossless) .ipad-content) {
        background: url("/images/pen.jpg");
        background-size: cover;
    }

    @media screen and (max-width: 1024px) {
        .shell {
            width: 428px;
            height: 685px;
        }

        .bottom-btns {
            left: 200px;
        }

        .bottom-btns:after {
            left: 100px;
        }

        .shell:after{
            top: 570px;
            left: 460px;
        }

    }
</style>

<div class="shell">
   <span class="bottom-btns"></span>
    <div class="ipad-content">
        <slot />
    </div>
</div>
