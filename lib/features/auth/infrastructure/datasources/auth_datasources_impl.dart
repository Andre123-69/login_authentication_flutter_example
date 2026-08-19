

import 'package:dio/dio.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastructure/infraestructure.dart';
class AuthDatasourcesImpl implements AuthDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });
      
      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    } on DioException catch (e) {
      if(e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Credenciales no son correctas');
      }
      if(e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Tiempo de espera expirado');
      }
      throw Exception();
    }catch (e){
      throw CustomError('Error inesperado $e');
    }
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