# SimpleChat

Exploring distributed features of Elixir/Phoenix, not intended for production use.
Named it `SimpleChat` and it was pretty simple in the beginning, its not super complex
now but I don't know if it's simple, if you think it is then good, you got this! :)

**IMPORTANT**: There's security aspects to consider when using distributed erlang.

In Elixir these features are opt in. For the releases we're opting in with changes in `rel/env.sh.eex`
where we configure `RELEASE_DISTRIBUTION`, `RELEASE_NODE` and `ELIXIR_ERL_OPTIONS`.

## Prerequisites
1. Elixir and Erlang. See [installation instructions](https://elixir-lang.org/install.html).
2. Phoenix. See [installation instruction](https://hexdocs.pm/phoenix/installation.html).

## How to run development server 
You can start a single instance development server using `PORT=4000 mix phx.server` then
visit [localhost:4000](http://localhost:4000).

To start multiple instances and connect them together:
1. In a terminal tab type `PORT=4000 iex --name one@127.0.0.1 -S mix phx.server`
2. In another terminal tab type `PORT=4001 iex --name two@127.0.0.1 -S mix phx.server`
3. Then connect them, e.g. if you're on `one@127.0.0.1` type `Node.connect(:"two@127.0.0.1")` or vice versa.

## Build a production release

Build assets:
```
npm install --prefix assets
npm run deploy --prefix assets
```
Create release:
```
mix phx.digest && MIX_ENV=prod mix release
```

or just:
```
bash build-release.sh
```

Now we can test it by starting two different nodes of the release locally. 

The `NODE_NAME` and `HOSTNAME` is env variables to build a fully qualified name for
the release like `node1@127.0.0.1` and `node2@127.0.0.1`.

```
PORT=4000 NODE_NAME=node1 HOSTNAME=127.0.0.1 BEAM_PORT=8995 RELEASE_COOKIE=change-this-make-it-really-secure-and-do-not-share SECRET_KEY_BASE=$(mix phx.gen.secret) \
_build/prod/rel/simple_chat/bin/simple_chat start
```

```
PORT=4001 NODE_NAME=node2 HOSTNAME=127.0.0.1 BEAM_PORT=8996 RELEASE_COOKIE=change-this-make-it-really-secure-and-do-not-share SECRET_KEY_BASE=$(mix phx.gen.secret) \
_build/prod/rel/simple_chat/bin/simple_chat start_iex
```

In iex you can now connect `node2@127.0.0.1` to `node1@127.0.0.1`
```
iex(node2@127.0.0.1)1> Node.connect(:"node1@127.0.0.1")
true
iex(node2@127.0.0.1)2> Node.list
[:"node1@127.0.0.1"]
``` 
