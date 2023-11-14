import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

class LocationService {
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  double bearingBetween(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    // return Geolocator.bearingBetween(startLatitude, startLongitude, endLatitude, endLongitude);

    return mapTool.SphericalUtil.computeHeading(
            mapTool.LatLng(startLatitude, startLongitude),
            mapTool.LatLng(endLatitude, endLongitude))
        .toDouble();
  }

  bool isMovingTowardsTarget(Position userLocation, bearingToTarget) {
    // Calculate the difference between the bearing to the target and the user's heading.
    double finalBearing = ((bearingToTarget + 180) % 360);
    double bearingDiff = (userLocation.heading - finalBearing);
    // If the bearing difference is within a certain threshold, the user is moving towards the target.
    // You can adjust the threshold as needed.
    return bearingDiff <= 90.0;
  }

  Future<mapTool.LatLng> getMarkerProjectionOnSegment(mapTool.LatLng carPos,
      List<mapTool.LatLng> segment, GoogleMapController mapController) async {
    ScreenCoordinate a = await mapController
        .getScreenCoordinate(LatLng(segment[0].latitude, segment[0].longitude));
    ScreenCoordinate b = await mapController
        .getScreenCoordinate(LatLng(segment[1].latitude, segment[1].longitude));
    ScreenCoordinate p = await mapController
        .getScreenCoordinate(LatLng(carPos.latitude, carPos.longitude));

    if (a == b)
      return segment[0]; // Projected points are the same, segment is very short
    if (p == a || p == b) return carPos;

    /*
        If you're interested in the math (d represents point on segment you are trying to find):
        
        angle between 2 vectors = inverse cos of (dotproduct of 2 vectors / product of the magnitudes of each vector)
        angle = arccos(ab.ap/|ab|*|ap|)
        ad magnitude = magnitude of vector ap multiplied by cos of (angle).
        ad = ap*cos(angle) --> basic trig adj = hyp * cos(opp)
        below implementation is just a simplification of these equations
         */

    double dotproduct = ((b.x.toDouble() - a.x.toDouble()) *
            (p.x.toDouble() - a.x.toDouble())) +
        ((b.y.toDouble() - a.y.toDouble()) * (p.y.toDouble() - a.y.toDouble()));
    double absquared = (pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
        .toDouble(); // Segment magnitude squared

    // Get the fraction for SphericalUtil.interpolate
    double fraction = dotproduct / absquared;

    if (fraction > 1) return segment[1];
    if (fraction < 0) return segment[0];
    return mapTool.SphericalUtil.interpolate(segment[0], segment[1], fraction);
  }

  Future<Stream<Position>> getPositionStream() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw StateException(message: "Location services are not enabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw StateException(message: "Permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw StateException(
          message:
              "Location permissions are permanently denied, we cannot request permissions.");
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 1),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 5,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    Stream<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);
    return positionStream;
  }

  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
