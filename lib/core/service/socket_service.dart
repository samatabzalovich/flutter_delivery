// ignore: library_prefixes
import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String _serverUrl;
  late IO.Socket _socket;
  SocketService(this._serverUrl);

  void initializeSocket(String token) {
    _socket = IO.io(
        _serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"token": token})
            .disableAutoConnect()
            .enableReconnection()
            .build());
    _socket.connect();
    
  }

  void emitEvent(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void listenToEvent(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void disconnect() {
    _socket.disconnect();
  }
}
