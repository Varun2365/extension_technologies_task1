const mongoose = require('mongoose');
const express = require('express');
async function connectDB() {
    try {
        await mongoose.connect(process.env.MONGO_URL);
        console.log(`\n\n\n\nDatabase Connected Successfully!`)
    } catch (e) {
        console.log(`Error Connecting Database : ${e.message}`)
    }

}

async function startServer(app, PORT){
    await connectDB();

    app.listen(PORT, ()=>{
        console.log(`Listening on Port : ${PORT}`);
    })
}

module.exports = startServer;