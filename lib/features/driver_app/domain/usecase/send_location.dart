import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class SendLocationUseCase implements UseCase<void, DeliveryUseCaseParams> {
  final DriverRepository _driverRepository;

  SendLocationUseCase(this._driverRepository);

  @override
  Future<void> call({DeliveryUseCaseParams? params}) {
    return _driverRepository.sendLocation(params!);
  }
}
