
import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';


//! 3 - StateNotifierProvider - consume afuera
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});


class LoginFormNotifier extends StateNotifier<LoginFormState> {
  
  LoginFormNotifier():super(
    LoginFormState()
  );

  onEmailChanged( String value ) {
    final newEmail = Email.dirty(value);
    
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChanged( String value ) {
    final newPassword = Password.dirty(value);
    
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.email, newPassword]),
    );
  }

  onFormSubmit() {

    _touchEveryField();
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    
    state = state.copyWith(
      email: email,
      password: password,
      isFormPosted: true,
      isValid: Formz.validate([email, password]),
    );

    if( !state.isValid ) return;

    print(state);
  }
  
}


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

  @override
  String toString() {
    return '''
    LoginFormState
      email: $email,
      password: $password,
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid
    ''';
    
  }
  
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
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
  );
}

//! 2 - Como implementamos un notifier





