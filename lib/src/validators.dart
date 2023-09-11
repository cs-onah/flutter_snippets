import 'string_extension.dart';

/// Class of validation functions that the app will use
///   - This class should be used as a mixin using the `with` keyword
mixin Validators {
  get phoneNumberRegExp => RegExp(
      r'^([0-9]( |-)?)?(\(?[0-9]{3}\)?|[0-9]{3})( |-)?([0-9]{3}( |-)?[0-9]{4}|[a-zA-Z0-9]{7})$');
  get emailRegExp =>
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  get zipCodeRegExp => RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');
  get alphanumericRegExp => RegExp(r'^[a-zA-Z][a-zA-Z0-9]*[a-zA-Z0-9]$');
  get alphanumericWithSpaceRegExp =>
      RegExp(r'^[a-zA-Z][a-zA-Z0-9\s]*[a-zA-Z0-9]$');
  get priceRegExp => RegExp('[0-9.,]');
  
  String? validateEmail(String? value) {
    if (!emailRegExp.hasMatch(value.nullToEmpty.trim())) {
      return 'Invalid email';
    }
    return null;
  }

  String? validateField(String? value) {
    if (value.nullToEmpty.length < 3) {
      return 'Entry is too short';
    }
    return null;
  }

  String? validateInput(String? value) {
    if (value.isEmptyOrNull) {
      return 'Field can not null';
    }
    return null;
  }
  String? validateSelectItem(Object? value, String text) {
    if (value == null) {
      return text;
    }
    return null;
  }

  String? validateName(String? value) {
    if (value.nullToEmpty.length < 3) {
      return 'Entry is too short';
    }
    if (!alphanumericRegExp.hasMatch(value.nullToEmpty.trim())) {
      return 'Entry can not start with number';
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value.nullToEmpty.length < 3) {
      return 'Entry is too short';
    }
    if (!alphanumericWithSpaceRegExp.hasMatch(value.nullToEmpty.trim())) {
      return 'Entry can not start with number';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    value = value.nullToEmpty;
    if (value.startsWith('+234')) {
      if (value.length == 14) return null;
    }

    if (!phoneNumberRegExp.hasMatch(value.trim())) {
      return 'Invalid phone number';
    }
    return null;
  }
  String? validatePrice(String? value) {
    value = value.nullToEmpty;
    if (!priceRegExp.hasMatch(value.trim())) {
      return 'Invalid price';
    }
    return null;
  }

  String? validateComment(String? value) {
    value = value.nullToEmpty;
    if (value.isEmpty) return "Invalid comment";
    return null;
  }

  String? validateZip(String? value) {
    value = value.nullToEmpty;
    if (!zipCodeRegExp.hasMatch(value.trim())) {
      return 'invalid zip code';
    }
    return null;
  }

  String? validatePassword(String? value) {
    value = value.nullToEmpty;
    if (value.trim().isEmpty) {
      return 'password field cannot be empty';
    } else if (value.length < 8) {
      return 'Must at least be 8 characters';
    }
    return null;
  }

  String? validateCard(String input) {
    if (input.isEmpty) {
      return "Please enter a credit card number";
    }

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return "You entered an invalid credit card number";
  }
}
