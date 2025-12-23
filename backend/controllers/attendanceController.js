const mongoose = require('mongoose');
const Attendance = require('../models/attendance')
const { getISTTime, getISTToday } = require('../utils/timezone');


async function checkIn(req, res){
    try{

        const today = getISTToday();
        const checkInTime = getISTTime();
    
        const attendance = await Attendance.findOne({employeeId : req.user.id, date : today});
        if(attendance) return res.status(400).json({error : "Already checked in for the day"});
        const newAttendance = new Attendance({
            employeeId : req.user.id,
            date : today,
            checkInTime : checkInTime,
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
        const today = getISTToday();
        const checkOutTime = getISTTime();

        const attendance = await Attendance.findOne({employeeId : req.user.id , date : today});
        if(!attendance) return res.status(400).json({error : "No Record Found"});
        if(attendance.checkOutTime) return res.status(400).json({error : "Already Checked Out"});

        attendance.checkOutTime = checkOutTime;
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

    // Parse dates assuming they are in IST (YYYY-MM-DD format)
    // Create dates in IST timezone
    const [fromYear, fromMonth, fromDay] = from.split('-').map(Number);
    const [toYear, toMonth, toDay] = to.split('-').map(Number);
    
    // Create dates in IST (UTC+5:30)
    // We create UTC dates and then adjust for IST offset
    const fromDate = new Date(Date.UTC(fromYear, fromMonth - 1, fromDay, 0, 0, 0, 0));
    // Subtract 5 hours 30 minutes to get IST midnight in UTC
    fromDate.setUTCHours(fromDate.getUTCHours() - 5);
    fromDate.setUTCMinutes(fromDate.getUTCMinutes() - 30);
    
    const toDate = new Date(Date.UTC(toYear, toMonth - 1, toDay, 23, 59, 59, 999));
    // Subtract 5 hours 30 minutes to get IST end of day in UTC
    toDate.setUTCHours(toDate.getUTCHours() - 5);
    toDate.setUTCMinutes(toDate.getUTCMinutes() - 30);

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