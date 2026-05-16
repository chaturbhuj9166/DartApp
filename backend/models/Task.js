const mongoose =
require("mongoose");

const taskSchema =
new mongoose.Schema({

  title: {

    type: String,

    required: true,

    trim: true,

  },

  description: {

    type: String,

    default: "",

  },

  assignedTo: {

    type:
    mongoose.Schema.Types.ObjectId,

    ref: "User",

    required: true,

  },

  assignedBy: {

    type:
    mongoose.Schema.Types.ObjectId,

    ref: "User",

    required: true,

  },

  status: {

    type: String,

    enum: [

      "Pending",

      "In Progress",

      "Completed",

    ],

    default:
    "Pending",

  },

  reply: {

    type: String,

    default: "",

  },

  dueDate: {

    type: Date,

  },

}, {

  timestamps: true,

});

module.exports =
mongoose.model(

  "Task",

  taskSchema

);