

import 'package:teslo_shop/features/auth/domain/domain.dart';

class AuthDatasourcesImpl implements AuthDatasource {

  @override
  Future<User> login(String email, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    throw UnimplementedError();
  }

  @override
  Future<User> checkStatus(String token) async {
    throw UnimplementedError();
  }

}