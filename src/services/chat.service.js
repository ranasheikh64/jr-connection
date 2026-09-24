const Chat = require('../models/chat.model');
const Block = require('../models/block.model');
const bcrypt = require('bcryptjs');

const getOrCreateDirectChat = async (userId, otherUserId) => {
    let chat = await Chat.findOne({
        isGroupChat: false,
        $and: [
            { users: { $elemMatch: { $eq: userId } } },
            { users: { $elemMatch: { $eq: otherUserId } } }
        ]
    }).populate('users', '-password');

    if (chat) return chat;

    const newChat = new Chat({
        isGroupChat: false,
        users: [userId, otherUserId]
    });
    await newChat.save();
    return await Chat.findById(newChat._id).populate('users', '-password');
};

const createGroupChat = async (adminId, users, chatName) => {
    if (users.length < 2) {
        throw new Error("More than 2 users are required to form a group chat");
    }
    users.push(adminId); // Add admin

    const groupChat = new Chat({
        isGroupChat: true,
        chatName,
        users,
        admin: adminId
    });
    
    await groupChat.save();
    return await Chat.findById(groupChat._id).populate('users', '-password');
};

const blockUser = async (blockerId, blockedId) => {
    const existing = await Block.findOne({ blocker: blockerId, blocked: blockedId });
    if (existing) return existing;

    const block = new Block({ blocker: blockerId, blocked: blockedId });
    await block.save();
    return block;
};

const unblockUser = async (blockerId, blockedId) => {
    await Block.findOneAndDelete({ blocker: blockerId, blocked: blockedId });
    return true;
};

const isBlocked = async (userId1, userId2) => {
    const block = await Block.findOne({
        $or: [
            { blocker: userId1, blocked: userId2 },
            { blocker: userId2, blocked: userId1 }
        ]
    });
    return !!block;
};

const setChatLock = async (chatId, adminId, password) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");
    
    if (chat.isGroupChat && chat.admin.toString() !== adminId.toString()) {
        throw new Error("Only admin can lock the group chat");
    }

    const salt = await bcrypt.genSalt(10);
    chat.chatPassword = await bcrypt.hash(password, salt);
    await chat.save();
    return chat;
};

const verifyChatLock = async (chatId, password) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");
    if (!chat.chatPassword) return true; // not locked

    return await bcrypt.compare(password, chat.chatPassword);
};

const setDisappearingTimer = async (chatId, seconds) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");
    
    chat.disappearingTimer = seconds;
    await chat.save();
    return chat;
};

const fetchUserChats = async (userId) => {
    return await Chat.find({
        users: { $elemMatch: { $eq: userId } },
        deletedBy: { $ne: userId } // Do not fetch chats deleted by this user
    })
        .populate('users', '-password')
        .populate('admin', '-password')
        .populate({
            path: 'latestMessage',
            populate: { path: 'sender', select: 'name username email' }
        })
        .sort({ updatedAt: -1 });
};

const muteChat = async (chatId, userId, durationInHours) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");

    const muteUntil = durationInHours 
        ? new Date(Date.now() + durationInHours * 60 * 60 * 1000) 
        : new Date(2100, 1, 1); // practically 'Always'

    // Remove existing mute entry if any
    chat.mutedBy = chat.mutedBy.filter(m => m.user.toString() !== userId.toString());
    
    // Add new mute entry
    chat.mutedBy.push({ user: userId, mutedUntil: muteUntil });
    await chat.save();
    return chat;
};

const unmuteChat = async (chatId, userId) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");

    chat.mutedBy = chat.mutedBy.filter(m => m.user.toString() !== userId.toString());
    await chat.save();
    return chat;
};

const toggleChatAction = async (chatId, userId, action) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");

    let arrayToUpdate;
    if (action === 'pin') arrayToUpdate = chat.pinnedBy;
    else if (action === 'favourite') arrayToUpdate = chat.favouritedBy;
    else if (action === 'archive') arrayToUpdate = chat.archivedBy;
    else throw new Error("Invalid action. Must be 'pin', 'favourite', or 'archive'");

    const index = arrayToUpdate.findIndex(id => id.toString() === userId.toString());
    if (index > -1) {
        // Toggle off
        arrayToUpdate.splice(index, 1);
    } else {
        // Toggle on
        arrayToUpdate.push(userId);
    }

    await chat.save();
    return chat;
};

const deleteChatForUser = async (chatId, userId) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");

    if (!chat.deletedBy.includes(userId)) {
        chat.deletedBy.push(userId);
    }
    
    // Also clear history
    const historyIndex = chat.clearedHistory.findIndex(ch => ch.user.toString() === userId.toString());
    if (historyIndex > -1) {
        chat.clearedHistory[historyIndex].timestamp = new Date();
    } else {
        chat.clearedHistory.push({ user: userId, timestamp: new Date() });
    }

    await chat.save();
    return chat;
};

const clearChatHistoryForUser = async (chatId, userId) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");

    const historyIndex = chat.clearedHistory.findIndex(ch => ch.user.toString() === userId.toString());
    if (historyIndex > -1) {
        chat.clearedHistory[historyIndex].timestamp = new Date();
    } else {
        chat.clearedHistory.push({ user: userId, timestamp: new Date() });
    }

    await chat.save();
    return chat;
};

const togglePinMessage = async (chatId, messageId, userId) => {
    const chat = await Chat.findById(chatId);
    if (!chat) throw new Error("Chat not found");

    const index = chat.pinnedMessages.findIndex(id => id.toString() === messageId.toString());
    if (index > -1) {
        chat.pinnedMessages.splice(index, 1); // Unpin
    } else {
        chat.pinnedMessages.push(messageId); // Pin
    }
    
    await chat.save();
    return chat;
};

module.exports = {
    getOrCreateDirectChat,
    createGroupChat,
    blockUser,
    unblockUser,
    isBlocked,
    setChatLock,
    verifyChatLock,
    setDisappearingTimer,
    fetchUserChats,
    muteChat,
    unmuteChat,
    toggleChatAction,
    deleteChatForUser,
    clearChatHistoryForUser,
    togglePinMessage
};
