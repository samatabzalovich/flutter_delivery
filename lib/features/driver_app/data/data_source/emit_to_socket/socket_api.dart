import 'dart:async';

import 'package:flutter_delivery/features/driver_app/data/models/order_model.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

abstract class SocketApiService {
  Future<void> initializeSocket(String token);
  Future<void> sendLocation(DeliveryUseCaseParams locationData);
  Future<void> onLine(DeliveryUseCaseParams locationData);
  Future<void> acceptOrder(OrderModel entity);
  Future<void> pickOrder(OrderModel entity);
  Future<void> completeOrder(String code);
  Future<void> offLine();
  Future<void> disconnect();
}
