
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class PickOrderUseCase implements UseCase<void, OrderEntity> {
  final DriverRepository _driverRepository;

  PickOrderUseCase(this._driverRepository);

  @override
  Future<void> call({OrderEntity? params}) {
    return _driverRepository.pickOrder(params!);
  }
}