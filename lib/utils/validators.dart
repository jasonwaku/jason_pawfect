String validateName(String value) {
  Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Username is Required';
  }
  if (!regex.hasMatch(value)) {
    return 'Invalid Username';
  } else {
    return null;
  }
}

String validateNameDog(String value) {
  Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Dog Name is Required';
  }
  if (!regex.hasMatch(value)) {
    return 'Invalid Dog Name';
  } else {
    return null;
  }
}

String validateNumber(String value){
  Pattern pattern = r'^[0-9]+(?:[ _-][0-9]+)*$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Value Required';
  }
  if (!regex.hasMatch(value)) {
    return 'Invalid Number';
  } else {
    return null;
  }
}

String validateNumberDecimal(String value){
  Pattern pattern = r'^\d{0,2}(\.\d{0,2})?$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Value Required';
  }
  if (!regex.hasMatch(value)) {
    return 'Invalid Value';
  } else {
    return null;
  }
}

String validateEmail(String value) {
  Pattern pattern = r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Email is Required';
  }
  if (!regex.hasMatch(value)) {
    return 'Enter a Valid Email-Address';
  }
  return null;
}

String validatePassword(String value) {
  // if (value.isEmpty) {
  //   return 'Password is Required';
  // }
  // if (value.length < 8) {
  //   return 'Password Must Be 8 Characters';
  // }
  return null;
//      Pattern pattern =
//          r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
//      RegExp regex = new RegExp(pattern);
//      if (!regex.hasMatch(password))
//        return 'Invalid password';
//      else
//        return null;
}

String validateAddress(String value) {
  if (value.isEmpty) {
    return 'Address is Required';
  }
  else {
    return null;
  }
}

String validatePhone(String value) {
  Pattern pattern = //r'^([0-9]|[1-9][0-9]{0,10})$';
      //r'^\(?:[0-9]●?){9,10}[0-9]$';
      r'^[0-9+\(\)#\.\s\/ext-]+$';
  //'/^(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\ \\\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?$/i';  //r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Phone number is required';
  }
  if (!regex.hasMatch(value) || !value.startsWith('0')) {
    return 'Enter a valid Phone number';
  }
  else {
    return null;
  }
}