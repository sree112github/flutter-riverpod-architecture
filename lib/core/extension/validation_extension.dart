

extension StringValidation on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    // Basic phone number validation: Optional '+' followed by 10 to 14 digits
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,14}$');
    return phoneRegExp.hasMatch(this);
  }
}
