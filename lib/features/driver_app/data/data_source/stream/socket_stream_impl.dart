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
    _socketService.listenToEvent('order-event', (data) {
      Map orderMap = data;
      if(orderMap.isNotEmpty) {
        final order = OrderModel.fromMap(data);
        orderStreamController.sink.add(order);
      }
    });
    return orderStreamController.stream;
  }

  @override
  void close() {
    orderStreamController.close();
  }
}
