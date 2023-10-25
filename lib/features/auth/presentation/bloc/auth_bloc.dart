import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_delivery/core/constants/constants.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';

import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/check_user_token.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/get_token.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/log_in.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/log_out.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/set_token.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckUserTokenUseCase _checkUserTokenUseCase;
  final LogInUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetTokenUseCase _getTokenUseCase;
  final SetTokenUseCase _setTokenUseCase;
  AuthBloc(
    this._checkUserTokenUseCase,
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getTokenUseCase,
    this._setTokenUseCase,
  ) : super(const AuthLoadingState()) {
    on<AuthRegisterEvent>(onRegister);
    on<AuthLoginEvent>(onLogin);
    on<AuthCheckTokenEvent>(onInit);
    on<AuthLogoutEvent>(onLogout);
  }
  void onInit(AuthCheckTokenEvent event, Emitter<AuthState> emit) async {
    final tokenDataState = await _getTokenUseCase.call();

    if (tokenDataState is DataFailed) {
      emit(
        const AuthLoggedOutState(),
      );
    } else {
      final dataState =
          await _checkUserTokenUseCase.call(params: tokenDataState.data!);
      if (dataState is DataSuccess && dataState.data != null) {
        emit(AuthLoggedInState(user: dataState.data!));
      }
      if (dataState is DataFailed) {
        if (dataState.error != null &&
            dataState.error!.message == noUserFound) {
          emit(
            const AuthLoggedOutState(),
          );
        }
        emit(
          AuthErrorState(dataState.error!),
        );
      }
    }
  }

  void onRegister(AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    final dataState = await _registerUseCase.call(params: event.newUser);
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(
        AuthRegisteredSuccessfullyState(message: dataState.data!),
      );
    }
    if (dataState is DataFailed) {
      emit(
        AuthErrorState(dataState.error!),
      );
    }
  }

  void onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    final dataState = await _loginUseCase.call(params: event.loginField);
    if (dataState is DataSuccess && dataState.data != null) {
      await _setTokenUseCase.call(params: dataState.data!.token);
      emit(
        AuthLoggedInState(user: dataState.data!),
      );
    }
    if (dataState is DataFailed) {
      emit(
        AuthErrorState(dataState.error!),
      );
    }
  }

  void onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    final bool isLoggedOut = await _logoutUseCase.call();
    if (isLoggedOut) {
      emit(const AuthLoggedOutState());
    } else {
      emit(AuthErrorState(StateException(message: "failed log out")));
    }
  }
}
