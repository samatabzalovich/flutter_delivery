import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class ServerErrorUseCase implements StreamUseCase<String, void> {
  final DriverRepository _driverRepository;

  ServerErrorUseCase(this._driverRepository);
  @override
  Stream<String> call({void params}) {
    return _driverRepository.serverErrorResponse();
  }
}