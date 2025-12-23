const Attendance = require('../models/attendance');
const Leave = require('../models/leave');

const monthDays = {
    "Jan" : 31
}
async function generateCalendar(req,res){
    const {month} = req.body;

}