import 'package:formz/formz.dart';

enum BirthdayValidationError {
  required('Geburtstag darf nicht leer sein.'),
  invalid('Das Geburtstag ist ungültig.');

  final String message;
  const BirthdayValidationError(this.message);
}

class BirthDay extends FormzInput<String, BirthdayValidationError> {
  const BirthDay.pure() : super.pure('');
  const BirthDay.dirty([String value = '']) : super.dirty(value);

  static final _birthdayRegex =
  RegExp(r"^(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[0-2])\.\d{4}$");


  @override
  BirthdayValidationError? validator(String value) {
    return value.isEmpty
        ? BirthdayValidationError.required
        : _birthdayRegex.hasMatch(value)
        ? null
        : BirthdayValidationError.invalid;
  }
}