const multer = require('multer');

// Store files in memory so we can stream them to Cloudinary
const storage = multer.memoryStorage();

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 100 * 1024 * 1024 // 100 MB max size for video/audio
    },
    fileFilter: (req, file, cb) => {
        // Accept images, audio, and video files
        if (file.mimetype.startsWith('image/') || 
            file.mimetype.startsWith('audio/') || 
            file.mimetype.startsWith('video/')) {
            cb(null, true);
        } else {
            cb(new Error('Invalid file type! Only image, audio, and video are allowed.'), false);
        }
    }
});

module.exports = upload;
