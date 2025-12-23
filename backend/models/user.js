const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const userSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  
  email: {
    type: String,
    required: true,
    unique: true,
  },

  password: {
    type: String,
    required: true,
  },

  employeeId: {
    type: String,
    required: true,
    unique: true,
  },

  createdAt: {
    type: Date,
    default: Date.now(),
  },
});

userSchema.pre("save", async function () {
  if (!this.isModified("password")) return ;

  this.password = await bcrypt.hash(this.password, 10);

  console.log("passed")
});


module.exports = mongoose.model("User", userSchema);
