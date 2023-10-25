// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/log_in.dart';

import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';

abstract class AuthEvent extends Equatable {
  final RegisterUseCaseParams? newUser;
  final LoginUsecaseParams? loginField;
  const AuthEvent({
    this.loginField,
    this.newUser,
  });

  @override
  List<Object> get props => [newUser!, loginField!];
}

class AuthRegisterEvent extends AuthEvent {
  const AuthRegisterEvent(RegisterUseCaseParams newUser)
      : super(newUser: newUser);
}

class AuthLoginEvent extends AuthEvent {
  const AuthLoginEvent(LoginUsecaseParams loginField)
      : super(loginField: loginField);
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthCheckTokenEvent extends AuthEvent {
  const AuthCheckTokenEvent();
}

// class AuthForgotPasswordEvent extends AuthEvent {
//   const AuthForgotPasswordEvent();
// }
