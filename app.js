const express = require("express");
const fileUpload = require("express-fileupload");
const app = express();
const fs = require("fs");
const PORT = 5000;

const Pool = require("pg").Pool;
const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "myfitnesspal",
    password: "admin",
    port: 5432,
});

app.use(fileUpload());
app.use(express.json());
app.use(
    express.urlencoded({
        extended: false,
    })
);

app.get("/", (req, res) =>
    res.sendFile(`${__dirname}/index.html`)
);

app.post("/", (req, res) => {
    if (!req.files || Object.keys(req.files).length === 0) {
        return res.status(400).send("No files were uploaded.");
    }
    file = req.files.csv;
    uploadPath = "/tmp/" + file.name;
    file.mv(uploadPath, function (err) {
        if (err) return res.status(500).send(err);
        else {
            pool.query("TRUNCATE meals;", (err) => {
                if (err) throw err;
                else {
                    pool.query(
                        `COPY meals FROM '${uploadPath}' CSV HEADER;`,
                        (error, results) => {
                            if (error) {
                                throw error;
                            } else {
                                let dashboard = JSON.parse(
                                    fs.readFileSync("dashid.json")
                                );
                                res.redirect(
                                    `http://localhost:3000/${dashboard.url}?orgId=1`
                                );
                            }
                        }
                    );
                }
            });
        }
    });
});

app.listen(PORT, () => console.log("listening on port 5000"));
