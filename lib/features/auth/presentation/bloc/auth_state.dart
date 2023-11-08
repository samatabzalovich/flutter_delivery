// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/features/auth/domain/entity/user_entity.dart';

abstract class AuthState extends Equatable {
  final UserEntity? user;
  final StateException? error;
  final String? successStateMessage;
  const AuthState({
    this.user,
    this.error,
    this.successStateMessage
  });
  @override
  List<Object?> get props => [user!, error!];
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoggedInState extends AuthState {
  const AuthLoggedInState({
    required UserEntity user,
  }) : super(user: user);
}

class AuthErrorState extends AuthState {
  const AuthErrorState(StateException error) : super(error: error);
}

class AuthRegisteredSuccessfullyState extends AuthState {
  const AuthRegisteredSuccessfullyState({required String message}) : super(successStateMessage: message);
}

class AuthLoggedOutState extends AuthState {
  const AuthLoggedOutState();
}
