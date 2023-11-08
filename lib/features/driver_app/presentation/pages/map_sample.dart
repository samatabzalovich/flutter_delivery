import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery/core/constants/API.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// ignore: library_prefixes
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

class MapSample extends StatefulWidget {
  const MapSample({super.key});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapSample> {
  late LatLng _currentPosition;
  LatLng _initialcameraposition = const LatLng(51.169392, 71.449074);
  // Location location = Location();
  late GoogleMapController mapController;
  final double _destLatitude = 51.1265412, _destLongitude = 71.4039006;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = []; //
  List<mapTool.LatLng> polylineCordenatesInMapTool =
      []; // these two 33 and 34 are the same
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    // _loadCustomIcon();
    getLoc();
    _getPolyline(
        destLat: _destLatitude,
        destLong: _destLongitude,
        originLat: 51.089253,
        originLong: 71.402685);
  }

  // late BitmapDescriptor customIcon;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _initialcameraposition, zoom: 15),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
        buildingsEnabled: true,
        indoorViewEnabled: true,
      )),
    );
  }

  // Future<void> _loadCustomIcon() async {
  //   customIcon = await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(size: Size(5, 5)),
  //     'assets/arrow-2.png', // Replace with the path to your custom icon image
  //   );
  // }

  getLoc() async {
    // bool isServiceEnabled;
    // PermissionStatus permissionGranted;

    // isServiceEnabled = await location.serviceEnabled();
    // if (!isServiceEnabled) {
    //   isServiceEnabled = await location.requestService();
    //   if (!isServiceEnabled) {
    //     return;
    //   }
    // }

    // permissionGranted = await location.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    // _currentPosition = await location.getLocation();
    // _initialcameraposition =
    //     LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    // // _addMarker(_initialcameraposition,
    // //     indicatorID, customIcon);
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   // if (widget.isDestAssigned) {
    //   //   routeLiveTracking(
    //   //       LatLng(currentLocation.latitude!, currentLocation.longitude!),
    //   //       polylineCoordinates);
    //   // }
    // setState(() {
    //   _currentPosition = currentLocation;
    //   _initialcameraposition =
    //       LatLng(_currentPosition.latitude!, _currentPosition.longitude!);

    //   //         MarkerId markerId = MarkerId(indicatorID);
    //   // Marker marker =
    //   //     Marker(markerId: markerId, icon: customIcon, position: _initialcameraposition, rotation: currentLocation.heading!);
    //   // markers[markerId] = marker;
    // });
    // });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // throw StateException(message: "Location services are not enabled");
      return;
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
        // throw StateException(message: "Permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // throw StateException( message:"Location permissions are permanently denied, we cannot request permissions.");
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
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
        distanceFilter: 10,
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

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((event) {
          routeLiveTracking(
            LatLng(event.latitude, event.longitude),
            polylineCoordinates);
      setState(() {
        _currentPosition = LatLng(event.latitude, event.longitude);
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude!);

        //         MarkerId markerId = MarkerId(indicatorID);
        // Marker marker =
        //     Marker(markerId: markerId, icon: customIcon, position: _initialcameraposition, rotation: currentLocation.heading!);
        // markers[markerId] = marker;
      });
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 7,
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    LocationSettings locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude, l.longitude),
              zoom: 17,
              tilt: 45,
              bearing: l.heading),
        ),
      );
    });
  }

  _getPolyline(
      {required double originLat,
      required double originLong,
      required double destLat,
      required double destLong,
      TravelMode mode = TravelMode.driving}) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(originLat, originLong),
      PointLatLng(destLat, destLong),
      travelMode: mode,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        polylineCordenatesInMapTool
            .add(mapTool.LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  routeLiveTracking(LatLng currentLoc, List<LatLng> routeCoordinates) async {
    if (polylineCordenatesInMapTool.isNotEmpty) {
      bool isOnEdge = mapTool.PolygonUtil.isLocationOnPath(
          mapTool.LatLng(currentLoc.latitude, currentLoc.longitude),
          polylineCordenatesInMapTool,
          true,
          tolerance: 5);
      if (!isOnEdge) {
        // User is outside the polyline, so update the polyline
        polylineCoordinates.clear();
        polylineCordenatesInMapTool.clear();
        polylines.clear();
        _getPolyline(
            destLat: _destLatitude,
            destLong: _destLongitude,
            originLat: _currentPosition.latitude!,
            originLong: _currentPosition.longitude!);
      }
    }
  }
}
