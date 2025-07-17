const express = require('express');
const cors = require('cors');
require('dotenv').config();

// Routes
const productRoutes = require('./routes/productRoutes');

const app = express();
const PORT = process.env.PORT || 3000;
// Use 'localhost' if you don't need IP
const HOST = '192.168.1.17';

// Cross Origin Resource Sharing
app.use(cors());
// Parse JSON incoming request bodies
app.use(express.json());

// Route registration
app.use('/api/products', productRoutes);

// Start server
app.listen(PORT, HOST, () => {
    console.log(`🚀 Server running at http://${HOST}:${PORT}`);
});
