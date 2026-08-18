
import 'package:teslo_shop/features/shared/shared.dart';



//! 1 - State del provider

class LoginFormState {
  final Email email;
  final Password password;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  LoginFormState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
  });
  
  LoginFormState copyWith({
    Email? email,
    Password? password,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
  }) => LoginFormState(
    email: email ?? this.email,
    password: password ?? this.password,
    isPosting: isPosting ?? this.isPosting,
  );
}