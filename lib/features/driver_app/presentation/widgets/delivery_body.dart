import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_delivery/core/common/widgets/my_button.dart';
import 'package:flutter_delivery/core/service/dependencies_injector.dart';
import 'package:flutter_delivery/core/service/google_maps_helper.dart';
import 'package:flutter_delivery/core/service/location.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';
import 'package:flutter_delivery/features/driver_app/presentation/bloc/delivery_bloc.dart';
import 'package:flutter_delivery/core/enum/user_enums.dart';
import 'package:flutter_delivery/features/driver_app/presentation/widgets/generic_dialog.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryBody extends StatefulWidget {
  const DeliveryBody({super.key});

  @override
  State<DeliveryBody> createState() => _DeliveryBodyState();
}

class _DeliveryBodyState extends State<DeliveryBody> {
  // late LatLng _initialcameraposition;
  late LatLng _initialcameraposition;
  late Position _currentLocation;
  OrderState orderState = OrderState.none;
  late OrderEntity order;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  late Polylines allPolyLinesForMapToolKit;
  bool isTiltEnabled = true;
  bool isScrollEnabled = true;
  bool isZoomEnabled = true;
  bool isLocationEnabled = true;
  late Uint8List _customIcon;
  @override
  void initState() {
    getBytesFromAsset("./assets/car.png", 100);
    super.initState();
  }

  Future<void> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    _customIcon = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryBloc, DeliveryState>(
      listener: (ctx, state) async {
        if (state is DeliveryStateUpdateLocation) {
          _currentLocation = state.currentLocation;
          _initialcameraposition = LatLng(
              state.currentLocation.latitude, state.currentLocation.longitude);

          if (state.isPolylineUpdated) {
            setState(() {
              _setPolyLines(state);
              _setCurrentLocationForNewPolyline(state);
            });
          }
          if (state.order != null && state.isPolylineUpdated == false) {
            // PolylineId id =  getCurrentPolylineId(state.order!);
            setState(() {
              _setPolyLines(state);
              updateCurrentLocationMarker(state.polyline!);
            });
          }
        } else if (state is DeliveryStateSearchingCustomer) {
          setState(() {
            orderState = OrderState.searching;
          });
        } else if (state is DeliveryStateOffLine) {
          setState(() {
            orderState = OrderState.none;
          });
        } else if (state is DeliveryStateFoundCustomer) {
          isLocationEnabled = false;
          _setPolyLines(state);
          _setMarkers(state);
          _setCurrentLocationMarker(state);
          order = state.order!;
          setState(() {
            orderState = order.deliveryState == OrderState.searching
                ? OrderState.found
                : order.deliveryState;
          });
        } else if (state is DeliveryStateOrderAccepted) {
          setState(() {
            order = state.order!;
            orderState = OrderState.coming;
          });
        } else if (state is DeliveryStateOrderPicked) {
          order = state.order!;
          setState(() {
            _setPolyLines(state);
            orderState = OrderState.picked;
          });
        } else if (state is DeliveryStateFinished) {
          showSuccessDialog(
              message:
                  "Please wait we are checking order before it`s completed",
              context: context);
          order = OrderEntity.empty();
          polylines = {};
          markers = {};
          setState(() {
            orderState = OrderState.none;
          });
        } else if (state is DeliveryStateMessage) {
          showStateMessage(message: state.message, context: context);
        }
      },
      builder: ((context, state) {
        if (state is DeliveryStateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition, zoom: 15),
              myLocationEnabled: isLocationEnabled,
              mapType: MapType.terrain,
              tiltGesturesEnabled: isTiltEnabled,
              compassEnabled: true,
              scrollGesturesEnabled: isScrollEnabled,
              zoomGesturesEnabled: isZoomEnabled,
              onMapCreated: (e) {
                BlocProvider.of<DeliveryBloc>(context).add(DeliveryInitMapEvent(
                    e, context.read<AuthBloc>().state.user!.token!));
              },
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
              buildingsEnabled: true,
              indoorViewEnabled: true,
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: SizedBox(
                  height: 70, child: _buttonBuilder(context, orderState)),
            )
          ],
        );
      }),
    );
  }

  void _setPolyLines(DeliveryState state) {
    polylines.clear();

    if (state.polylines!.fromCurrentToOrigin != null) {
      final Map<PolylineId, Polyline> toOrigin = sl<GoogleMapsHelper>()
          .getPolylineMap(state.polylines!.fromCurrentToOrigin!.polylineResult,
              "toOrigin", Colors.green);
      final Map<PolylineId, Polyline> toOriginOnFeet =
          sl<GoogleMapsHelper>().getPolylineMap(
        state.polylines!.walkingPolylinefromCurrentToOrigin!.polylineResult,
        "toOriginOnFeet",
        Colors.blue,
        patterns: [
          PatternItem.dot,
          PatternItem.gap(7),
        ],
      );

      polylines = {
        ...toOrigin,
        ...toOriginOnFeet,
      };
    }
    final Map<PolylineId, Polyline> toDestOnFeet =
        sl<GoogleMapsHelper>().getPolylineMap(
      state.polylines!.walkingPolylinefromOriginToDest.polylineResult,
      "toDestOnFeet",
      Colors.blue,
      patterns: [
        PatternItem.dot,
        PatternItem.gap(7),
      ],
    );
    final Map<PolylineId, Polyline> toDest = sl<GoogleMapsHelper>()
        .getPolylineMap(state.polylines!.fromOriginToDestination.polylineResult,
            "toDest", Colors.red);
    polylines = {...polylines, ...toDest, ...toDestOnFeet};
    allPolyLinesForMapToolKit = state.polylines!;
  }

  PolylineId getCurrentPolylineId(OrderEntity order) {
    final String polyLineIDValue;
    switch (order.deliveryState) {
      case OrderState.coming:
        polyLineIDValue = "toOrigin";
        break;
      case OrderState.searching:
        polyLineIDValue = "toOrigin";
        break;
      case OrderState.picked:
        polyLineIDValue = "toDest";
        break;
      default:
        polyLineIDValue = "toOrigin";
        break;
    }
    return polylines.keys.firstWhere((pol) => pol.value == polyLineIDValue);
  }

