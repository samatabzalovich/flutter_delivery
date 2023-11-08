import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class InitializeUseCase implements UseCase<void, String> {
  final DriverRepository _driverRepository;

  InitializeUseCase(this._driverRepository);
  @override
  Future<void> call({String? params}) {
    return _driverRepository.initializeSocket(params!);
  }
}


