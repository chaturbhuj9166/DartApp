const cron = require("node-cron");
const Attendance = require("../models/Attendance");

const formatSessionDuration = (startTime, endTime) => {
  const diff = endTime - startTime;
  const hours = Math.floor(diff / (1000 * 60 * 60));
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
  return `${hours}h ${minutes}m`;
};

const runAutoPunchOut = async () => {
  try {
    const now = new Date();
    const activeAttendances = await Attendance.find({ punchOutTime: null }).sort({ createdAt: -1 });

    if (!activeAttendances.length) {
      console.log("[autoPunchOut] No active attendance records found at 19:00.");
      return;
    }

    const saves = activeAttendances.map((attendance) => {
      if (!attendance.punchInTime) {
        attendance.punchOutTime = now;
        attendance.totalHours = "0h 0m";
      } else {
        attendance.punchOutTime = now;
        attendance.totalHours = formatSessionDuration(attendance.punchInTime, now);
      }
      return attendance.save();
    });

    await Promise.all(saves);
    console.log(`
[autoPunchOut] Completed automatic punch out for ${activeAttendances.length} active session(s) at ${now.toLocaleString()}.
`);
  } catch (error) {
    console.error("[autoPunchOut] Error running automatic punch out:", error);
  }
};

module.exports = () => {
  cron.schedule(
    "0 0 19 * * *",
    () => {
      console.log("[autoPunchOut] Triggering scheduled punch out at 19:00.");
      runAutoPunchOut();
    },
    {
      scheduled: true,
      timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
    }
  );
  console.log("[autoPunchOut] Scheduled automatic punch out at 19:00 local server time.");
};
