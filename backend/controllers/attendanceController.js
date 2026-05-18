// =========================================
// controllers/attendanceController.js
// =========================================

const Attendance = require("../models/Attendance");

// =========================================
// CHECK PUNCH IN TIME
// =========================================

const isPunchInAllowed = (date) => {

  const hour = date.getHours();

  return hour >= 9 && hour < 19;

};

// =========================================
// FORMAT HOURS
// =========================================

const formatSessionDuration = (
  startTime,
  endTime
) => {

  const diff =
    endTime - startTime;

  const hours =
    Math.floor(

      diff /
      (1000 * 60 * 60)

    );

  const minutes =
    Math.floor(

      (
        diff %
        (1000 * 60 * 60)
      )

      / (1000 * 60)

    );

  return `${hours}h ${minutes}m`;

};

// =========================================
// TODAY BOUNDS
// =========================================

const getTodayBounds = (
  baseDate = new Date()
) => {

  const startOfDay =
    new Date(baseDate);

  startOfDay.setHours(
    0, 0, 0, 0
  );

  const endOfDay =
    new Date(baseDate);

  endOfDay.setHours(
    23, 59, 59, 999
  );

  return {

    startOfDay,

    endOfDay,

  };

};

// =========================================
// PUNCH IN
// =========================================

const punchIn = async (
  req,
  res
) => {

  try {

    const userId =
      req.user.id;

    const now =
      new Date();

    // CHECK TIME

    if (
      !isPunchInAllowed(now)
    ) {

      return res.status(400)
      .json({

        success: false,

        message:
          "Punch In allowed only between 9 AM and 7 PM",

      });

    }

    // CHECK ACTIVE SESSION

    const activeAttendance =
      await Attendance.findOne({

        user: userId,

        punchOutTime: null,

      }).sort({

        createdAt: -1,

      });

    // ALREADY ACTIVE

    if (activeAttendance) {

      return res.status(400)
      .json({

        success: false,

        message:
          "Already Punched In",

      });

    }

    // CREATE NEW SESSION

    const attendance =
      await Attendance.create({

        user: userId,

        date: now,

        punchInTime: now,

      });

    res.status(201).json({

      success: true,

      message:
        "Punch In Successful",

      attendance,

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
// PUNCH OUT
// =========================================

const punchOut = async (
  req,
  res
) => {

  try {

    const userId =
      req.user.id;

    // FIND ACTIVE SESSION

    const activeAttendance =
      await Attendance.findOne({

        user: userId,

        punchOutTime: null,

      }).sort({

        createdAt: -1,

      });

    // NO ACTIVE SESSION

    if (!activeAttendance) {

      return res.status(400)
      .json({

        success: false,

        message:
          "Please Punch In First",

      });

    }

    const currentTime =
      new Date();

    // SAVE PUNCH OUT

    activeAttendance
    .punchOutTime =
      currentTime;

    // CALCULATE HOURS

    activeAttendance
    .totalHours =
      formatSessionDuration(

        activeAttendance
        .punchInTime,

        currentTime

      );

    // SAVE

    await activeAttendance
    .save();

    res.status(200).json({

      success: true,

      message:
        "Punch Out Successful",

      attendance:
        activeAttendance,

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
// GET TODAY ATTENDANCE
// =========================================

const getTodayAttendance =
async (req, res) => {

  try {

    const userId =
      req.user.id;

    const {
      startOfDay,
      endOfDay
    } = getTodayBounds();

    // GET LATEST SESSION

    const attendance =
      await Attendance.findOne({

        user: userId,

        date: {

          $gte: startOfDay,

          $lte: endOfDay,

        },

      })

      .populate(

        "user",

        "name email role"

      )

      .sort({

        createdAt: -1,

      });

    res.status(200).json({

      success: true,

      attendance,

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
// GET ALL ATTENDANCE
// =========================================

const getAllAttendance =
async (req, res) => {

  try {

    const attendance =
      await Attendance.find()

      .populate(

        "user",

        "name email role"

      )

      .sort({

        createdAt: -1,

      });

    res.status(200).json({

      success: true,

      attendance,

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

  punchIn,

  punchOut,

  getTodayAttendance,

  getAllAttendance,

};