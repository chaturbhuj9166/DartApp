const User =
require("../models/User");

const Task =
require("../models/Task");

const Attendance =
require("../models/Attendance");

// =========================================
// GET REPORTS
// =========================================

const getReports =
async (req, res) => {

  try {

    // TOTAL USERS
    const totalUsers =
    await User.countDocuments();

    // TOTAL ADMINS
    const totalAdmins =
    await User.countDocuments({

      role: "admin",

    });

    // TOTAL TASKS
    const totalTasks =
    await Task.countDocuments();

    // COMPLETED TASKS
    const completedTasks =
    await Task.countDocuments({

      status: "Completed",

    });

    // PENDING TASKS
    const pendingTasks =
    await Task.countDocuments({

      status: "Pending",

    });

    // TOTAL ATTENDANCE
    const totalAttendance =
    await Attendance.countDocuments();

    res.status(200).json({

      success: true,

      reports: {

        totalUsers,

        totalAdmins,

        totalTasks,

        completedTasks,

        pendingTasks,

        totalAttendance,

      },

    });

  }

  catch(error){

    res.status(500).json({

      success: false,

      message: error.message,

    });

  }

};

module.exports = {

  getReports,

};