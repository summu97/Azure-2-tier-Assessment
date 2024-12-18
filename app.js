const express = require("express");
const bodyParser = require("body-parser");
const sql = require("mssql");

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

const dbConfig = {
    user: "dbadmin",  					# Give your Database username
    password: "admin@4321",				# Give your Database password
    server: "adq-az-dbserver.database.windows.net",	# Give your SQL Server name
    database: "adz-az-sqldatabase",			# Give your SQL Database name
    options: {
        encrypt: true
    }
};

sql.connect(dbConfig).then(pool => {
    app.post("/submit", async (req, res) => {
        const { name, email, contact } = req.body;
        const query = `INSERT INTO Users (Name, Email, Contact) VALUES ('${name}', '${email}', '${contact}')`;
        await pool.request().query(query);
        res.send("Data saved successfully!");
    });
}).catch(err => {
    console.error("Database connection error:", err);
});

app.get("/", (req, res) => {
    res.sendFile(__dirname + "/index.html");
});

app.listen(8080, () => {				# Give the port on which you want your application to run
    console.log("Server is running on port 8080");	# Give the port on which you want your application to run
});
