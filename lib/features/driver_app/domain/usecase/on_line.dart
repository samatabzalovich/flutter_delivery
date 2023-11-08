import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class OnLineUseCase implements UseCase<void, DeliveryUseCaseParams> {
  final DriverRepository _driverRepository;

  OnLineUseCase(this._driverRepository);

  @override
  Future<void> call({DeliveryUseCaseParams? params}) {
    return _driverRepository.onLine(params!);
  }
}