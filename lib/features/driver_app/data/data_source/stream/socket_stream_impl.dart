import 'dart:async';

import 'package:flutter_delivery/core/service/socket_service.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_stream_api.dart';
import 'package:flutter_delivery/features/driver_app/data/models/order_model.dart';

class SocketStreamApiServiceImpl implements SocketStreamApiService {
  final SocketService _socketService;
  final StreamController<OrderModel> orderStreamController = StreamController();

  SocketStreamApiServiceImpl(this._socketService);

  @override
  Stream<OrderModel> streamOrder() {
    // Listen to the 'order' event from the server
    _socketService.listenToEvent('order', (data) {
      final order = OrderModel.fromMap(data);
      orderStreamController.add(order);
    });
    return orderStreamController.stream;
  }

  @override
  void close() {
    orderStreamController.close();
  }
}
