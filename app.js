const express = require("express");
const bodyParser = require("body-parser");
const sql = require("mssql");

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

// Database configuration
const dbConfig = {
    user: "sa",                       // Replace with your database username
    password: "YourStrongPassword123", // Replace with your database password
    server: "azureuser",               // Replace with your SQL Server name
    database: "TestDB",                // Replace with your SQL database name
    options: {
        encrypt: true,                 // For Azure SQL, use encrypt: true
        trustServerCertificate: true, // Trust the server's certificate (if self-signed)
    }
};

// SQL Server connection pool
async function connectToDb() {
    try {
        const pool = await sql.connect(dbConfig);
        return pool;
    } catch (err) {
        console.error("Database connection error:", err);
        throw err;
    }
}

// Handle form submission
app.post("/submit", async (req, res) => {
    const { name, email, contact } = req.body;

    try {
        const pool = await connectToDb();
        
        // Use parameterized query to avoid SQL injection
        const query = `INSERT INTO Users (Name, Email, Contact) VALUES (@name, @email, @contact)`;

        const request = pool.request();
        request.input('name', sql.NVarChar, name);
        request.input('email', sql.NVarChar, email);
        request.input('contact', sql.NVarChar, contact);
        
        // Execute query
        await request.query(query);

        res.send("Data saved successfully!");
    } catch (err) {
        console.error("Error inserting data:", err);
        res.status(500).send("Internal Server Error");
    }
});

// Serve the HTML form
app.get("/", (req, res) => {
    res.sendFile(__dirname + "/index.html");
});

// Start the server
app.listen(8080, "0.0.0.0", () => {
    console.log("Server is running on port 8080");
});
