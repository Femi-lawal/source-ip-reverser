const express = require("express");
const { Pool, Client } = require("pg");
const os = require("os");

require("dotenv").config();

const app = express();
const port = process.env.PORT || 3000;

// Database setup parameters
const dbParams = {
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: "postgres", // default database to connect to before creating your own
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT || 5432,
};
const dbName = process.env.PGDATABASE || "ip_reverse";
const tableName = "ip_addresses";

// Function to connect to the default database and create a new database if it doesn't exist
async function setupDatabase() {
  const client = new Client(dbParams);
  await client.connect();

  // Try to create the database if it doesn't exist
  await client
    .query(`CREATE DATABASE "${dbName}"`)
    .catch(() => console.log(`Database ${dbName} already exists.`));

  await client.end();

  // Connect to the new database to create tables
  const pool = new Pool({ ...dbParams, database: dbName });
  // Delete Table if it exists
  await pool
    .query(`DROP TABLE IF EXISTS ${tableName}`)
    .then(() => console.log(`Table ${tableName} dropped.`))
    .catch((err) => console.error(err));

  await pool
    .query(
      `CREATE TABLE IF NOT EXISTS ${tableName} (
    id SERIAL PRIMARY KEY,
    ip VARCHAR(225) NOT NULL,
    reversed_ip VARCHAR(225) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
  )`
    )
    .then(() => console.log(`Table ${tableName} is ready.`))
    .catch((err) => console.error(err));

  return pool; // Return the pool for further use
}

function getServerIp() {
  const interfaces = os.networkInterfaces();
  for (const iface of Object.values(interfaces)) {
    for (const alias of iface) {
      if (alias.family === "IPv4" && !alias.internal) {
        return alias.address;
      }
    }
  }
  return "localhost";
}

async function main() {
  const pool = await setupDatabase();

  app.get("/", async (req, res) => {
    const ip = req.headers["x-forwarded-for"] || req.socket.remoteAddress;
    const reversedIp = ip.split(".").reverse().join(".");

    try {
      await pool.query(
        "INSERT INTO ip_addresses(ip, reversed_ip) VALUES($1, $2)",
        [ip, reversedIp]
      );
      res.send(`Original IP: ${ip} - Reversed IP: ${reversedIp}`);
    } catch (error) {
      console.error("Error saving IP to database:", error);
      res.status(500).send("An error occurred");
    }
  });

  const serverIp = getServerIp();

  app.listen(port, () => {
    console.log(`Reverse IP app listening at http://${serverIp}:${port}`);
  });
}

main().catch((err) => console.error("Failed to start the server:", err));
