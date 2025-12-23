const cron = require('node-cron');
const Leave = require('../models/leave');

cron.schedule('* * * * *', async () => {
  try {
    console.log('Running leave status updater cron job...');

    const pendingLeaves = await Leave.find({ status: 'pending' });

    for (let leave of pendingLeaves) {
      leave.status = Math.random() < 0.5 ? 'approved' : 'rejected';
      await leave.save();
      console.log(`Leave ${leave._id} status updated to ${leave.status}`);
    }

  } catch (error) {
    console.error('Error in cron job:', error.message);
  }
});
