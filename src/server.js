require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');
const uploadRoutes = require('./routes/upload.routes');
const userRoutes = require('./routes/user.routes');

const http = require('http');

const app = express();
const server = http.createServer(app);

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/users', userRoutes);
app.get("/", (req, res) => {
    res.send("Backend server is running");
})

// Database connection
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log('Connected to MongoDB successfully.'))
    .catch((err) => console.error('MongoDB connection error:', err));

// Initialize WebSockets
const initSockets = require('./sockets/index');
initSockets(server);

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
