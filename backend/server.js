const express =
require("express");

const dotenv =
require("dotenv");

const cors =
require("cors");

// DATABASE
const connectDB =
require("./config/db");

// ROUTES
const authRoutes =
require("./routes/authRoutes");



const attendanceRoutes = require("./routes/attendanceRoutes");
const announcementRoutes = require("./routes/announcementRoutes");
const notificationRoutes = require("./routes/notificationRoutes");
const reportRoutes = require("./routes/reportRoutes");
const startAutoPunchOut = require("./utils/autoPunchOut");

// ENV CONFIG
dotenv.config();

// EXPRESS APP
const app = express();

const startServer = async () => {
  await connectDB();
  startAutoPunchOut();

  app.listen(PORT, () => {
    console.log(`🚀 Server Running On Port ${PORT}`);
  });
};

// =========================================
// MIDDLEWARE
// =========================================

// JSON
app.use(
  express.json()
);

// CORS
app.use(

  cors({

    origin: "*",

    methods: [

      "GET",
      "POST",
      "PUT",
      "DELETE",

    ],

    credentials: true,

  })

);

// =========================================
// TEST ROUTE
// =========================================

app.get("/", (req, res) => {

  res.send(
    "PunchIn Backend Running 🚀"
  );

});

// =========================================
// API ROUTES
// =========================================

// AUTH
app.use(
  "/api/auth",
  authRoutes
);



// ATTENDANCE
app.use(
  "/api/attendance",
  attendanceRoutes
);

// ANNOUNCEMENTS
app.use(
  "/api/announcements",
  announcementRoutes
);

// NOTIFICATIONS
app.use(
  "/api/notifications",
  notificationRoutes
);

// REPORTS
app.use(
  "/api/reports",
  reportRoutes
);

// =========================================
// 404 ROUTE
// =========================================

app.use((req, res) => {

  res.status(404).json({

    success: false,

    message:
    "Route Not Found",

  });

});

// =========================================
// SERVER PORT
// =========================================

const PORT = process.env.PORT || 5000;

// =========================================
// START SERVER
// =========================================

startServer();