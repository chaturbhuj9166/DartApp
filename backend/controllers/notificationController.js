// =========================================
// notificationController.js
// =========================================

const Notification =
require("../models/Notification");

// =========================================
// GET NOTIFICATIONS
// =========================================

const getNotifications =
async (req, res) => {

  try {

    const notifications =

    await Notification.find({

      user:
      req.user.id,

    })

    .populate(

      "user",

      "name email role"

    )

    .sort({

      createdAt: -1,

    });

    res.status(200).json({

      success: true,

      notifications,

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
// MARK AS READ
// =========================================

const markAsRead =
async (req, res) => {

  try {

    const { id } =
    req.params;

    // FIND NOTIFICATION
    const notification =

    await Notification.findById(
      id
    );

    // NOT FOUND
    if(!notification){

      return res.status(404).json({

        success: false,

        message:
        "Notification not found",

      });

    }

    // SECURITY CHECK
    if(

      notification.user.toString()
      !== req.user.id

    ){

      return res.status(403).json({

        success: false,

        message:
        "Unauthorized",

      });

    }

    // UPDATE
    notification.isRead =
    true;

    await notification.save();

    res.status(200).json({

      success: true,

      message:
      "Notification marked as read",

      notification,

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
// CREATE NOTIFICATION
// =========================================

const createNotification =
async ({

  user,
  title,
  message,

}) => {

  try {

    await Notification.create({

      user,

      title,

      message,

    });

  }

  catch(error){

    console.log(
      error.message
    );

  }

};

// =========================================
// EXPORTS
// =========================================

module.exports = {

  getNotifications,

  markAsRead,

  createNotification,

};