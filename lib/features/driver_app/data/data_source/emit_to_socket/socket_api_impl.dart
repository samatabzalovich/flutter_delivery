// ignore: library_prefixes
import 'dart:async';

import 'package:flutter_delivery/core/service/socket_service.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/emit_to_socket/socket_api.dart';
import 'package:flutter_delivery/features/driver_app/data/models/order_model.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class SocketApiServiceImpl implements SocketApiService {
  final SocketService _socketService;
  final StreamController<OrderModel> orderStreamController = StreamController();
  // TODO: implement dispose method for orderStreamController
  SocketApiServiceImpl(this._socketService);

  @override
  Future<void> initializeSocket(String token) async {
    _socketService.initializeSocket(token);
  }

  

  @override
  Future<void> acceptOrder(OrderModel entity) async {
    _socketService.emitEvent("acceptOrder", entity.toMap());
  }

  @override
  Future<void> completeOrder(OrderModel entity) async {
    _socketService.emitEvent("completeOrder", entity.toMap());
  }

  @override
  Future<void> disconnect() async {
    _socketService.disconnect();
  }

  @override
  Future<void> onLine(DeliveryUseCaseParams locationData) async {
    _socketService.emitEvent("onLine", locationData.toMap());
  }

  @override
  Future<void> pickOrder(OrderModel entity) async {
    _socketService.emitEvent("pickOrder", entity.toMap());
  }

  @override
  Future<void> sendLocation(DeliveryUseCaseParams locationData) async {
    _socketService.emitEvent("deliveryLocation", locationData.toMap());
  }
}

