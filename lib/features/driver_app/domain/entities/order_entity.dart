// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import 'package:flutter_delivery/core/enum/user_enums.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderEntity extends Equatable {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isCompleted;
  final LocationEntity destination;
  final LocationEntity origin;
  final String destinationAddress;
  final String originAddress;
  final int? deliveryId;
  final String? finishCode;
  final int customerId;
  final OrderState deliveryState;
  final int? version;
  const OrderEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
    required this.destination,
    required this.origin,
    required this.destinationAddress,
    required this.originAddress,
    required this.deliveryId,
    required this.finishCode,
    required this.customerId,
    required this.deliveryState,
    required this.version,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        isCompleted,
        destination,
        origin,
        destinationAddress,
        originAddress,
        deliveryId,
        customerId,
        deliveryState,
        version,
      ];
  factory OrderEntity.empty() => const OrderEntity(
      id: null,
      createdAt: null,
      updatedAt: null,
      isCompleted: true,
      destination:  LocationEntity(latitude: 0, longitude: 0),
      origin:   LocationEntity(latitude: 0, longitude: 0),
      destinationAddress: '',
      originAddress: '',
      deliveryId: null,
      finishCode: null,
      customerId: 0,
      deliveryState: OrderState.none,
      version: 0,
      );
  OrderEntity copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
    LocationEntity? destination,
    LocationEntity? origin,
    String? destinationAddress,
    String? originAddress,
    int? deliveryId,
    String? finishCode,
    int? customerId,
    OrderState? deliveryState,
    int? version,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      destination: destination ?? this.destination,
      origin: origin ?? this.origin,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      originAddress: originAddress ?? this.originAddress,
      deliveryId: deliveryId ?? this.deliveryId,
      finishCode: finishCode ?? this.finishCode,
      customerId: customerId ?? this.customerId,
      deliveryState: deliveryState ?? this.deliveryState,
      version: version ?? this.version,
    );
  }
}

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;

  const LocationEntity({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationEntity.fromMap(Map<String, dynamic> map) {
    return LocationEntity(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }
}
