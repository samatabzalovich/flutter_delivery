import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';

abstract class GoogleMapsApiService {
  Future<DataState<PolylineUseCaseResult>> getPolyLine(PolylineUseCaseParams params);
}
