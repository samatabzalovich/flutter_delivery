// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_delivery/core/enum/user_enums.dart';
import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase
    implements UseCase<DataState<String>, RegisterUseCaseParams> {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  @override
  Future<DataState<String>> call({RegisterUseCaseParams? params}) {
    return _authRepository.register(params!);
  }
}

class RegisterUseCaseParams {
  final String email;
  final String password;
  final String userName;
  final UserType type;
  RegisterUseCaseParams({
    required this.email,
    required this.password,
    required this.userName,
    required this.type,
  });
}
