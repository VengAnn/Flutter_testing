// Import the mssql library to connect to SQL Server
const sql = require('mssql');

// Load environment variables from .env file
require('dotenv').config();

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT),
    options: {
        encrypt: false,
        trustServerCertificate: true,
    },
};

// Async function to create and return a connection pool
async function getPool() {
    return await sql.connect(config);
}

module.exports = { sql, getPool };
