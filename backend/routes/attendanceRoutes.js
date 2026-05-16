// =========================================
// routes/attendanceRoutes.js
// =========================================

const express = require("express");

const router = express.Router();

const {

  punchIn,
  punchOut,
  getTodayAttendance,
  getAllAttendance,

} = require(
  "../controllers/attendanceController"
);

const authMiddleware =
  require("../middleware/authMiddleware");

const adminMiddleware =
  require("../middleware/adminMiddleware");

// =========================================
// PUNCH IN
// =========================================

router.post(

  "/punchin",

  authMiddleware,

  punchIn
);

// =========================================
// PUNCH OUT
// =========================================

router.post(

  "/punchout",

  authMiddleware,

  punchOut
);

// =========================================
// TODAY ATTENDANCE
// =========================================

router.get(

  "/today",

  authMiddleware,

  getTodayAttendance
);

// =========================================
// GET ALL ATTENDANCE
// =========================================

router.get(

  "/all",

  authMiddleware,

  adminMiddleware,

  getAllAttendance
);

module.exports = router;