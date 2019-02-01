#
# Build image
#

FROM elixir:1.7.4-alpine AS build

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

USER root

RUN apk update \
  && apk upgrade \
  && apk add --update make gcc alpine-sdk openssl openssl-dev gawk wget git curl fish bash

WORKDIR /app

ENV MIX_ENV=prod

RUN mix local.hex --force \
  && mix local.rebar --force

COPY . ./

RUN mix do deps.get, compile, release --env=prod

#
# Runtime image
#

FROM alpine:3.6

ARG MIX_ENV=prod

# Add local node module binaries to PATH
ENV LANG=en.US.UTF-8 \
  TERM=xterm \
  HOME=/root \
  MIX_ENV=prod

RUN apk update && \
  apk --no-cache --update add -f \
  curl-dev \
  bash \
  wget curl inotify-tools \
  openssl bind-tools \
  && update-ca-certificates --fresh \
  && rm -rf /var/cache/apk/*

WORKDIR /app

# Cache elixir deps
COPY --from=build /app/_build/${MIX_ENV}/rel/hello ./

CMD ./hello foreground
