import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/core/constants/API.dart';
import 'package:flutter_delivery/core/utils/distance.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

class MapSample extends StatefulWidget {
  MapSample({super.key});
  bool isDestAssigned = true;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapSample> {
  String indicatorID = "indicator";
  late LocationData _currentPosition;
  LatLng _initialcameraposition = const LatLng(51.169392, 71.449074);
  Location location = Location();
  late GoogleMapController mapController;
  final double _destLatitude = 51.1265412, _destLongitude = 71.4039006;

  // double _originLatitude = 26.48424, _originLongitude = 50.04551;
  // double _destLatitude = 26.46423, _destLongitude = 50.06358;
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
    bool isServiceEnabled;
    PermissionStatus permissionGranted;

    isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    // _addMarker(_initialcameraposition,
    //     indicatorID, customIcon);
    location.onLocationChanged.listen((LocationData currentLocation) {
      // if (widget.isDestAssigned) {
      //   routeLiveTracking(
      //       LatLng(currentLocation.latitude!, currentLocation.longitude!),
      //       polylineCoordinates);
      // }
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude!, _currentPosition.longitude!);

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
    location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(l.latitude!, l.longitude!),
              zoom: 17,
              tilt: 45,
              bearing: l.heading!),
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
