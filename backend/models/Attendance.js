// =========================================
// models/Attendance.js
// =========================================

const mongoose = require("mongoose");

const attendanceSchema =
  new mongoose.Schema({

    user: {

      type:
      mongoose.Schema.Types.ObjectId,

      ref: "User",

      required: true,

    },

    date: {

      type: Date,

      default: Date.now,

    },

    punchInTime: {

      type: Date,

    },

    punchOutTime: {

      type: Date,

    },

    totalHours: {

      type: String,

      default: "0h 0m",

    },

    status: {

      type: String,

      default: "Present",

    },

  }, {

    timestamps: true,

  });

module.exports =
  mongoose.model(

    "Attendance",

    attendanceSchema

  );