import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class CloseErrorStreamUseCase {
  final DriverRepository _driverRepository;
  CloseErrorStreamUseCase(this._driverRepository);
  void call() {
    _driverRepository.closeErrorStream();
  }
}