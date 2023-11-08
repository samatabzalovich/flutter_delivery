// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter_delivery/core/enum/user_enums.dart';

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
  final int customerId;
  final DeliveryState deliveryState;
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
