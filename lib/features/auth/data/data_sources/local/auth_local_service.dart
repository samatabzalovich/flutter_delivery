import 'package:flutter_delivery/core/resources/data_state.dart';

abstract class AuthLocalService {
  Future<DataState<String>> getToken();
  Future<void> setToken(String token);
}
