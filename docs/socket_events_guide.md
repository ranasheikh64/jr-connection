# Socket.IO Connection & Events Guide

This document provides complete instructions on how to connect to the Socket.IO server, how to test all events using Postman, and how to integrate them into your Flutter application.

---

## 1. How to Connect

### 🔗 Connecting in Postman
1. Open Postman, click **New > WebSocket**.
2. Change the protocol to **Socket.IO**.
3. Enter URL: `ws://localhost:5000`
4. Go to the **Headers** tab and add:
   - Key: `token`
   - Value: `YOUR_JWT_TOKEN_HERE` (Get this from the Login API)
5. Click **Connect**.

### 📱 Connecting in Flutter
Use the `socket_io_client` package.
```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket socket = IO.io('http://localhost:5000', <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false,
  'auth': {
    'token': 'YOUR_JWT_TOKEN_HERE'
  }
});

socket.connect();
socket.onConnect((_) {
  print('Connected to Socket.io server');
});
```

---

## 2. Emitting Events (Client -> Server)

In Postman, go to the **Message** tab, put the event name in the **Event name** field, select **JSON** as the format, put the payload in the text box, check **Ack** (to see the response), and click **Send**.

### 1. `access_chat` (Create or get a 1-on-1 chat)
- **Postman Event Name:** `access_chat`
- **JSON Body:**
```json
{
  "userId": "6ab4921..." // ID of the person you want to chat with
}
```

### 2. `fetch_chats` (Get all your chats)
- **Postman Event Name:** `fetch_chats`
- **JSON Body:**
```json
{}
```

### 3. `join_chat` (Open a chat screen)
- **Postman Event Name:** `join_chat`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f..."
}
```
*Note: In Flutter, do this when the user navigates to the Chat Screen.*

### 4. `send_message` (Send a message)
- **Postman Event Name:** `send_message`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "content": "Hello World!", // In Flutter, encrypt this string before sending
  "replyTo": "6ab..." // Optional: ID of the message you are replying to
}
```
*Note: The server will respond with the saved message and emit `new_message` to everyone in the room.*

### 5. `fetch_messages` (Get previous messages with pagination/lock)
- **Postman Event Name:** `fetch_messages`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "page": 1,
  "limit": 20,
  "password": "optional_password" // Only if the chat is locked
}
```

### 6. `mark_as_read` (Mark a message as seen)
- **Postman Event Name:** `mark_as_read`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "messageId": "6ab..."
}
```

### 7. `create_group` (Create a group chat)
- **Postman Event Name:** `create_group`
- **JSON Body:**
```json
{
  "chatName": "My Awesome Group",
  "users": ["friend_id_1", "friend_id_2"]
}
```

### 8. `block_user` / `unblock_user` (Block someone)
- **Postman Event Name:** `block_user` (or `unblock_user`)
- **JSON Body:**
```json
{
  "blockedId": "user_id_to_block"
}
```

### 9. `lock_chat` (Set a password for a chat)
- **Postman Event Name:** `lock_chat`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "password": "secretpassword"
}
```

### 10. `set_temporary_timer` (Enable disappearing messages)
- **Postman Event Name:** `set_temporary_timer`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "seconds": 3600 
}
```

### 11. `mute_chat` (Mute a chat for a specific time)
- **Postman Event Name:** `mute_chat`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "durationInHours": 8 // Optional. If omitted, it mutes indefinitely.
}
```

### 12. `unmute_chat` (Unmute a chat)
- **Postman Event Name:** `unmute_chat`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f..."
}
```

### 13. `react_to_message` (React to a message with Emoji)
- **Postman Event Name:** `react_to_message`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "messageId": "6ab...",
  "emoji": "❤️" // Can be any emoji string. Send same emoji again to remove reaction.
}
```

### 14. `toggle_chat_action` (Pin, Favourite, or Archive a chat)
- **Postman Event Name:** `toggle_chat_action`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "action": "pin" // Can be "pin", "favourite", or "archive"
}
```
*Note: Sending the same action twice will toggle it off (e.g. unpin).*

### 15. `delete_chat` (Delete a chat from your list)
- **Postman Event Name:** `delete_chat`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f..."
}
```

### 16. `clear_history` (Clear messages for yourself)
- **Postman Event Name:** `clear_history`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f..."
}
```

### 17. `toggle_pin_message` (Pin/Unpin a message)
- **Postman Event Name:** `toggle_pin_message`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "messageId": "6ab..."
}
```

### 18. `delete_message` (Delete a single message)
- **Postman Event Name:** `delete_message`
- **JSON Body:**
```json
{
  "chatId": "6ab4956f...",
  "messageId": "6ab...",
  "forEveryone": true // true = Delete for Everyone, false = Delete for Me
}
```

---

## 3. Listening to Events (Server -> Client)

In Postman, go to the **Events** tab, type the event name, and turn on the toggle to listen. In Flutter, use `socket.on('event_name', callback)`.

### 1. `new_message`
Triggered when someone sends a message in a chat you currently have OPEN (`join_chat`).
```dart
socket.on('new_message', (data) {
  // data is the Message object
  // Update your Chat UI list
  print(data['content']); 
});
```

### 2. `new_message_notification`
Triggered when someone sends a message in a chat you are part of, but you DO NOT have the chat open.
```dart
socket.on('new_message_notification', (data) {
  // Show a push notification or update the unread count in Home Screen
});
```

### 3. `message_seen`
Triggered when someone reads your message.
```dart
socket.on('message_seen', (data) {
  // Update UI to show the double blue tick ✔✔
});
```

### 4. `new_chat_created`
Triggered when someone adds you to a new group chat.
```dart
socket.on('new_chat_created', (data) {
  // Add the new group to your chats list
});
```

### 5. `timer_updated`
Triggered when the temporary message timer is changed.
```dart
socket.on('timer_updated', (data) {
  // Show a UI alert that disappearing messages are turned on
});
```
### 6. `message_reacted`
Triggered when someone reacts to a message in an open chat.
```dart
socket.on('message_reacted', (data) {
  // Update the specific message's reactions array in UI
});
```
### 7. `pinned_messages_updated`
Triggered when someone pins or unpins a message in the chat.
```dart
socket.on('pinned_messages_updated', (data) {
  // data is an array of pinned message IDs
});
```
### 8. `message_deleted_for_everyone`
Triggered when someone deletes their message for everyone in the chat.
```dart
socket.on('message_deleted_for_everyone', (data) {
  // data contains { messageId, chatId }
  // Find this message in the UI and update its content to "This message was deleted"
});
```
