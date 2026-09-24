const { body, validationResult } = require('express-validator');

// Middleware to handle validation errors and format them nicely for the user
const validateRequest = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        // Return the first error message to keep it simple and user-friendly
        return res.status(400).json({
            success: false,
            message: errors.array()[0].msg
        });
    }
    next();
};

const registerValidator = [
    body('name')
        .notEmpty().withMessage('Name is required.')
        .isLength({ min: 3 }).withMessage('Name must be at least 3 characters long.'),
    body('username')
        .notEmpty().withMessage('Username is required.')
        .isAlphanumeric().withMessage('Username must contain only letters and numbers.')
        .isLength({ min: 3 }).withMessage('Username must be at least 3 characters long.'),
    body('email')
        .notEmpty().withMessage('Email is required.')
        .isEmail().withMessage('Please provide a valid email address.'),
    body('password')
        .notEmpty().withMessage('Password is required.')
        .isLength({ min: 6 }).withMessage('Password must be at least 6 characters long.'),
    validateRequest
];

const loginValidator = [
    body('email')
        .notEmpty().withMessage('Email is required.')
        .isEmail().withMessage('Please provide a valid email address.'),
    body('password')
        .notEmpty().withMessage('Password is required.'),
    validateRequest
];

const forgotPasswordValidator = [
    body('email')
        .notEmpty().withMessage('Email is required.')
        .isEmail().withMessage('Please provide a valid email address.'),
    validateRequest
];

const verifyOtpValidator = [
    body('email')
        .notEmpty().withMessage('Email is required.')
        .isEmail().withMessage('Please provide a valid email address.'),
    body('otp')
        .notEmpty().withMessage('OTP is required.')
        .isLength({ min: 6, max: 6 }).withMessage('OTP must be exactly 6 digits.'),
    validateRequest
];

const resetPasswordValidator = [
    body('email')
        .notEmpty().withMessage('Email is required.')
        .isEmail().withMessage('Please provide a valid email address.'),
    body('otp')
        .notEmpty().withMessage('OTP is required.'),
    body('newPassword')
        .notEmpty().withMessage('New password is required.')
        .isLength({ min: 6 }).withMessage('New password must be at least 6 characters long.'),
    validateRequest
];

module.exports = {
    registerValidator,
    loginValidator,
    forgotPasswordValidator,
    verifyOtpValidator,
    resetPasswordValidator
};
