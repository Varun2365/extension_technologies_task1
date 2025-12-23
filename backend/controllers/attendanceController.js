const mongoose = require('mongoose');
const Attendance = require('../models/attendance')


async function checkIn(req, res){
    try{

        const today = new Date();
        today.setHours(0,0,0,0);
    
        const attendance = await Attendance.findOne({employeeId : req.user.id, date : today});
        if(attendance) return res.status(400).json({error : "Already checked in for the day"});
        const newAttendance = new Attendance({
            employeeId : req.user.id,
            date : today,
            checkInTime : Date.now(),
        })
    
        await newAttendance.save();
        return res.status(201).json({
            message : "Checkin Successfull",
            checkInTime : newAttendance.checkInTime
        })
    }catch(e){
        return res.status(500).json({
            error : `Internal Server Error : ${e.message}`
        })
    }



}

async function checkOut(req, res){
    try{
        const today = new Date();
        today.setHours(0,0,0,0);

        const attendance = await Attendance.findOne({employeeId : req.user.id , date : today});
        if(!attendance) return res.status(400).json({error : "No Record Found"});
        if(attendance.checkOutTime) return res.status(400).json({error : "Already Checked Out"});

        attendance.checkOutTime = new Date();
        await attendance.save();
        return res.status(201).json({
            message : "Checkout successfull",
            checkOutTime : attendance.checkOutTime
        })

    }catch(e){
        return res.status(500).json({
            error : `Internal Server Error : ${e.message}`
        })
    }
}

async function getAttendance(req,res){
    const {from, to} = req.query;

    if(!from || !to){
        return res.status(400).json({
            error : "Provide From & To Date"
        })
    }

    const fromDate = new Date(from);
    const toDate = new Date(to);
    fromDate.setHours(0,0,0,0);
    toDate.setHours(23,59,59,999);

    var records = await Attendance.find({
        employeeId : req.user.id,
        date : {
            $gte : fromDate,
            $lte : toDate
        }
    }).sort({date : 1})
    return res.status(201).json({
        message : "Records fetched successfully",
        count : records.length,
        records,
    })

}

module.exports = {checkIn, checkOut, getAttendance};