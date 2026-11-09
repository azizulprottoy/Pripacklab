final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
final RegExp _bdPhoneRegex = RegExp(r'^(?:\+?880|0)1[3-9]\d{8}$');

bool isValidEmail(String? email) {
  if (email == null) return false;
  return _emailRegex.hasMatch(email.trim());
}

bool isValidPhone(String? phone) {
  if (phone == null) return false;
  return _bdPhoneRegex.hasMatch(phone.trim());
}

String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!isValidEmail(value)) return 'Please enter a valid email address';
  return null;
}

String? phoneValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Phone is required';
  if (!isValidPhone(value)) {
    return 'Please enter a valid Bangladeshi phone number (e.g. 01XXXXXXXXX)';
  }
  return null;
}

String? requiredValidator(String? value, [String label = 'This field']) {
  if (value == null || value.trim().isEmpty) return '$label is required';
  return null;
}
