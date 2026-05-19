const mongoose =
require("mongoose");

const announcementSchema =
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

  },

  assignedBy: {

    type:
    mongoose.Schema.Types.ObjectId,

    ref: "User",

    required: true,

  },

  sendToAll: {

    type: Boolean,

    default: false,

  },

  status: {

    type: String,

    enum: ["Unread", "Seen", "Replied"],

    default: "Unread",

  },

  reply: {

    type: String,

    default: "",

  },

  seenBy: [

    {

      type:
      mongoose.Schema.Types.ObjectId,

      ref: "User",

    }

  ],

}, {

  timestamps: true,

});

module.exports =
mongoose.model(

  "Announcement",

  announcementSchema

);