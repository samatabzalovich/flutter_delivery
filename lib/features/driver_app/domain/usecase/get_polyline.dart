import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

import 'package:flutter_delivery/core/usecase/usecase.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';

class GetPolylineUseCase
    implements UseCase<PolylineUseCaseResult, PolylineUseCaseParams> {
  final DriverRepository _driverRepository;

  GetPolylineUseCase(this._driverRepository);

  @override
  Future<PolylineUseCaseResult> call({PolylineUseCaseParams? params}) {
    return _driverRepository.getPolyline(params!);
  }
}

class PolylineUseCaseParams {
  final LocationEntity origin;
  final LocationEntity destination;
  PolylineUseCaseParams({
    required this.origin,
    required this.destination,
  });
}

class PolylineUseCaseResult {
  final List<LatLng> polylineResult;
  final List<mapTool.LatLng> polylineResultForMapToolPlugin;

  PolylineUseCaseResult(
      this.polylineResult, this.polylineResultForMapToolPlugin);
}
