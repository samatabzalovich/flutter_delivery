import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class CloseSocketStreamUseCase {
  final DriverRepository _driverRepository;

  CloseSocketStreamUseCase(this._driverRepository);
  void call() {
    _driverRepository.closeRequestStream();
  }
}
