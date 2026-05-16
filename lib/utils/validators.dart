class Validators {

  // =========================
  // EMAIL VALIDATION
  // =========================

  static String?
  validateEmail(String value){

    if(value.isEmpty){

      return
      "Email is required";

    }

    if(
      !value.contains("@")
    ){

      return
      "Enter valid email";

    }

    return null;

  }

  // =========================
  // PASSWORD VALIDATION
  // =========================

  static String?
  validatePassword(
    String value,
  ){

    if(value.isEmpty){

      return
      "Password is required";

    }

    if(value.length < 6){

      return
      "Password must be at least 6 characters";

    }

    return null;

  }

  // =========================
  // NAME VALIDATION
  // =========================

  static String?
  validateName(
    String value,
  ){

    if(value.isEmpty){

      return
      "Name is required";

    }

    if(value.length < 3){

      return
      "Name too short";

    }

    return null;

  }

}