const express =
require("express");

const router =
express.Router();

const {

  getReports,

} = require(

  "../controllers/reportController"

);

const authMiddleware =
require(

  "../middleware/authMiddleware"

);

const adminMiddleware =
require(

  "../middleware/adminMiddleware"

);

// =========================================
// GET REPORTS
// =========================================

router.get(

  "/",

  authMiddleware,

  adminMiddleware,

  getReports

);

module.exports =
router;