import 'dart:async';

import 'package:flutter_delivery/core/service/socket_service.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_error.dart';

class SocketServiceErrorImpl implements SocketServiceError {
  final SocketService _socketService;
  final StreamController<String> orderStreamController = StreamController();

  SocketServiceErrorImpl(this._socketService);
  @override
  Stream<String> serverErrorResponse() {
    _socketService.listenToEvent(
        "message", (data) => orderStreamController.add(data));
    return orderStreamController.stream;
  }

  @override
  void close() {
    orderStreamController.close();
  }
}
