const mongoose = require('mongoose');


const attendanceSchema = mongoose.Schema({
    employeeId : {
        type : mongoose.Types.ObjectId,
        ref : 'User',
        required : true
    },
    date : {
        type : Date,
        required : true
    },
    checkInTime : {
        type : Date
    },
    checkOutTime : {
        type : Date
    },
    status : {
        type : String, 
        enum : ['present', 'absent', 'half-day'],
        default : 'present'
    }
})

module.exports = mongoose.model('Attendance', attendanceSchema);