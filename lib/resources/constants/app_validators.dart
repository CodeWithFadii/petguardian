class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters.';
    }
    return _validatePasswordComplexity(value);
  }

  static String? validateCurrentPassword(String? value, String? password) {
    if (value != password) {
      return 'Incorrect password.';
    }
    return null;
  }

  static String? validateNewPassword(String? value, String? currentPassword) {
    if (value == null || value.isEmpty) {
      return 'New password is required.';
    }
    if (value == currentPassword) {
      return 'Password must be different from the current password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return _validatePasswordComplexity(value);
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required.';
    }
    if (value != password) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static String? _validatePasswordComplexity(String value) {
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasLetter) return 'Password must contain at least one letter.';
    if (!hasNumber) return 'Password must contain at least one number.';
    if (!hasSpecialCharacter) return 'Password must contain at least one special character.';

    return null;
  }

  static String? validateWordCount(String input) {
    final wordCount = input.trim().split(RegExp(r'\s+')).length;
    if (wordCount < 20) {
      return 'Too short: minimum 20 words required.';
    }
    return null;
  }

  static String? validateCertificateField({
    required String? certificateName,
    required String? organizationName,
    required String? issueYear,
    required String fieldName,
  }) {
    final hasAnyField =
        (certificateName?.trim().isNotEmpty ?? false) ||
        (organizationName?.trim().isNotEmpty ?? false) ||
        (issueYear?.trim().isNotEmpty ?? false);

    if (hasAnyField) {
      if (fieldName == 'certificateName' && (certificateName?.trim().isEmpty ?? true)) {
        return 'Certificate name is required.';
      }
      if (fieldName == 'organizationName' && (organizationName?.trim().isEmpty ?? true)) {
        return 'Organization name is required.';
      }
      if (fieldName == 'issueYear' && (issueYear?.trim().isEmpty ?? true)) {
        return 'Issue year is required.';
      }
    }

    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  static String? validateAlphabetic(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value)) {
      return '$fieldName can only contain letters and spaces.';
    }
    return null;
  }

  static String? validateName(String? value) => validateAlphabetic(value, 'Name');
  static String? validateValue(String? value, String name) {
    if (value == null || value.isEmpty) {
      return '$name is required.';
    }
    return null;
  }

  static String? validateLastName(String? value) => validateAlphabetic(value, 'Last name');

  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    final numericRegex = RegExp(r'^\d+$');
    if (!numericRegex.hasMatch(value)) {
      return '$fieldName must contain only numbers.';
    }
    return null;
  }
}
