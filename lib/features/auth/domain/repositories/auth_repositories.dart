import 'package:teslo_shop/features/auth/domain/entities/uder.dart';

abstract class AuthRepository {

  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<User> checkStatus(String token);

}