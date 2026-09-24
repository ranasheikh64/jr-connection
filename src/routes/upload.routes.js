const express = require('express');
const router = express.Router();
const uploadMiddleware = require('../middlewares/upload.middleware');
const uploadController = require('../controllers/upload.controller');
const { protect } = require('../middlewares/auth.middleware');

// Route to upload a file (requires authentication)
// 'file' is the field name expected in the form-data
router.post('/', protect, uploadMiddleware.single('file'), uploadController.uploadFile);

module.exports = router;
