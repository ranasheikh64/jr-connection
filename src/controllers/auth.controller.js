const authService = require('../services/auth.service');

const register = async (req, res) => {
    try {
        const { name, username, email, password, gender, age, passion, location } = req.body;
        const user = await authService.registerUser(name, username, email, password, gender, age, passion, location);
        
        res.status(201).json({
            success: true,
            message: 'User registered successfully. You can now log in.',
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};

const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const data = await authService.loginUser(email, password);
        
        res.status(200).json({
            success: true,
            message: 'Login successful.',
            data
        });
    } catch (error) {
        res.status(401).json({
            success: false,
            message: error.message
        });
    }
};

const forgotPassword = async (req, res) => {
    try {
        const { email } = req.body;
        await authService.processForgotPassword(email);
        
        res.status(200).json({
            success: true,
            message: 'An OTP has been sent to your email address.'
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};

const verifyOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;
        await authService.processVerifyOtp(email, otp);
        
        res.status(200).json({
            success: true,
            message: 'OTP verified successfully. You can now reset your password.'
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};

const resetPassword = async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;
        await authService.processResetPassword(email, otp, newPassword);
        
        res.status(200).json({
            success: true,
            message: 'Password reset successful. You can now log in with your new password.'
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};

module.exports = {
    register,
    login,
    forgotPassword,
    verifyOtp,
    resetPassword
};
