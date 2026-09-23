# WebRTC Signaling Server Implementation Plan

এই ডকুমেন্টে আমরা আলোচনা করবো কীভাবে Node.js, Express.js এবং Socket.io ব্যবহার করে WebRTC এর জন্য একটি সিগনালিং সার্ভার তৈরি করা যায়।

## ১. সিগনালিং সার্ভার কী এবং কেন লাগে?
WebRTC সরাসরি পিয়ার-টু-পিয়ার (P2P) কাজ করলেও, দুটি ডিভাইস একে অপরকে চেনার জন্য প্রাথমিক কিছু ডেটা (যেমন: আইপি অ্যাড্রেস, পোর্ট, মিডিয়া ফরম্যাট) আদান-প্রদান করতে হয়। এই ডেটা আদান-প্রদানের মাধ্যম হিসেবে কাজ করে সিগনালিং সার্ভার। 

## ২. কী কী প্রযুক্তি ও প্যাকেজ লাগবে?
সার্ভারটি তৈরি করতে নিচের টুলসগুলো প্রয়োজন:
*   **Node.js**: জাভাস্ক্রিপ্ট রানটাইম এনভায়রনমেন্ট।
*   **Express.js**: ওয়েব ফ্রেমওয়ার্ক, যা দিয়ে সার্ভার তৈরি করা সহজ হয়।
*   **Socket.io**: রিয়েল-টাইম বাই-ডিরেকশনাল কমিউনিকেশনের জন্য (ওয়েব-সকেট)। এটি ক্লায়েন্ট এবং সার্ভারের মধ্যে সবসময় কানেকশন ধরে রাখে।
*   **CORS**: বিভিন্ন ডোমেইন বা পোর্ট থেকে সার্ভারে রিকোয়েস্ট এক্সেস দেওয়ার জন্য।

## ৩. কী কী ক্রেডেনশিয়াল (Credentials) লাগবে?
সিগনালিং সার্ভারের নিজের কোনো ক্রেডেনশিয়াল লাগে না, তবে WebRTC কানেকশন ইন্টারনেটে কাজ করানোর জন্য STUN এবং TURN সার্ভারের ক্রেডেনশিয়াল লাগে। ক্লায়েন্ট (Flutter App) যখন কানেকশন তৈরি করবে, তখন তাকে এই ক্রেডেনশিয়ালগুলো দিতে হবে।

*   **STUN Server:** এটি ফ্রি। যেমন: `stun:stun.l.google.com:19302` (গুগলের ফ্রি STUN সার্ভার, কোনো পাসওয়ার্ড লাগে না)।
*   **TURN Server:** এটি সাধারণত পেইড বা নিজের হোস্টিং এ সেটআপ করতে হয় (যেমন: Twilio, Metered TURN বা নিজের Coturn সার্ভার)। এর জন্য লাগবে:
    *   **URL:** `turn:your-turn-server.com:3478`
    *   **Username:** `your_username`
    *   **Credential (Password):** `your_password`

*(নোট: আমরা প্রথমে লোকাল নেটওয়ার্কে টেস্ট করার জন্য শুধুমাত্র ফ্রি STUN সার্ভার দিয়েই কাজ চালাতে পারবো।)*

## ৪. সার্ভার ইমপ্লিমেন্টেশন স্টেপ-বাই-স্টেপ

### স্টেপ ৪.১: প্রজেক্ট ইনিশিয়ালাইজ করা
প্রথমে একটি ফোল্ডার তৈরি করে সেখানে Node.js প্রজেক্ট শুরু করতে হবে এবং প্রয়োজনীয় প্যাকেজ ইনস্টল করতে হবে।
```bash
mkdir webrtc-server
cd webrtc-server
npm init -y
npm install express socket.io cors
```

### স্টেপ ৪.২: বেসিক সার্ভার সেটআপ (index.js)
একটি `index.js` ফাইল তৈরি করে সেখানে Express এবং Socket.io এর বেসিক সেটআপ করতে হবে।

```javascript
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: "*", // সব ক্লায়েন্টকে এক্সেস দেওয়া
        methods: ["GET", "POST"]
    }
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
    console.log(`Signaling Server is running on port ${PORT}`);
});
```

### স্টেপ ৪.৩: Socket.io ইভেন্টগুলো হ্যান্ডেল করা
WebRTC এর জন্য মূলত ৪টি ইভেন্ট আদান-প্রদান করতে হয়:
১. **Join Room:** কল করার জন্য ইউজারদের একটি নির্দিষ্ট রুমে জয়েন করা।
২. **Offer:** কলার যখন কল করবে, তখন তার SDP Offer পাঠানো।
৩. **Answer:** রিসিভার যখন কল ধরবে, তখন তার SDP Answer পাঠানো।
৪. **ICE Candidate:** কানেকশন তৈরি করার জন্য নেটওয়ার্ক রুট পাঠানো।

`index.js` ফাইলে `io.on('connection')` এর ভেতর নিচের কোডগুলো যুক্ত করতে হবে:

```javascript
io.on('connection', (socket) => {
    console.log(`User Connected: ${socket.id}`);

    // ১. রুমে জয়েন করা
    socket.on("join_room", (roomID) => {
        socket.join(roomID);
        console.log(`User ${socket.id} joined room ${roomID}`);
        // রুমে অন্য কেউ থাকলে তাকে জানানো যে নতুন কেউ এসেছে
        socket.to(roomID).emit("user_joined", socket.id);
    });

    // ২. Offer পাঠানো
    socket.on("offer", (data) => {
        // data এর মধ্যে থাকবে roomID এবং offer
        socket.to(data.roomID).emit("receive_offer", {
            offer: data.offer,
            callerID: socket.id
        });
    });

    // ৩. Answer পাঠানো
    socket.on("answer", (data) => {
        // data এর মধ্যে থাকবে roomID এবং answer
        socket.to(data.roomID).emit("receive_answer", {
            answer: data.answer,
            receiverID: socket.id
        });
    });

    // ৪. ICE Candidate পাঠানো
    socket.on("ice_candidate", (data) => {
        socket.to(data.roomID).emit("receive_ice_candidate", {
            candidate: data.candidate,
            senderID: socket.id
        });
    });

    // ৫. ডিসকানেক্ট হ্যান্ডেল করা
    socket.on("disconnect", () => {
        console.log(`User Disconnected: ${socket.id}`);
        // এখানে চাইলে রুমের অন্যদের জানানো যায় যে ইউজার চলে গেছে
    });
});
```

## ৫. পরবর্তী করণীয় (Next Steps)
এই সার্ভারটি তৈরি হয়ে গেলে আমরা লোকাল মেশিনে (`localhost:3000`) রান করবো। এরপর Flutter অ্যাপ থেকে Socket.io ক্লায়েন্ট ব্যবহার করে এই সার্ভারের সাথে কানেক্ট করবো এবং এই ইভেন্টগুলো (`offer`, `answer`, `ice_candidate`) আদান-প্রদান করে ভিডিও কল এস্টাবলিশ করবো।
