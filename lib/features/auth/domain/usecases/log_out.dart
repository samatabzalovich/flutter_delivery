import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase implements UseCase<bool, void> {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  @override
  Future<bool> call({void params}) {
    return _authRepository.logOut();
  }
}
