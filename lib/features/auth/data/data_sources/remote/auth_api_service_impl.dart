import 'package:dio/dio.dart';
import 'package:flutter_delivery/core/constants/constants.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:flutter_delivery/features/auth/data/models/user_model.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';

class AuthApiServiceImpl implements AuthApiService {
  final String _baseUrl;
  final Dio _dio;

  AuthApiServiceImpl(this._baseUrl, this._dio);

  @override
  Future<UserModel> loginApi(String email, String password) async {
    try {
      Map<String, dynamic> body = {
        "action": "token",
        "auth": {
          "email": email,
          "password": password,
        }
      };
      final response = await _dio.post(_baseUrl, data: body);
      if (!response.data["result"]["error"]) {
        String token = response.data["result"]["message"];
        UserModel temp = UserModel.fromMap(response.data["user"], token);
        return temp;
      } else {
        throw StateException(
          message: response.data["message"],
        );
      }
    } on DioException catch (e) {
      throw StateException(message: stateExceptionBadResponseMessage, error: e);
    }
  }

  @override
  Future<String> registerApi(RegisterUseCaseParams newUser) async {
    try {
      Map<String, dynamic> body = {
        "action": "reg",
        "reg": {
          "userName": newUser.userName,
          "email": newUser.email,
          "password": newUser.password,
          "type": newUser.type.name
        }
      };

      final response = await _dio.post(_baseUrl, data: body);
      if (!response.data["error"]) {
        return response.data["message"];
      } else {
        throw StateException(
          message: response.data["message"],
        );
      }
    } on DioException catch (e) {
      throw StateException(message: stateExceptionBadResponseMessage, error: e);
    }
  }

  @override
  Future<UserModel> tokenCheckerApi(String token) async {
    try {
      Map<String, dynamic> body = {
        "action": "auth",
        "token": {"bearer": "SXYJWYXAC42QVR235UMNA26TLU"}
      };

      final response = await _dio.post(_baseUrl, data: body);
      if (response.data["exist"]) {
        return UserModel.fromMap(response.data["user"], token);
      } else {
        throw StateException(
          message: noUserFound,
        );
      }
    } on DioException catch (e) {
      throw StateException(message: stateExceptionBadResponseMessage, error: e);
    }
  }
}
