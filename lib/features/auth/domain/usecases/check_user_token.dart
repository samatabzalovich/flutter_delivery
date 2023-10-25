import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_delivery/features/auth/domain/repository/auth_repository.dart';

class CheckUserTokenUseCase implements UseCase<DataState<UserEntity>, String> {
  final AuthRepository _authRepository;

  CheckUserTokenUseCase(this._authRepository);

  @override
  Future<DataState<UserEntity>> call({String? params}) {
    return _authRepository.checkUserToken(params!);
  }
}


