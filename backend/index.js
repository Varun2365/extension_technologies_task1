require('dotenv').config();
require('./cron/leaveCron')
const express = require('express');
const app = express();
const startServer = require('./config/mongodb')
const PORT = process.env.PORT;



// Importing Route files
const authRoutes = require('./routes/authRoutes');
const attendanceRoutes = require('./routes/attendanceRoutes');
const leaveRoutes = require('./routes/leaveRoutes');

app.use(express.json());
app.get('/', (req,res)=>{
    res.send("Home Page")
})
app.use('/api/auth',authRoutes);
app.use('/api/attendance', attendanceRoutes);
app.use('/api/leave', leaveRoutes);

startServer(app, PORT);