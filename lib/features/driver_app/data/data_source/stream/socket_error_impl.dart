import 'dart:async';

import 'package:flutter_delivery/core/service/socket_service.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_message.dart';

class SocketServiceErrorImpl implements SocketServiceMessage {
  final SocketService _socketService;
  final StreamController<String> orderStreamController = StreamController();

  SocketServiceErrorImpl(this._socketService);
  @override
  Stream<String> serverMessageResponse() {
    _socketService.listenToEvent(
        "message", (data) => orderStreamController.sink.add(data));
    return orderStreamController.stream;
  }

  @override
  void close() {
    orderStreamController.close();
  }
}
