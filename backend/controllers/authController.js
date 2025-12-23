const User = require('../models/user');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

async function signup(req, res) {
  try {
    const { name, email, password, employeeId } = req.body;
    if (!name || !email || !password || !employeeId) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const existingUser = await User.findOne({email});
    if(existingUser){
        return res.status(400).json({ error : "User Email already exists"})
    }

    const user = new User({name, email, password, employeeId});
    await user.save();

    const token = jwt.sign({id: user._id}, process.env.JWT_SECRET, {expiresIn : process.env.JWT_EXPIRY});

    res.status(201).json({
        message : "Employee Created Successfully",
        user : {
            name : user.name,
            email : user.email, 
            employeeId : user.employeeId
        },
        token : token
    })

  } catch (e) {
    res.status(500).json({ error: `Internal server error ${e.message}` });
  }
}

async function login(req, res){
  try{

    const {email, password} = req.body;
    if(!email || !password) return res.status(400).json({error : "All Fields Are Required"});

    const fetchedUser = await User.findOne({email});
    if(!fetchedUser) return res.status(400).json({error : "User Not Found"});

    var isMatch = await bcrypt.compare(password, fetchedUser.password);
    if(!isMatch) return res.status(400).json({error : "Password Incorrect"});

    const token = jwt.sign({id : fetchedUser._id}, process.env.JWT_SECRET, {expiresIn : process.env.JWT_EXPIRY});

    res.status(201).json({
      message : "Login Successfull",
      email : fetchedUser.email,
      name : fetchedUser.name,
      employeeId : fetchedUser.employeeId,
      token : token,
    })

  }catch(e){
    res.status(500).json({error : `Internal Server Error : ${e.message}`})
  }
}

module.exports = {signup, login};