// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class GetPolylineUseCase
    implements UseCase<DataState<PolylineUseCaseResult>, PolylineUseCaseParams> {
  final DriverRepository _driverRepository;

  GetPolylineUseCase(this._driverRepository);

  @override
  Future<DataState<PolylineUseCaseResult>> call({PolylineUseCaseParams? params}) {
    return _driverRepository.getPolyline(params!);
  }
}

class PolylineUseCaseParams {
  final LocationEntity origin;
  final LocationEntity destination;
  final TravelMode travelMode;
  PolylineUseCaseParams({
    required this.origin,
    required this.destination,
    this.travelMode  = TravelMode.driving,
  });

  PolylineUseCaseParams copyWith({
    LocationEntity? origin,
    LocationEntity? destination,
    TravelMode? travelMode,
  }) {
    return PolylineUseCaseParams(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      travelMode: travelMode ?? this.travelMode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'origin': origin.toMap(),
      'destination': destination.toMap(),
    };
  }

  factory PolylineUseCaseParams.fromMap(Map<String, dynamic> map) {
    return PolylineUseCaseParams(
      origin: LocationEntity.fromMap(map['origin'] as Map<String,dynamic>),
      destination: LocationEntity.fromMap(map['destination'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PolylineUseCaseParams.fromJson(String source) => PolylineUseCaseParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PolylineUseCaseParams(origin: $origin, destination: $destination, travelMode: $travelMode)';

  @override
  bool operator ==(covariant PolylineUseCaseParams other) {
    if (identical(this, other)) return true;
  
    return 
      other.origin == origin &&
      other.destination == destination &&
      other.travelMode == travelMode;
  }

  @override
  int get hashCode => origin.hashCode ^ destination.hashCode ^ travelMode.hashCode;
}

class PolylineUseCaseResult extends Equatable {
  final List<LatLng> polylineResult;
  final List<mapTool.LatLng> polylineResultForMapToolPlugin;

  const PolylineUseCaseResult(
      this.polylineResult, this.polylineResultForMapToolPlugin);

  @override
  List<Object?> get props => [polylineResult, polylineResultForMapToolPlugin];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'polylineResult': polylineResult.map((x) => LocationEntity(latitude: x.latitude, longitude: x.longitude).toMap()).toList(),
    };
  }
}

class Polylines extends Equatable {
  final PolylineUseCaseResult? fromCurrentToOrigin;
  final PolylineUseCaseResult? walkingPolylinefromCurrentToOrigin;
  final PolylineUseCaseResult walkingPolylinefromOriginToDest;
  final PolylineUseCaseResult fromOriginToDestination;
  const Polylines({
    this.fromCurrentToOrigin,
    this.walkingPolylinefromCurrentToOrigin,
    required this.walkingPolylinefromOriginToDest,
    required this.fromOriginToDestination,
  });

  @override
  List<Object?> get props => [fromCurrentToOrigin, walkingPolylinefromCurrentToOrigin, walkingPolylinefromOriginToDest, fromOriginToDestination];


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromCurrentToOrigin': fromCurrentToOrigin?.toMap(),
      'walkingPolylinefromCurrentToOrigin': walkingPolylinefromCurrentToOrigin?.toMap(),
      'walkingPolylinefromOriginToDest': walkingPolylinefromOriginToDest.toMap(),
      'fromOriginToDestination': fromOriginToDestination.toMap(),
    };
  }
}
