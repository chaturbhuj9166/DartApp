const Announcement =
require("../models/Announcement");

const Notification =
require("../models/Notification");

const User =
require("../models/User");

const {
  createNotification,
} = require("./notificationController");

// =========================================
// CREATE ANNOUNCEMENT
// =========================================

const createAnnouncement =
async (req, res) => {

  try {

    const {

      title,
      description,
      assignedTo,
      sendToAll,

    } = req.body;

    // VALIDATION

    if(!title){

      return res.status(400)
      .json({

        success: false,

        message:
        "Title required",

      });

    }

    // CREATE

    const announcement =
    await Announcement.create({

      title,

      description,

      assignedTo:
      sendToAll
      ? null
      : assignedTo,

      assignedBy:
      req.user.id,

      sendToAll:
      sendToAll || false,

    });

    // =========================================
    // NOTIFICATION
    // =========================================

    if (sendToAll) {

      const employees =
      await User.find({

        role: "employee",

      }).select("_id");

      await Promise.all(
        employees.map((user) =>
          createNotification({
            user: user._id,
            title: "New Announcement",
            message: `Announcement: ${title}`,
            announcement: announcement._id,
          }),
        ),
      );

    }

    else {

      await createNotification({

        user:
        assignedTo,

        title:
        "New Announcement",

        message:
        `Announcement: ${title}`,

        announcement:
        announcement._id,

      });

    }

    res.status(201).json({

      success: true,

      message:
      "Announcement Created",

      announcement,

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
// GET USER ANNOUNCEMENTS
// =========================================

const getUserAnnouncements =
async (req, res) => {

  try {

    const announcements =

    await Announcement.find({

      $or: [

        {

          assignedTo:
          req.user.id,

        },

        {

          sendToAll: true,

        },

      ],

    })

    .populate(

      "assignedBy",

      "name email role"

    )

    .sort({

      createdAt: -1,

    });

    const formattedAnnouncements =
      announcements.map((announcement) => ({
        ...announcement.toObject(),
        status:
          announcement.status ||
          (announcement.seenBy.some(
            (id) => id.toString() === req.user.id,
          )
            ? "Seen"
            : "Unread"),
        reply:
          announcement.reply || "",
      }));

    res.status(200).json({

      success: true,

      announcements: formattedAnnouncements,

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
// REPLY ANNOUNCEMENT
// =========================================

const replyAnnouncement =
async (req, res) => {

  try {

    const {

      announcementId,
      reply,
      status,

    } = req.body;

    if (!announcementId || !reply) {

      return res.status(400)
      .json({

        success: false,

        message:
        "Announcement ID and reply are required",

      });

    }

    const announcement =
    await Announcement.findById(
      announcementId,
    );

    if (!announcement) {

      return res.status(404)
      .json({

        success: false,

        message:
        "Announcement not found",

      });

    }

    if (
      !announcement.sendToAll &&
      announcement.assignedTo?.toString() !== req.user.id
    ) {

      return res.status(403)
      .json({

        success: false,

        message:
        "Unauthorized to reply to this announcement",

      });

    }

    announcement.reply = reply;

    announcement.status =
    status ?? "Seen";

    if (
      !announcement.seenBy.some(
        (id) => id.toString() === req.user.id,
      )
    ) {

      announcement.seenBy.push(
        req.user.id,
      );

    }

    await announcement.save();

    await createNotification({

      user:
      announcement.assignedBy,

      title:
      "Announcement Reply",

      message:
      `Reply received for ${announcement.title}`,

      announcement:
      announcement._id,

    });

    res.status(200).json({

      success: true,

      message:
      "Reply submitted",

      announcement,

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
// MARK AS SEEN
// =========================================

const markAnnouncementSeen =
async (req, res) => {

  try {

    const announcement =
    await Announcement.findById(
      req.params.id
    );

    if(!announcement){

      return res.status(404)
      .json({

        success: false,

        message:
        "Announcement not found",

      });

    }

    // ALREADY SEEN

    const alreadySeen =
    announcement.seenBy.some(
      (id) => id.toString() === req.user.id,
    );

    if(!alreadySeen){

      announcement.seenBy.push(
        req.user.id
      );

      await announcement.save();

    }

    res.status(200).json({

      success: true,

      message:
      "Announcement Seen",

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
// DELETE ANNOUNCEMENT
// =========================================

const deleteAnnouncement =
async (req, res) => {

  try {

    const announcement =
    await Announcement.findById(
      req.params.id
    );

    if(!announcement){

      return res.status(404)
      .json({

        success: false,

        message:
        "Announcement not found",

      });

    }

    await announcement.deleteOne();

    res.status(200).json({

      success: true,

      message:
      "Announcement Deleted",

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

  createAnnouncement,

  getUserAnnouncements,

  replyAnnouncement,

  markAnnouncementSeen,

  deleteAnnouncement,

};