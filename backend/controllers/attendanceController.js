// =========================================
// controllers/attendanceController.js
// =========================================

const Attendance =
  require("../models/Attendance");

// =========================================
// PUNCH IN
// =========================================

const punchIn = async (req, res) => {

  try {

    const userId = req.user.id;

    // START OF DAY
    const startOfDay =
      new Date();

    startOfDay.setHours(
      0, 0, 0, 0
    );

    // END OF DAY
    const endOfDay =
      new Date();

    endOfDay.setHours(
      23, 59, 59, 999
    );

    // CHECK EXISTING ATTENDANCE
    const alreadyPunched =
      await Attendance.findOne({

        user: userId,

        date: {

          $gte: startOfDay,

          $lte: endOfDay,

        },

      });

    // ALREADY PUNCHED
    if (alreadyPunched) {

      return res.status(400).json({

        success: false,

        message:
          "Already punched in today",

      });

    }

    // CREATE ATTENDANCE
    const attendance =
      await Attendance.create({

        user: userId,

        punchInTime:
          new Date(),

      });

    res.status(201).json({

      success: true,

      message:
        "Punch In Successful",

      attendance,

    });

  } catch (error) {

    res.status(500).json({

      success: false,

      message: error.message,

    });

  }
};

// =========================================
// PUNCH OUT
// =========================================

const punchOut = async (req, res) => {

  try {

    const userId = req.user.id;

    // START OF DAY
    const startOfDay =
      new Date();

    startOfDay.setHours(
      0, 0, 0, 0
    );

    // END OF DAY
    const endOfDay =
      new Date();

    endOfDay.setHours(
      23, 59, 59, 999
    );

    // FIND TODAY ATTENDANCE
    const attendance =
      await Attendance.findOne({

        user: userId,

        date: {

          $gte: startOfDay,

          $lte: endOfDay,

        },

      });

    // NOT FOUND
    if (!attendance) {

      return res.status(400).json({

        success: false,

        message:
          "Please Punch In First",

      });

    }

    // ALREADY PUNCHED OUT
    if (attendance.punchOutTime) {

      return res.status(400).json({

        success: false,

        message:
          "Already Punched Out",

      });

    }

    // CURRENT TIME
    const currentTime =
      new Date();

    // SAVE PUNCH OUT
    attendance.punchOutTime =
      currentTime;

    // CALCULATE DIFFERENCE
    const diff =
      currentTime
      - attendance.punchInTime;

    // HOURS
    const hours =
      Math.floor(

        diff /
        (1000 * 60 * 60)

      );

    // MINUTES
    const minutes =
      Math.floor(

        (
          diff %
          (1000 * 60 * 60)
        )

        / (1000 * 60)

      );

    // SAVE TOTAL HOURS
    attendance.totalHours =
      `${hours}h ${minutes}m`;

    // SAVE
    await attendance.save();

    res.status(200).json({

      success: true,

      message:
        "Punch Out Successful",

      attendance,

    });

  } catch (error) {

    res.status(500).json({

      success: false,

      message: error.message,

    });

  }
};

// =========================================
// GET TODAY ATTENDANCE
// =========================================

const getTodayAttendance =
  async (req, res) => {

    try {

      const userId = req.user.id;

      // START OF DAY
      const startOfDay =
        new Date();

      startOfDay.setHours(
        0, 0, 0, 0
      );

      // END OF DAY
      const endOfDay =
        new Date();

      endOfDay.setHours(
        23, 59, 59, 999
      );

      // FIND ATTENDANCE
      const attendance =
        await Attendance.findOne({

          user: userId,

          date: {

            $gte: startOfDay,

            $lte: endOfDay,

          },

        }).populate(

          "user",

          "name email role"

        );

      res.status(200).json({

        success: true,

        attendance,

      });

    } catch (error) {

      res.status(500).json({

        success: false,

        message: error.message,

      });

    }
};

// =========================================
// GET ALL ATTENDANCE (ADMIN)
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

      message: error.message,

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