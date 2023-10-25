import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';

class LogInUseCase implements UseCase<DataState<UserEntity>, LoginUsecaseParams> {
  final AuthRepository _authRepository;

  LogInUseCase(this._authRepository);
  
  @override
  Future<DataState<UserEntity>> call({LoginUsecaseParams? params}) {
    return _authRepository.logIn(params!);
  }
  
  
}

class LoginUsecaseParams {
  final String email;
  final String password;

  LoginUsecaseParams({required this.email, required this.password});
}