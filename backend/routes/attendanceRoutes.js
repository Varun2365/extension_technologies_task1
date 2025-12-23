const express = require('express');
const protect = require('../middleware/authMiddleware');
const {checkIn, checkOut, getAttendance} = require('../controllers/attendanceController')
const router = express.Router();

router.post('/check-in', protect , checkIn);
router.post('/check-out', protect , checkOut)
router.get('/', protect , getAttendance);

module.exports = router;
