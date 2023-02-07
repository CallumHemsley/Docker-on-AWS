const express = require("express");
const port = 80;
const HOST = '0.0.0.0';
const app = express();
const path = require("path");
const publicDir = path.join(__dirname, "public");

app.use(express.static(publicDir));

app.get('/health', (_req, res) => res.send('Health check status: ok'))

app.listen(port, HOST, () => {
    console.log(`Running on host ${HOST}, Listening on port ${port}`);
});