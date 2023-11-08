import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class StreamOrderUseCase implements StreamUseCase<OrderEntity, void> {
  final DriverRepository _driverRepository;

  StreamOrderUseCase(this._driverRepository);
  @override
  Stream<OrderEntity> call({void params}) {
    return _driverRepository.streamOrder();
  }
}
