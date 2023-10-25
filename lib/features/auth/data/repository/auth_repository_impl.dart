import 'package:flutter/foundation.dart';
import 'package:flutter_delivery/core/constants/constants.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:flutter_delivery/features/auth/data/models/user_model.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/log_in.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _auth;
  final AuthLocalService _localStorage;

  AuthRepositoryImpl(this._auth, this._localStorage);

  @override
  Future<DataState<UserModel>> checkUserToken(String token) async {
    try {
      if (token.isNotEmpty) {
        final response = await _auth.tokenCheckerApi(token);
        return DataSuccess(response);
      } else {
        return DataFailed(StateException(message: noUserFound));
      }
    } on StateException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<UserModel>> logIn(LoginUsecaseParams params) async {
    try {
      final response = await _auth.loginApi(params.email, params.password);
      return DataSuccess(response);
    } on StateException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<bool> logOut() async {
    if (kDebugMode) {
      print("log out implementation is not received");
    }
    Future.delayed(const Duration(seconds: 1));
    return false;
  }

  @override
  Future<DataState<String>> register(RegisterUseCaseParams params) async {
    try {
      final response = await _auth.registerApi(params);
      return DataSuccess(response);
    } on StateException catch (e) {
      return DataFailed(e);
    }
  }

  
  @override
  Future<void> setToken(String token) {
        return _localStorage.setToken(token);

  }
  
  @override
  Future<DataState<String>> getToken() {
    return _localStorage.getToken();
  }
}
