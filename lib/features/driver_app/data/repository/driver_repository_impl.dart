// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/emit_to_socket/socket_api.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/remote/google_maps_api.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_message.dart';
import 'package:flutter_delivery/features/driver_app/data/data_source/stream/socket_stream_api.dart';
import 'package:flutter_delivery/features/driver_app/data/models/order_model.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';

class DriverRepositoryImpl implements DriverRepository {
  final SocketApiService _socketApiService;
  final SocketStreamApiService _streamSocketApi;
  final SocketServiceMessage _streamErrorApi;
  final GoogleMapsApiService _googleMapsApiService;
  DriverRepositoryImpl(
    this._socketApiService,
    this._streamSocketApi,
    this._streamErrorApi,
    this._googleMapsApiService,
  );

  @override
  Future<void> acceptOrder(OrderEntity entity) async {
    _socketApiService.acceptOrder(OrderModel.fromEntity(entity));
  }

  @override
  Future<void> completeOrder(String code) async {
    _socketApiService.completeOrder(code);
  }

  @override
  Future<void> disconnect() async {
    _socketApiService.disconnect();
  }

  @override
  Future<void> initializeSocket(String token) async {
    _socketApiService.initializeSocket(token);
  }

  @override
  Future<void> onLine(DeliveryUseCaseParams locationData) async {
    _socketApiService.onLine(locationData);
  }

  @override
  Future<void> pickOrder(OrderEntity entity) async {
    _socketApiService.pickOrder(OrderModel.fromEntity(entity));
  }

  @override
  Stream<OrderEntity> streamOrder() {
    return _streamSocketApi.streamOrder();
  }

  @override
  Future<void> sendLocation(DeliveryUseCaseParams locationData) async {
    _socketApiService.sendLocation(locationData);
  }

  @override
  Stream<String> serverMessageResponse() {
    return _streamErrorApi.serverMessageResponse();
  }

  @override
  void closeErrorStream() {
    _streamErrorApi.close();
  }

  @override
  void closeRequestStream() {
    _streamSocketApi.close();
  }

  @override
  Future<DataState<PolylineUseCaseResult>> getPolyline(
      PolylineUseCaseParams location) async {
    return await _googleMapsApiService.getPolyLine(location);
  }

  @override
  Future<void> offLine() async {
    _socketApiService.offLine();
  }
}
