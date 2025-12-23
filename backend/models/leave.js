const mongoose = require('mongoose');

const leaveSchema = mongoose.Schema({
    employeeId : {
        type : mongoose.Types.ObjectId,
        ref : 'User',
        required : true
    },
    fromDate : {
        type : Date,
        required : true
    },
    toDate : {
        type : Date , 
        required : true, 
    },
    appliedDate : {
        type : Date,
        default : Date.now()
    },
    reason : {
        type : String, 
        required : true,
    },
    type : {
        type : String, 
        enum : ['sick','casual','other'],
        required : true,
    },
    status : {
        type : String, 
        enum : ['approved','rejected','pending'],
        default : 'pending'
    }
})

module.exports = mongoose.model('Leave', leaveSchema);