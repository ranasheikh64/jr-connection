const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
    isGroupChat: { type: Boolean, default: false },
    chatName: { type: String, trim: true },
    users: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    admin: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    chatPassword: { type: String, default: null }, // Hashed password for locked chats
    disappearingTimer: { type: Number, default: 0 }, // In seconds, 0 means disabled
    latestMessage: { type: mongoose.Schema.Types.ObjectId, ref: 'Message' },
    pinnedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    favouritedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    archivedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    deletedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }], // Users who deleted the chat
    clearedHistory: [
        {
            user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
            timestamp: { type: Date }
        }
    ],
    pinnedMessages: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Message' }],
    mutedBy: [
        {
            user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
            mutedUntil: { type: Date } // Date until the chat is muted. If very far in future, it means 'Always'
        }
    ]
}, { timestamps: true });

module.exports = mongoose.model('Chat', chatSchema);
