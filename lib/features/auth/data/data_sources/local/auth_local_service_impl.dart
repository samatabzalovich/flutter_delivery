import 'package:flutter_delivery/core/constants/constants.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/core/local/shared_preference.dart';
import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/features/auth/data/data_sources/local/auth_local_service.dart';

class AuthLocalServiceImpl implements AuthLocalService {
  @override
  Future<DataState<String>> getToken() async {
    String? tokenData =
        PreferenceHelper.getDataFromSharedPreference(key: "token");
    if (tokenData != null) {
      return DataSuccess(tokenData);
    } else {
      return DataFailed(StateException(message: noUserFound));
    }
  }

  @override
  Future<void> setToken(String token) async {
    await PreferenceHelper.saveDataInSharedPreference(
        key: "token", value: token);
  }
}
