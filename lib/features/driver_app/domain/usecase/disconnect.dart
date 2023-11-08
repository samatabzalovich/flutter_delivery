
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class DisconnectUsecase implements UseCase<void, void> {
  final DriverRepository _driverRepository;

  DisconnectUsecase(this._driverRepository);

  @override
  Future<void> call({void params}) {
    return _driverRepository.disconnect();
  }
}