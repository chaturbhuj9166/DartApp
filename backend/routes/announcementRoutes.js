const express =
require("express");

const router =
express.Router();

const {

  createAnnouncement,

  getUserAnnouncements,

  replyAnnouncement,

  markAnnouncementSeen,

  deleteAnnouncement,

} = require(

  "../controllers/announcementController"

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
// CREATE ANNOUNCEMENT
// =========================================

router.post(

  "/create",

  authMiddleware,

  adminMiddleware,

  createAnnouncement

);

// =========================================
// GET USER ANNOUNCEMENTS
// =========================================

router.get(

  "/user",

  authMiddleware,

  getUserAnnouncements

);

// =========================================
// REPLY TO ANNOUNCEMENT
// =========================================

router.post(

  "/reply",

  authMiddleware,

  replyAnnouncement

);

// =========================================
// MARK AS SEEN
// =========================================

router.put(

  "/seen/:id",

  authMiddleware,

  markAnnouncementSeen

);

// =========================================
// DELETE ANNOUNCEMENT
// =========================================

router.delete(

  "/:id",

  authMiddleware,

  adminMiddleware,

  deleteAnnouncement

);

module.exports =
router;