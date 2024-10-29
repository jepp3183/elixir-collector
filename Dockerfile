FROM elixir:1.17.3-alpine as builder

ENV MIX_ENV=prod

WORKDIR /app
COPY lib ./lib
COPY config ./config
COPY mix.exs .
COPY mix.lock .

RUN mix local.hex --force \
    && mix deps.get \
    && mix release

FROM elixir:1.17.3-alpine

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/elixir_exporter .

CMD ["./bin/elixir_exporter", "start"]
