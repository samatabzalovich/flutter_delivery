// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:flutter_delivery/core/enum/user_enums.dart';

class CustomerEntity extends Equatable {
  final String uid;
  final String email;
  final String userName;
  final UserType type;
  final String destinationLatitude;
  final String destinationlongitude;
  final String address;
  final DeliveryState deliveryStatus;
  CustomerEntity({
    required this.uid,
    required this.email,
    required this.userName,
    required this.type,
    required this.destinationLatitude,
    required this.destinationlongitude,
    required this.address,
    required this.deliveryStatus,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        userName,
        type,
        destinationLatitude,
        destinationlongitude,
        address,
        deliveryStatus,
      ];
}
