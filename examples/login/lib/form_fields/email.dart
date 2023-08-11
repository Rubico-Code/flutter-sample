import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalidFormat }

final RegExp emailRegEx = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!emailRegEx.hasMatch(value)) {
      return EmailValidationError.invalidFormat;
    }
    return null;
  }

  String? get errorText {
    if (isValid) {
      return null;
    }
    if (displayError == EmailValidationError.empty) {
      return '* Required';
    } else if (displayError == EmailValidationError.invalidFormat) {
      return 'Invalid Email format';
    }
    return null;
  }
}
