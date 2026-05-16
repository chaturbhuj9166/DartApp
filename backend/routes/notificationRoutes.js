// =========================================
// notificationRoutes.js
// =========================================

const express =
require("express");

const router =
express.Router();

const {

  getNotifications,

  markAsRead,

} = require(

  "../controllers/notificationController"

);

const authMiddleware =
require(

  "../middleware/authMiddleware"

);

// =========================================
// GET ALL NOTIFICATIONS
// =========================================

router.get(

  "/",

  authMiddleware,

  getNotifications

);

// =========================================
// MARK AS READ
// =========================================

router.put(

  "/:id",

  authMiddleware,

  markAsRead

);

module.exports =
router;