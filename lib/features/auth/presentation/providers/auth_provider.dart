
import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository.impl.dart';



final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(
    authRepository: authRepository
  );
});


class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepositoryImpl authRepository;

  
  AuthNotifier({
    required this.authRepository
  }): super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);

    } on  CustomError catch(e){
      logout(errorMessage: e.message);
    } catch (e){
      logout(errorMessage: 'Error inesperado');
    }


    /* final user = await authRepository.login(email, password);
    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user
    ); */
    
  }

  Future<void> registerUser(String email, String password, String fullName) async {
    try {
      
    } catch (e) {
      
    }
  }

  Future<void> checkAuthStatus(String token) async {
    try {
      
    } catch (e) {
      
    }
  }

  _setLoggedUser(User user){
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: ''
    );
  }


  Future<void> logout( {String? errorMessage}) async {
    state = state.copyWith(
      authStatus: AuthStatus.unauthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }


}


enum AuthStatus {
  checking,
  authenticated,
  unauthenticated,
  error
}

class AuthState {
  final AuthStatus authStatus;
  final User? user; 
  final String? errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage
  );
}

