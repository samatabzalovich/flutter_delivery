import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/log_in.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';

abstract class AuthRepository {
  Future<DataState<UserEntity>> logIn(LoginUsecaseParams params);
  Future<DataState<String>> register(RegisterUseCaseParams params);
  Future<DataState<UserEntity>> checkUserToken(String token);
  Future<DataState<String>> getToken();
    Future<void> setToken(String token);
  Future<bool> logOut();
}
