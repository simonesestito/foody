FROM ubuntu:22.04 AS build-flutter

# Install Flutter
RUN apt-get update -y \
    && apt-get install git curl wget file unzip zip xz-utils tar -y \
    && wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.3-stable.tar.xz -O /flutter-sdk.tar.xz \
    && cd /opt \
    && tar xfv /flutter-sdk.tar.xz \
    && /opt/flutter/bin/flutter precache --no-ios --no-linux --no-windows --no-fuchsia --no-android --no-macos

# Compile Flutter app for Web
WORKDIR /app
COPY ./webapp ./
RUN /opt/flutter/bin/flutter pub get
RUN /opt/flutter/bin/flutter build web

# ----------------------------

FROM node:17.5.0 AS build-backend
WORKDIR /app
# It skips files ignored in .dockerignore
COPY ./backend ./

RUN npm install && npm run build

# ----------------------------

FROM node:17.5.0-alpine3.15

LABEL name="Foody Project"
LABEL description="Final project for Databases course of Sapienza University of Rome, Spring 2022"
LABEL url="https://github.com/simonesestito/foody"
LABEL mantainer="simone@simonesestito.com"

ENV NODE_ENV production
ENV PORT 8080

WORKDIR /app
COPY --from=build-flutter /app/build/web ./webapp/build/web

WORKDIR /app/backend
COPY --from=build-backend /app/dist ./dist
COPY ./backend/package.json .
COPY ./backend/package-lock.json .
# TODO: Add other runtime necessary files here

# Switch to a non-root user
RUN adduser -D foody
RUN chown -R foody:foody /app
USER foody

RUN npm install --only=prod
EXPOSE 8080
ENTRYPOINT [ "node", "." ]
