// =========================================
// taskController.js
// =========================================

const Task =
require("../models/Task");

const Notification =
require("../models/Notification");

// =========================================
// CREATE TASK
// =========================================

const createTask =
async (req, res) => {

  try {

    const {

      title,
      description,
      assignedTo,
      dueDate,

    } = req.body;

    // VALIDATION
    if(

      !title ||
      !assignedTo

    ){

      return res.status(400).json({

        success: false,

        message:
        "Title and Assigned User required",

      });

    }

    // CREATE TASK
    const task =
    await Task.create({

      title,

      description,

      assignedTo,

      assignedBy:
      req.user.id,

      dueDate,

    });

    // =========================================
    // CREATE NOTIFICATION
    // =========================================

    await Notification.create({

      user:
      assignedTo,

      taskId:
      task._id,

      title:
      "New Task Assigned",

      message:
      `You received a new task: ${title}`,

    });

    // POPULATE TASK
    const populatedTask =
    await Task.findById(
      task._id
    )

    .populate(

      "assignedTo",

      "name email role"

    )

    .populate(

      "assignedBy",

      "name email role"

    );

    res.status(201).json({

      success: true,

      message:
      "Task Assigned Successfully",

      task:
      populatedTask,

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
// GET USER TASKS
// =========================================

const getUserTasks =
async (req, res) => {

  try {

    const tasks =

    await Task.find({

      assignedTo:
      req.user.id,

    })

    .populate(

      "assignedBy",

      "name email role"

    )

    .populate(

      "assignedTo",

      "name email role"

    )

    .sort({

      createdAt: -1,

    });

    res.status(200).json({

      success: true,

      tasks,

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
// TASK REPLY
// =========================================

const replyTask =
async (req, res) => {

  try {

    const {

      taskId,
      reply,
      status,

    } = req.body;

    // FIND TASK
    const task =
    await Task.findById(
      taskId
    );

    // TASK NOT FOUND
    if(!task){

      return res.status(404).json({

        success: false,

        message:
        "Task not found",

      });

    }

    // SECURITY CHECK
    if(

      task.assignedTo.toString()
      !== req.user.id

    ){

      return res.status(403).json({

        success: false,

        message:
        "Unauthorized",

      });

    }

    // UPDATE TASK
    task.reply =
    reply || "";

    task.status =
    status || "Pending";

    // SAVE TASK
    await task.save();

    // =========================================
    // CREATE REPLY NOTIFICATION
    // =========================================

    await Notification.create({

      user:
      task.assignedBy,

      taskId:
      task._id,

      title:
      "Task Reply Submitted",

      message:
      `Reply submitted for task: ${task.title}`,

    });

    // POPULATE UPDATED TASK
    const updatedTask =
    await Task.findById(
      task._id
    )

    .populate(

      "assignedTo",

      "name email role"

    )

    .populate(

      "assignedBy",

      "name email role"

    );

    res.status(200).json({

      success: true,

      message:
      "Reply Submitted",

      task:
      updatedTask,

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

  createTask,

  getUserTasks,

  replyTask,

};