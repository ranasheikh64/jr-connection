const cloudinary = require('../config/cloudinary');

const uploadFile = async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ success: false, message: "No file uploaded" });
        }

        let resourceType = 'auto'; // Let Cloudinary auto-detect (image, video, raw)
        if (req.file.mimetype.startsWith('video/')) {
            resourceType = 'video';
        } else if (req.file.mimetype.startsWith('audio/')) {
            resourceType = 'video'; // Cloudinary treats audio files as video resource_type
        } else if (req.file.mimetype.startsWith('image/')) {
            resourceType = 'image';
        }

        // Upload stream to Cloudinary
        const uploadStream = cloudinary.uploader.upload_stream(
            {
                resource_type: resourceType,
                folder: 'webrtc_chat_media',
            },
            (error, result) => {
                if (error) {
                    console.error("Cloudinary Upload Error:", error);
                    return res.status(500).json({ success: false, message: "Failed to upload file to Cloudinary" });
                }

                // Successfully uploaded
                return res.status(200).json({
                    success: true,
                    message: "File uploaded successfully",
                    url: result.secure_url,
                    format: result.format,
                    resource_type: result.resource_type
                });
            }
        );

        // Pipe the buffer to the stream
        uploadStream.end(req.file.buffer);

    } catch (error) {
        console.error("Upload Controller Error:", error);
        res.status(500).json({ success: false, message: "Internal server error during upload" });
    }
};

module.exports = {
    uploadFile
};
