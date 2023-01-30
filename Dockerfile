FROM --platform=linux/amd64 node:11.15

RUN mkdir /app
WORKDIR /app

COPY package.json package.json
RUN npm install && mv node_modules /node_modules

COPY . .

LABEL maintainer="Austin Loveless - Forked by Callum Hemsley"

EXPOSE 80

CMD node app.js
