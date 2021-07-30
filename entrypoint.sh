#!/bin/sh
# Docker entrypoint script.

cd assets && yarn install && node node_modules/webpack/bin/webpack.js --mode development && cd ..
exec iex -S mix phx.server
