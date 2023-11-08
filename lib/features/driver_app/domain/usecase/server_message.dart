import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class ServerMessageUseCase implements StreamUseCase<String, void> {
  final DriverRepository _driverRepository;

  ServerMessageUseCase(this._driverRepository);
  @override
  Stream<String> call({void params}) {
    return _driverRepository.serverMessageResponse();
  }
}