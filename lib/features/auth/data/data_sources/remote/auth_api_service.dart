import 'package:flutter_delivery/features/auth/data/models/user_model.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';

abstract class AuthApiService {
  Future<UserModel> tokenCheckerApi(String token);
  Future<UserModel> loginApi(String email, String password);
  Future<String> registerApi(RegisterUseCaseParams newUser);
}
