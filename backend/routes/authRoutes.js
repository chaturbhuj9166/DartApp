// =========================================
// authRoutes.js
// =========================================

const express =
require("express");

const router =
express.Router();

// =========================================
// CONTROLLERS
// =========================================

const {

  registerUser,

  loginUser,

  verifyAdminPin,

  getProfile,

  updateProfile,

} = require(

  "../controllers/authController"

);

const {

  getAllUsers,

  deleteUser,

} = require(

  "../controllers/authController"

);

// =========================================
// MIDDLEWARES
// =========================================

const authMiddleware =
require(

  "../middleware/authMiddleware"

);

const adminMiddleware =
require(

  "../middleware/adminMiddleware"

);

// =========================================
// TEST ROUTE
// =========================================

router.get("/", (req, res) => {

  res.status(200).json({

    success: true,

    message:
    "Auth Routes Working 🚀",

  });

});

// =========================================
// REGISTER USER
// =========================================

router.post(

  "/register",

  registerUser

);

// =========================================
// LOGIN USER
// =========================================

router.post(

  "/login",

  loginUser

);

// =========================================
// VERIFY ADMIN PIN
// =========================================

router.post(

  "/admin-access",

  authMiddleware,

  verifyAdminPin

);

// =========================================
// GET ALL USERS
// =========================================

router.get(

  "/users",

  authMiddleware,

  adminMiddleware,

  getAllUsers

);

// =========================================
// DELETE USER
// =========================================

router.delete(

  "/users/:id",

  authMiddleware,

  adminMiddleware,

  deleteUser

);

// =========================================
// GET PROFILE
// =========================================

router.get(

  "/profile",

  authMiddleware,

  getProfile

);

// =========================================
// UPDATE PROFILE
// =========================================

router.put(

  "/profile",

  authMiddleware,

  updateProfile

);

// =========================================
// EXPORT ROUTER
// =========================================

module.exports =
router;