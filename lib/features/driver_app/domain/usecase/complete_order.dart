
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class CompleteOrderUseCase implements UseCase<void, OrderEntity> {
  final DriverRepository _driverRepository;

  CompleteOrderUseCase(this._driverRepository);

  @override
  Future<void> call({OrderEntity? params}) {
    return _driverRepository.completeOrder(params!);
  }
}