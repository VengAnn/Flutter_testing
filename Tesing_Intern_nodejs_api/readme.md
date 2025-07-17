```markdown
# My API Project

This project sets up a Node.js API using Express, CORS, dotenv, and mssql for connecting to a Microsoft SQL Server database.

## 📦 1. Create the Project Folder

Open your terminal and run:

```bash
mkdir my-api && cd my-api
```
- `mkdir my-api`: Creates a new folder for your project.
- `cd my-api`: Enters that folder.

## 📥 2. Initialize a Node.js Project

Run the following command to generate a `package.json` file:

```bash
npm init -y
```

## 📦 3. Install Required Dependencies

Install the necessary packages:

```bash
npm install express cors dotenv mssql
```
- **express**: Web framework to handle routes and requests.
- **cors**: Middleware to allow cross-origin requests (important for frontend-backend communication).
- **dotenv**: Loads environment variables from a `.env` file into `process.env`.
- **mssql**: Enables you to connect and run queries on a Microsoft SQL Server database.

## 🔄 4. (Optional but Recommended) Install Nodemon

For auto-restarting the server during development, run:

```bash
npm install -g nodemon
```

## 🛠️ 5. Create Server File

Create a file named `server.js` (or `index.js`) in the project root and add the following basic setup:

```javascript
const express = require('express');
const cors = require('cors');
require('dotenv').config();

// Import routes
const productRoutes = require('./routes/productRoutes');

const app = express();
const PORT = process.env.PORT || 3000;
const HOST = '192.168.1.14'; // Use local IP for LAN testing

// Middleware
app.use(cors());
app.use(express.json()); // To parse JSON request bodies

// API Routes
app.use('/api/products', productRoutes);

// Start server
app.listen(PORT, HOST, () => {
  console.log(`🚀 Server running at http://${HOST}:${PORT}`);
});
```

## 🧪 6. Run the Server

Start the server using:

```bash
nodemon server.js
```
Or, if you're not using nodemon:

```bash
node server.js
```

## 🔐 7. Add a .env File

Create a `.env` file in the root directory to store your configuration:

```
PORT=5000
DB_SERVER=localhost
DB_USER=sa
DB_PASSWORD=yourStrong(!)Password
DB_NAME=my_database
```

## 🔗 8. Connect to SQL Server

Create a helper file named `db.js` to configure the connection:

```javascript
const sql = require('mssql');
require('dotenv').config();

const config = {
  server: process.env.DB_SERVER,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

const pool = new sql.ConnectionPool(config);
const poolConnect = pool.connect();

module.exports = {
  sql,
  poolConnect,
  pool,
};
```

## 💡 Why Use These Packages?

- **Express**: Easy route and middleware management.
- **CORS**: Allows frontend apps (like Flutter, React) to call this backend.
- **dotenv**: Keeps sensitive config like DB passwords out of your code.
- **mssql**: Connects to Microsoft SQL Server (your database).
- **Nodemon**: Makes development faster by watching for changes.
```

This format is clean and organized, making it easy to follow for anyone setting up the project.