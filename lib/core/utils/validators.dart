class Validators {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Additional checks for common invalid patterns
    if (email.contains('..') ||
        email.contains(' ') ||
        email.startsWith('@') ||
        email.endsWith('@') ||
        !email.contains('@')) {
      return false;
    }

    // Check for valid domain structure
    final parts = email.split('@');
    if (parts.length != 2) return false;

    final localPart = parts[0];
    final domain = parts[1];

    // Local part cannot start or end with dot
    if (localPart.startsWith('.') || localPart.endsWith('.')) {
      return false;
    }

    if (domain.startsWith('.') ||
        domain.endsWith('.') ||
        domain.contains('..') ||
        domain.length < 3) {
      return false;
    }

    return emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if (password.length < 8) return false;

    // Must contain at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) return false;

    // Must contain at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) return false;

    // Must contain at least one number
    if (!password.contains(RegExp(r'[0-9]'))) return false;

    // Must contain at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;

    return true;
  }

  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;

    // Remove spaces, dots, and dashes for validation
    final cleanPhone = phone.replaceAll(RegExp(r'[\s.-]'), '');

    // Check for valid international format
    if (cleanPhone.startsWith('+')) {
      final phoneRegExp = RegExp(r'^\+\d{10,15}$');
      return phoneRegExp.hasMatch(cleanPhone);
    }

    // Check for valid national format (10 digits)
    final nationalRegExp = RegExp(r'^\d{10}$');
    return nationalRegExp.hasMatch(cleanPhone);
  }

  static bool isValidName(String name) {
    if (name.isEmpty || name.trim().isEmpty) return false;
    if (name.length < 2) return false;
    if (name.length > 50) return false;

    // Check for invalid characters - allow letters, spaces, apostrophes, hyphens, dots
    // Extended unicode support for international names
    final nameRegExp = RegExp(r"^[\p{L}\s'\.\-]+$", unicode: true);
    if (!nameRegExp.hasMatch(name)) return false;

    // Check for multiple consecutive spaces
    if (name.contains('  ')) return false;

    // Check for leading or trailing spaces
    if (name.startsWith(' ') || name.endsWith(' ')) return false;

    return true;
  }

  static bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }

  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }
}
