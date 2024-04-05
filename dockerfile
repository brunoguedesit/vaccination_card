FROM elixir:1.15.7-otp-25

WORKDIR /vaccination_card

COPY mix.exs mix.lock ./

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

COPY . .

RUN mix compile

CMD ["iex"]