// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';

abstract class DriverRepository {
  Future<void> initializeSocket(String token);
  Future<void> sendLocation(DeliveryUseCaseParams locationData);
  Future<void> onLine(DeliveryUseCaseParams locationData);
  Future<void> offLine();
  Future<DataState<PolylineUseCaseResult>> getPolyline(
      PolylineUseCaseParams location);
  Future<void> acceptOrder(OrderEntity entity);
  Future<void> pickOrder(OrderEntity entity);
  Future<void> completeOrder(String code);
  Future<void> disconnect();
  Stream<OrderEntity> streamOrder();
  Stream<String> serverMessageResponse();
  void closeRequestStream();
  void closeErrorStream();
}

class DeliveryUseCaseParams {
  final String? from;
  final String? to;
  final String? orderID;
  final LocationEntity location;
  final bool isPolylineUpdated;
  final Polylines? polylines;
  DeliveryUseCaseParams({
    this.from,
    this.to,
    this.orderID,
    required this.location,
    this.isPolylineUpdated = false,
    this.polylines,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'orderID': orderID,
      'location': location.toMap(),
      'isPolylineUpdated': isPolylineUpdated,
      'polylines': polylines?.toMap(),
    };
  }
}
