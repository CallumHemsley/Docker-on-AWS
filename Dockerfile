FROM node:16

RUN mkdir /app
WORKDIR /app

COPY package.json package.json
RUN npm install && mv node_modules /node_modules

COPY . .

LABEL maintainer="Austin Loveless - Forked by Callum Hemsley"

EXPOSE 8080

CMD node app.js
