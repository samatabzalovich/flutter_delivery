import 'dart:math';

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
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  Map<MarkerId, Marker> getMarkerMap(LatLng position, String key, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(key);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    return {markerId: marker};
  }
}
