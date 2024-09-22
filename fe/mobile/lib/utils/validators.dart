class Validators {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final upperCaseRegex = RegExp(r'[A-Z]');
    final lowerCaseRegex = RegExp(r'[a-z]');
    final digitRegex = RegExp(r'\d');

    if (!specialCharRegex.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }
    if (!upperCaseRegex.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!lowerCaseRegex.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!digitRegex.hasMatch(password)) {
      return 'Password must contain at least one digit';
    }
    return null;
  }

  static String? validateFullName(String fullName) {
    if (fullName.isEmpty) {
      return 'Full name cannot be empty';
    }
    final fullNameRegex = RegExp(r'^[\p{L}\s]+$', unicode: true);
    if (!fullNameRegex.hasMatch(fullName)) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  static String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return 'Phone number cannot be empty';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

}