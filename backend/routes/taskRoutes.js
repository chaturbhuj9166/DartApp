const express =
require("express");

const router =
express.Router();

const {

  createTask,

  getUserTasks,

  replyTask,

} = require(

  "../controllers/taskController"

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
// CREATE TASK
// =========================================

router.post(

  "/create",

  authMiddleware,

  adminMiddleware,

  createTask

);

// =========================================
// GET USER TASKS
// =========================================

router.get(

  "/user",

  authMiddleware,

  getUserTasks

);

// =========================================
// REPLY TASK
// =========================================

router.post(

  "/reply",

  authMiddleware,

  replyTask

);

module.exports =
router;