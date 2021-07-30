FROM elixir:1.12.1-alpine AS devenv

# * postgresql-client is needed since the entrypoint.h script uses pg_isready
# * inotify-tools is needed to make fileystem watching (for rebuilds) work
# * nodejs and yarn are used by the application's build process
RUN apk update && \
  apk add postgresql-client inotify-tools nodejs yarn

# Install Hex package manager and rebar (the Erlang build toool)
RUN mix local.rebar --force && mix local.hex --force

FROM devenv AS build
ENV MIX_ENV prod

WORKDIR /app
COPY . .

RUN mix do deps.get --only prod
RUN mix do compile, phx.digest, release

FROM alpine AS release

RUN apk add --no-cache libstdc++ postgresql-client

USER nobody
WORKDIR /app
COPY --from=build --chown=noboody: /app/entrypoint.sh /app/_build/prod/rel/liveview_test .

CMD ["/app/entrypoint.sh"]

