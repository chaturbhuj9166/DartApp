const mongoose =
require("mongoose");

const userSchema =
new mongoose.Schema({

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

  // PROFILE IMAGE
  profileImage: {

    type: String,

    default: "",

  },

  role: {

    type: String,

    enum: [

      "admin",

      "employee",

    ],

    default: "employee",

  },

}, {

  timestamps: true,

});

// EXPORT
module.exports =
mongoose.model(

  "User",

  userSchema

);