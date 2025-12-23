const Leave = require('../models/leave');

async function applyLeave(req,res){
    try{

        const {fromDate, toDate, reason, type } = req.body;
        if (!fromDate || !toDate || !reason|| !type) return res.status(400).json({
            error : "Please fill all fields"
        })
    
        fromD = new Date(fromDate);
        toD = new Date(toDate);
        fromD.setHours(0,0,0,0);
        toD.setHours(23,59,59,999);
    
        if(fromD > toD) return res.status(400).json({error : "Please select valid date range"});
        const overlappingLeave = await Leave.findOne({
            employeeId: req.user.id,
            status: { $in: ['approved', 'pending'] },
            fromDate: { $lte: toD },
            toDate: { $gte: fromD }
          });
          
          if (overlappingLeave) {
            return res.status(400).json({ error: "Leave overlaps with existing leave" });
          }
        
          const newLeave = new Leave({
            employeeId : req.user.id,
            fromDate : fromD,
            toDate : toD,
            reason : reason,
            type : type
          })
          await newLeave.save();
          return res.status(201).json({
            message : "Leave applied successfully, wait till 1 minute for response",
            leave : newLeave
          })
    }catch(e){
        return res.status(500).json({
            error : `Internal Server Error : ${e.message}`
        })
    }
}

async function getLeaveList(req,res){
    try{
        console.log(req.user.id)
        const leaves = await Leave.find({employeeId : req.user.id}).select('-_id -__v').sort({appliedAt : -1});
        return res.status(201).json({
            message : "Leaves retrived",
            count : leaves.length,
            leaves
        })
    }catch(e){
        res.status(500).json({
            error : `Internal Server Error : ${e.message}`
        })
    }

}

module.exports = {applyLeave, getLeaveList};