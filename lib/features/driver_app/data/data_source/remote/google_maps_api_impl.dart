// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_delivery/core/constants/API.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:flutter_delivery/features/driver_app/data/data_source/remote/google_maps_api.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';
// ignore: library_prefixes
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsApiServiceImpl implements GoogleMapsApiService {
  final PolylinePoints _polylinePoints;
  GoogleMapsApiServiceImpl(
    this._polylinePoints,
  );
  @override
  Future<DataState<PolylineUseCaseResult>> getPolyLine(
    PolylineUseCaseParams params,
  ) async {
    try {
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(params.origin.latitude, params.origin.longitude),
        PointLatLng(params.destination.latitude, params.destination.longitude),
        travelMode: params.travelMode,
      );
      List<LatLng> polylineResult = [];
      List<mapTool.LatLng> polylineResultForMapToolPlugin = [];
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineResult.add(LatLng(point.latitude, point.longitude));
          polylineResultForMapToolPlugin
              .add(mapTool.LatLng(point.latitude, point.longitude));
        });
      }
      PolylineUseCaseResult res =
          PolylineUseCaseResult(polylineResult, polylineResultForMapToolPlugin);
      return DataSuccess(res);
    } catch (e) {
      return DataFailed(StateException(message: e.toString()));
    }
  }
}
