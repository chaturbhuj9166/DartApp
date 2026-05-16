const jwt =
require("jsonwebtoken");

const User =
require("../models/User");

const authMiddleware =
async (req, res, next) => {

  try {

    // GET TOKEN
    const authHeader =
    req.headers.authorization;

    // CHECK TOKEN
    if(

      !authHeader ||

      !authHeader.startsWith(
        "Bearer "
      )

    ){

      return res.status(401).json({

        success: false,

        message:
        "No Token Provided",

      });

    }

    // REMOVE Bearer
    const token =
    authHeader.split(" ")[1];

    // VERIFY TOKEN
    const decoded =
    jwt.verify(

      token,

      process.env.JWT_SECRET

    );

    // FIND USER
    const user =
    await User.findById(

      decoded.id

    ).select("-password");

    // USER NOT FOUND
    if(!user){

      return res.status(404).json({

        success: false,

        message:
        "User Not Found",

      });

    }

    // SAVE USER
    req.user = user;

    next();

  }

  catch(error){

    res.status(401).json({

      success: false,

      message:
      "Invalid Token",

    });

  }

};

module.exports =
authMiddleware;