const jwt = require('jsonwebtoken');

const protect = (req, res, next) => {
    let token;
    
    // Check for Bearer token or direct token in headers
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        token = req.headers.authorization.split(' ')[1];
    } else if (req.headers.token) {
        token = req.headers.token;
    }

    if (!token) {
        return res.status(401).json({ success: false, message: "Not authorized, no token" });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded.user;
        next();
    } catch (error) {
        return res.status(401).json({ success: false, message: "Not authorized, token failed" });
    }
};

module.exports = { protect };
