const express = require("express");
const port = 8080;
const HOST = '0.0.0.0';
const app = express();
const path = require("path");
const publicDir = path.join(__dirname, "public");

app.use(express.static(publicDir));

app.listen(port, HOST, () => {
    console.log(`Running on host ${HOST}, Listening on port ${port}`);
});