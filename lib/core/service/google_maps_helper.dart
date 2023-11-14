import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsHelper {
  Map<PolylineId, Polyline> getPolylineMap(List<LatLng> coordinates, String key, Color color, {List<PatternItem> patterns = const []}) {
    PolylineId id = PolylineId(key);
    Polyline polyline = Polyline(
      jointType: JointType.round,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
        width: 5, polylineId: id, color: color, points: coordinates, patterns: patterns
        );
    // polylines[id] = polyline;
    return {id: polyline};
  }

  LatLngBounds getBounds(List<Marker> markers) {
    double minLat = markers[0].position.latitude;
    double maxLat = markers[0].position.latitude;
    double minLng = markers[0].position.longitude;
    double maxLng = markers[0].position.longitude;

    for (final marker in markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      minLat = math.min(minLat, lat);
      maxLat = math.max(maxLat, lat);
      minLng = math.min(minLng, lng);
      maxLng = math.max(maxLng, lng);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Map<MarkerId, Marker> getMarkerMap(LatLng position, String key, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(key);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    return {markerId: marker};
  }
}