//   final Uint8List markerIcon = await getBytesFromAsset('assets/images/flutter.png', 100);
// final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
  void _setCurrentLocationMarker(DeliveryState state) {
    PolylineId id = getCurrentPolylineId(state.order!);

    LatLng currentLoc = polylines[id]!.points.first;

    final Map<MarkerId, Marker> currentLocation =
        sl<GoogleMapsHelper>().getMarkerMap(
      currentLoc,
      "currentLocation",
      BitmapDescriptor.fromBytes(_customIcon),
    );
    markers = {...currentLocation, ...markers};
  }

  void _setCurrentLocationForNewPolyline(DeliveryState state) {
    const MarkerId id = MarkerId("currentLocation");
    Marker marker =
        markers.values.toList().firstWhere((item) => item.markerId == id);
    switch (state.order!.deliveryState) {
      case OrderState.coming:
        marker = marker.copyWith(
            positionParam:
                state.polylines!.fromCurrentToOrigin!.polylineResult.first);
      case OrderState.searching:
        marker = marker.copyWith(
            positionParam:
                state.polylines!.fromCurrentToOrigin!.polylineResult.first);
      case OrderState.picked:
        marker = marker.copyWith(
            positionParam:
                state.polylines!.fromOriginToDestination.polylineResult.first);
      default:
        marker = marker.copyWith(
            positionParam:
                state.polylines!.fromOriginToDestination!.polylineResult.first);
    }

    //the marker is identified by the markerId and not with the index of the list
    markers[id] = marker;
  }

  updateCurrentLocationMarker(List<LatLng> lng) {
    const MarkerId id = MarkerId("currentLocation");
    final marker =
        markers.values.toList().firstWhere((item) => item.markerId == id);
    //the marker is identified by the markerId and not with the index of the list
    markers[id] = marker.copyWith(positionParam: lng.first, rotationParam: mapTool.SphericalUtil.computeAngleBetween(mapTool.LatLng(lng.first.latitude, lng.first.longitude), mapTool.LatLng(lng[1].latitude, lng[1].longitude)).toDouble());
  }

  void _setMarkers(DeliveryState state) {
    final Map<MarkerId, Marker> origin = sl<GoogleMapsHelper>().getMarkerMap(
      LatLng(state.order!.origin.latitude, state.order!.origin.longitude),
      "origin",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );
    final Map<MarkerId, Marker> destination =
        sl<GoogleMapsHelper>().getMarkerMap(
      LatLng(state.order!.destination.latitude,
          state.order!.destination.longitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );
    markers = {...origin, ...destination};
  }

  Widget _buttonBuilder(BuildContext context, OrderState orderState) {
    Map<OrderState, Widget> buttonMap = {
      OrderState.none: MyButton(
        text: "On line",
        onTap: () {
          BlocProvider.of<DeliveryBloc>(context).add(
            DeliveryFindCustomerEvent(
              DeliveryUseCaseParams(
                location: LocationEntity(
                    latitude: _currentLocation.latitude,
                    longitude: _currentLocation.longitude),
              ),
            ),
          );
        },
      ),
      OrderState.searching: MyButton(
        text: "Searching",
        onTap: () {
          BlocProvider.of<DeliveryBloc>(context)
              .add(const DeliveryOffLineEvent());
        },
        buttonColor: Colors.grey,
      ),
      OrderState.coming: MyButton(
        text: "Pick up",
        onTap: () {
          order = order.copyWith(deliveryState: OrderState.picked);
          BlocProvider.of<DeliveryBloc>(context).add(
            DeliveryPickEvent(
                order, allPolyLinesForMapToolKit, _currentLocation),
          );
        },
        buttonColor: Colors.orange,
      ),
      OrderState.picked: MyButton(
        text: "Complete",
        onTap: () {
          order = order.copyWith(deliveryState: OrderState.dropped);
          isLocationEnabled = true;
          BlocProvider.of<DeliveryBloc>(context).add(
            DeliveryDropEvent(_currentLocation, order.finishCode!),
          );
        },
        buttonColor: Colors.red,
      ),
      OrderState.found: MyButton(
        text: "Start",
        onTap: () {
          int id = BlocProvider.of<AuthBloc>(context).state.user!.uid;
          order =
              order.copyWith(deliveryId: id, deliveryState: OrderState.coming);
          BlocProvider.of<DeliveryBloc>(context).add(
            DeliveryAcceptOrderEvent(
                order, allPolyLinesForMapToolKit, _currentLocation),
          );
        },
        buttonColor: Colors.green,
      )
    };
    return buttonMap[orderState]!;
  }
}
