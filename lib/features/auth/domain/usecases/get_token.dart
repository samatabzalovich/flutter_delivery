import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';

class GetTokenUseCase implements UseCase<DataState<String>, void> {
  final AuthRepository _authRepository;

  GetTokenUseCase(this._authRepository);
  
  @override
  Future<DataState<String>> call({void params}) {
    return _authRepository.getToken();
  }

  
}
