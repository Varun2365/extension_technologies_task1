const express = require('express');
const router = express.Router();
const {applyLeave, getLeaveList} = require('../controllers/leaveController')
const protect = require('../middleware/authMiddleware');

router.post('/apply',protect,applyLeave);
router.get('/list',protect,getLeaveList);


module.exports = router;