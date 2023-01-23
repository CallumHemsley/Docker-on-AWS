const express = require("express");
const port = 8080;
const app = express();
const path = require("path");
const publicDir = path.join(__dirname, "public");

app.use(express.static(publicDir));

app.listen(port, () => {
    console.log(`Listening on port ${port}`);
});

//Next steps:
//Get docker onto ecs cluster somehow (maybe add outputs to terraform so we can manually pushed the file from docker?)
//Workout how to add RDS (it will probably also need docker-compose??)