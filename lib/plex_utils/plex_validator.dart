/// Validator utilities for form fields.
class PlexValidator {
  PlexValidator._();

  /// Returns a validator that requires non-empty input.
  static String? Function(String?) required({String? message}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  /// Returns a validator that checks email format.
  static String? Function(String?) email({String? message}) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      if (!emailRegex.hasMatch(value.trim())) {
        return message ?? 'Please enter a valid email address';
      }
      return null;
    };
  }

  /// Returns a validator that enforces minimum length.
  static String? Function(String?) minLength(int n, {String? message}) {
    return (value) {
      if (value == null) return null;
      if (value.length < n) {
        return message ?? 'Must be at least $n characters';
      }
      return null;
    };
  }

  /// Returns a validator that enforces maximum length.
  static String? Function(String?) maxLength(int n, {String? message}) {
    return (value) {
      if (value == null) return null;
      if (value.length > n) {
        return message ?? 'Must be at most $n characters';
      }
      return null;
    };
  }

  /// Returns a validator that checks against a regex pattern.
  static String? Function(String?) pattern(RegExp regex, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Composes multiple validators; returns first non-null error.
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final v in validators) {
        final err = v(value);
        if (err != null) return err;
      }
      return null;
    };
  }
}
