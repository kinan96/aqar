String mobileValidate(v) {
  if (v.isEmpty)
    return "Please insert Mobile Number";
  else if (v.length < 10)
    return "Mobile number can\'t be less than 10 numbers";
  else if (int.tryParse(v) == null)
    return "Mobile number can\'t contain letters";
  else
    return null;
}



String emptyValidate(v) {
  if (v.isEmpty)
    return "ًThis field can\'t be empty";
  else
    return null;
}

String titleValidate(v) {
  if (v.isEmpty)
    return "ًTitle can\'t be empty";
  else
    return null;
}

String priceValidate(v) {
  if (v.isEmpty)
    return "ًPrice can\'t be empty";
  else if (double.tryParse(v) == null)
    return "Price has only numbers";
  else
    return null;
}

String noteValidate(v) {
  if (v.isEmpty)
    return "ًDescription can\'t be empty";
  else
    return null;
}

String detailsValidate(v) {
  if (v.isEmpty)
    return "ًDetails can\'t be empty";
  else if (v.length < 25)
    return "Details must be more than 24 letter";
  else
    return null;
}


String nameValidate(v) {
  if (v.isEmpty)
    return "Please insert First Name";
// else {
//   List co=v.toString().split(" ");
//     if(co.last==""||co.length<4)
//       return "من فضلك أدخل اسمك الرباعي";
  else
    return null;

  // }
}

String codeValidate(v) {
  if (v.isEmpty)
    return "Activation code  can\'t be empty";
  else
    return null;
}


String emailValidate(v) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(v) || v.isEmpty)
    return "please enter a valid email";
  else
    return null;
}

String passwordValidate(v) {
  if (v.isEmpty)
    return "password can\'t be empty";
  else if (v.length < 8)
    return "password can\'t be less than 8 letters";
  else
    return null;
}
