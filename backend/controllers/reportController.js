const User =
require("../models/User");

const Announcement =
require("../models/Announcement");

const Attendance =
require("../models/Attendance");

// =========================================
// GET REPORTS
// =========================================

const getReports =
async (req, res) => {

  try {

    // =========================================
    // TOTAL USERS
    // =========================================

    const totalUsers =
    await User.countDocuments();

    // =========================================
    // TOTAL ADMINS
    // =========================================

    const totalAdmins =
    await User.countDocuments({

      role: "admin",

    });

    // =========================================
    // TOTAL EMPLOYEES
    // =========================================

    const totalEmployees =
    await User.countDocuments({

      role: "employee",

    });

    // =========================================
    // TOTAL ANNOUNCEMENTS
    // =========================================

    const totalAnnouncements =
    await Announcement.countDocuments();

    // =========================================
    // TOTAL ATTENDANCE
    // =========================================

    const totalAttendance =
    await Attendance.countDocuments();

    // =========================================
    // PRESENT EMPLOYEES
    // =========================================

    const presentEmployees =
    await Attendance.countDocuments({

      punchOutTime: null,

    });

    // =========================================
    // RESPONSE
    // =========================================

    res.status(200).json({

      success: true,

      reports: {

        totalUsers,

        totalAdmins,

        totalEmployees,

        totalAnnouncements,

        totalAttendance,

        presentEmployees,

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
// EXPORTS
// =========================================

module.exports = {

  getReports,

};