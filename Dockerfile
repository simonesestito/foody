FROM ubuntu:22.04 AS build-flutter

# Install Flutter
RUN apt-get update -y \
    && apt-get install git curl wget file unzip zip xz-utils tar -y \
    && wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.4-stable.tar.xz -O /flutter-sdk.tar.xz \
    && cd /opt \
    && tar xfv /flutter-sdk.tar.xz \
    && /opt/flutter/bin/flutter precache --no-ios --no-linux --no-windows --no-fuchsia --no-android --no-macos

# Compile Flutter app for Web
WORKDIR /app
COPY ./webapp ./
RUN /opt/flutter/bin/flutter pub get
RUN /opt/flutter/bin/flutter packages pub run build_runner build
RUN /opt/flutter/bin/flutter build web

# ----------------------------

FROM gradle:7.4.1-jdk17 AS build-backend
WORKDIR /app
# It skips files ignored in .dockerignore
COPY ./spring-backend ./
COPY --from=build-flutter /app/build/web ./src/main/resources/static

RUN gradle build

# ----------------------------

FROM openjdk:17-alpine3.14

LABEL name="Foody Project"
LABEL description="Final project for Databases course of Sapienza University of Rome, Spring 2022"
LABEL url="https://github.com/simonesestito/foody"
LABEL mantainer="simone@simonesestito.com"

WORKDIR /app
COPY --from=build-backend /app/build/libs/spring-backend-0.0.1-SNAPSHOT.jar ./app.jar

# TODO: Add other runtime necessary files here

# Switch to a non-root user
RUN adduser -D foody
RUN chown -R foody:foody /app
USER foody

EXPOSE 5000
ENTRYPOINT [ "java", "-jar", "./app.jar" ]
