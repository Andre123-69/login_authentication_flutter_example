import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera
final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onFullNameChanged(String value) {
    final newFullName = FullName.dirty(value);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([
        newFullName,
        state.email,
        state.password,
        state.repeatPassword,
      ]),
    );
  }

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([
        state.fullName,
        newEmail,
        state.password,
        state.repeatPassword,
      ]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    final newRepeatPassword = RepeatPassword.dirty(
      originalPassword: newPassword.value,
      value: state.repeatPassword.value,
    );
    state = state.copyWith(
      password: newPassword,
      repeatPassword: newRepeatPassword,
      isValid: Formz.validate([
        state.fullName,
        state.email,
        newPassword,
        newRepeatPassword,
      ]),
    );
  }

  onRepeatPasswordChanged(String value) {
    final newRepeatPassword = RepeatPassword.dirty(
      originalPassword: state.password.value,
      value: value,
    );
    state = state.copyWith(
      repeatPassword: newRepeatPassword,
      isValid: Formz.validate([
        state.fullName,
        state.email,
        state.password,
        newRepeatPassword,
      ]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await registerUserCallback(
      state.email.value,
      state.password.value,
      state.fullName.value,
    );

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final repeatPassword = RepeatPassword.dirty(
      originalPassword: password.value,
      value: state.repeatPassword.value,
    );

    state = state.copyWith(
      isFormPosted: true,
      fullName: fullName,
      email: email,
      password: password,
      repeatPassword: repeatPassword,
      isValid: Formz.validate([fullName, email, password, repeatPassword]),
    );
  }

  void resetForm() {
    state = RegisterFormState();
  }
}

//! 1 - State del provider
class RegisterFormState {
  final FullName fullName;
  final Email email;
  final Password password;
  final RepeatPassword repeatPassword;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  RegisterFormState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
  });

  @override
  String toString() {
    return '''
    RegisterFormState
      fullName: $fullName,
      email: $email,
      password: $password,
      repeatPassword: $repeatPassword,
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid
    ''';
  }

  RegisterFormState copyWith({
    FullName? fullName,
    Email? email,
    Password? password,
    RepeatPassword? repeatPassword,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
  }) =>
      RegisterFormState(
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
      );
}
