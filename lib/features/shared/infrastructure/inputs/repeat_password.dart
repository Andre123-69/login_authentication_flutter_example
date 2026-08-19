import 'package:formz/formz.dart';

// Define input validation errors
enum RepeatPasswordError { empty, mismatch }

// Extend FormzInput and provide the input type and error type.
class RepeatPassword extends FormzInput<String, RepeatPasswordError> {
  final String originalPassword;

  // Call super.pure to represent an unmodified form input.
  const RepeatPassword.pure({this.originalPassword = ''}) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const RepeatPassword.dirty({required this.originalPassword, String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == RepeatPasswordError.empty ) return 'El campo es requerido';
    if ( displayError == RepeatPasswordError.mismatch ) return 'Las contraseñas no coinciden';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  RepeatPasswordError? validator(String value) {
    if ( value.isEmpty || value.trim().isEmpty ) return RepeatPasswordError.empty;
    if ( value != originalPassword ) return RepeatPasswordError.mismatch;

    return null;
  }
}
