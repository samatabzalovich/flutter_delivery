import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class OffLineUseCase implements UseCase<void, void> {
  final DriverRepository _driverRepository;

  OffLineUseCase(this._driverRepository);

  @override
  Future<void> call({void params }) {
    return _driverRepository.offLine();
  }
}