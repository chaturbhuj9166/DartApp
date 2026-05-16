// =========================================
// authController.js
// =========================================

const User = require("../models/User");

const bcrypt = require("bcryptjs");

const jwt = require("jsonwebtoken");

// =========================================
// GENERATE TOKEN
// =========================================

const generateToken = (id) => {

  return jwt.sign(

    {
      id,
    },

    process.env.JWT_SECRET,

    {
      expiresIn: "7d",
    }

  );

};

// =========================================
// REGISTER USER
// =========================================

const registerUser = async (req, res) => {

  try {

    const {

      name,
      email,
      password,

    } = req.body;

    // VALIDATION
    if(

      !name ||
      !email ||
      !password

    ){

      return res.status(400).json({

        success: false,

        message:
        "All fields are required",

      });

    }

    // CHECK USER EXISTS
    const userExists =
    await User.findOne({

      email,

    });

    if(userExists){

      return res.status(400).json({

        success: false,

        message:
        "User already exists",

      });

    }

    // HASH PASSWORD
    const hashedPassword =
    await bcrypt.hash(

      password,

      10

    );

    // CREATE USER
    const user =
    await User.create({

      name,

      email,

      password:
      hashedPassword,

      role:
      "employee",

    });

    // TOKEN
    const token =
    generateToken(
      user._id
    );

    res.status(201).json({

      success: true,

      message:
      "User Registered Successfully",

      token,

      user: {

        _id:
        user._id,

        name:
        user.name,

        email:
        user.email,

        role:
        user.role,

      },

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message:
      error.message,

    });

  }

};

// =========================================
// LOGIN USER
// =========================================

const loginUser = async (req, res) => {

  try {

    const {

      email,
      password,

    } = req.body;

    // VALIDATION
    if(

      !email ||
      !password

    ){

      return res.status(400).json({

        success: false,

        message:
        "Email and Password required",

      });

    }

    // FIND USER
    const user =
    await User.findOne({

      email,

    });

    // USER NOT FOUND
    if(!user){

      return res.status(400).json({

        success: false,

        message:
        "Invalid Email",

      });

    }

    // CHECK PASSWORD
    const isMatch =
    await bcrypt.compare(

      password,

      user.password

    );

    // WRONG PASSWORD
    if(!isMatch){

      return res.status(400).json({

        success: false,

        message:
        "Invalid Password",

      });

    }

    // TOKEN
    const token =
    generateToken(
      user._id
    );

    res.status(200).json({

      success: true,

      message:
      "Login Successful",

      token,

      user: {

        _id:
        user._id,

        name:
        user.name,

        email:
        user.email,

        role:
        user.role,

      },

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message:
      error.message,

    });

  }

};

// =========================================
// VERIFY ADMIN PIN
// =========================================

const verifyAdminPin =
async (req, res) => {

  try {

    const { pin } =
    req.body;

    // CHECK PIN
    if(

      pin !==
      process.env.ADMIN_PIN

    ){

      return res.status(400).json({

        success: false,

        message:
        "Invalid PIN",

      });

    }

    // FIND USER
    const user =
    await User.findById(

      req.user.id

    );

    // USER NOT FOUND
    if(!user){

      return res.status(404).json({

        success: false,

        message:
        "User Not Found",

      });

    }

    // UPDATE ROLE
    user.role =
    "admin";

    // SAVE
    await user.save();

    res.status(200).json({

      success: true,

      message:
      "Admin Access Granted",

      user: {

        _id:
        user._id,

        name:
        user.name,

        email:
        user.email,

        role:
        user.role,

      },

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message:
      error.message,

    });

  }

};

// =========================================
// GET ALL USERS
// =========================================

const getAllUsers =
async (req, res) => {

  try {

    const users =

    await User.find()

    .select("-password")

    .sort({

      createdAt: -1,

    });

    res.status(200).json({

      success: true,

      users,

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message:
      error.message,

    });

  }

};

// =========================================
// DELETE USER
// =========================================

const deleteUser =
async (req, res) => {

  try {

    const { id } =
    req.params;

    // FIND USER
    const user =
    await User.findById(id);

    // USER NOT FOUND
    if(!user){

      return res.status(404).json({

        success: false,

        message:
        "User Not Found",

      });

    }

    // DELETE USER
    await User.findByIdAndDelete(id);

    res.status(200).json({

      success: true,

      message:
      "User Deleted Successfully",

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message:
      error.message,

    });

  }

};

// =========================================
// GET PROFILE
// =========================================

const getProfile =
async (req, res) => {

  try {

    const user =
    await User.findById(

      req.user.id

    ).select("-password");

    if(!user){

      return res.status(404).json({

        success: false,

        message:
        "User Not Found",

      });

    }

    res.status(200).json({

      success: true,

      user,

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message:
      error.message,

    });

  }

};

// =========================================
// UPDATE PROFILE
// =========================================

const updateProfile =
async (req, res) => {

  try {

    const {

      name,

      email,

      profileImage,

    } = req.body;

    const user =
    await User.findById(

      req.user.id

    );

    if(!user){

      return res.status(404).json({

        success: false,

        message:
        "User Not Found",

      });

    }

    // UPDATE DATA
    user.name =
    name || user.name;

    user.email =
    email || user.email;

    user.profileImage =
    profileImage ||
    user.profileImage;

    // SAVE
    await user.save();

    res.status(200).json({

      success: true,

      message:
      "Profile Updated",

      user,

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message:
      error.message,

    });

  }

};

// =========================================
// EXPORTS
// =========================================

module.exports = {

  registerUser,

  loginUser,

  verifyAdminPin,

  getAllUsers,

  deleteUser,

  getProfile,

  updateProfile,

};