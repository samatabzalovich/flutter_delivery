// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';

abstract class DriverRepository {
  Future<void> initializeSocket(String token);
  Future<void> sendLocation(DeliveryUseCaseParams locationData);
  Future<void> onLine(DeliveryUseCaseParams locationData);
  Future<PolylineUseCaseResult> getPolyline(PolylineUseCaseParams location);
  Future<void> acceptOrder(OrderEntity entity);
  Future<void> pickOrder(OrderEntity entity);
  Future<void> completeOrder(OrderEntity entity);
  Future<void> disconnect();
  Stream<OrderEntity> streamOrder();
  Stream<String> serverErrorResponse();
  void closeRequestStream();
  void closeErrorStream();
}

class DeliveryUseCaseParams {
  final String? from;
  final String? to;
  final int? orderID;
  final LatLng location;
  DeliveryUseCaseParams({
    this.from,
    this.to,
    this.orderID,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'orderID': orderID,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
    };
  }

  factory DeliveryUseCaseParams.fromMap(Map<String, dynamic> map) {
    return DeliveryUseCaseParams(
      from: map['from'] != null ? map['from'] as String : null,
      to: map['to'] != null ? map['to'] as String : null,
      orderID: map['orderID'] != null ? map['orderID'] as int : null,
      location: LatLng(map['location']["latitude"] as double,
          map['location']["longitude"] as double),
    );
  }
}
