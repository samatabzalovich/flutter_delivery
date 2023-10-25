import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';

class SetTokenUseCase implements UseCase<void, String> {
  final AuthRepository _authRepository;

  SetTokenUseCase(this._authRepository);

  @override
  Future<void> call({String? params}) {
    return _authRepository.setToken(params!);
  }
}