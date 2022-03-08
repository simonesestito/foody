FROM node:17.5.0 AS build
WORKDIR /app
# It skips files ignored in .dockerignore
COPY ./ ./

RUN npm install && \
    npm run build -- --sourceMap false

# ----------------------------

FROM node:17.5.0-alpine3.15

LABEL name="Foody Project"
LABEL description="Final project for Databases course of Sapienza University of Rome, Spring 2022"
LABEL url="https://github.com/simonesestito/foody"
LABEL mantainer="simone@simonesestito.com"

ENV NODE_ENV production
ENV PORT 8080
WORKDIR /app

COPY --from=build /app/dist ./dist
COPY ./package.json ./
COPY ./package-lock.json ./
# TODO: Add other runtime necessary files here

RUN npm install --only=prod
EXPOSE 8080
ENTRYPOINT [ "node", "." ]
