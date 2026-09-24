const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const { protect } = require('../middlewares/auth.middleware');

// Search users by username, email, or name
router.get('/search', protect, userController.search);

// Discover nearby friends with filters
router.get('/discover', protect, userController.discover);

// Update user profile
router.put('/profile', protect, userController.updateProfile);

module.exports = router;
