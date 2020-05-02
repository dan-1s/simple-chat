#!/bin/sh

# build client
npm install --prefix assets
npm run deploy --prefix assets

# build release
mix phx.digest && MIX_ENV=prod mix release --overwrite
