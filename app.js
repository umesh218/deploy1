const express = require('express');
const path = require('path');

const app = express();
const PORT = 8082; // Ensure this matches your port mapping

// Serve static files (like index.html)
app.use(express.static(path.join(__dirname)));

// Default route to serve index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
