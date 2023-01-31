const express = require("express");
const { Client } = require('pg')
const path = require("path");

const port = 80;
const HOST = '0.0.0.0';
const app = express();
const publicDir = path.join(__dirname, "public");
const client = new Client()


app.use(express.static(publicDir));

app.listen(port, HOST, () => {
  //TODO, get this working locally, then dockerize, then rdS???
  console.log(`Running on host ${HOST}, Listening on port ${port}`);
  client.connect().then(() => {
    console.log("connected to db.")
    client.query('SELECT * FROM users').then((users) => console.log({users}))
  }).catch((err) => console.log({err}));
});