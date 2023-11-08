import 'dart:math';

import 'package:flutter/material.dart';
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
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  late Polylines allPolyLinesForMapToolKit;
  bool isTiltEnabled = true;
  bool isScrollEnabled = true;
  bool isZoomEnabled = true;
  late double _remainingDistanceToPolyLine;
  late PolylineId _currentPolyLineId;

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryBloc, DeliveryState>(
      listener: (ctx, state) async {
        if (state is DeliveryStateUpdateLocation) {
          _currentLocation = state.currentLocation;
          if (mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(state.currentLocation.latitude,
                        state.currentLocation.longitude),
                    zoom: 17,
                    tilt: state.order != null ? 45 : 0,
                    bearing: state.currentLocation.heading),
              ),
            );

            if (state.isPolylineUpdated != true && polylines.isNotEmpty) {
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
              _currentPolyLineId = polylines.keys
                  .firstWhere((pol) => pol.value == polyLineIDValue);
              List<LatLng> polyline = polylines[_currentPolyLineId]!.points;
              // TODO: implement the logic of polylie updating while user moving towards the pol point _remainingDistance
              double distance = sl<LocationService>().calculateDistance(
                polyline.first.latitude,
                polyline.first.longitude,
                state.currentLocation.latitude,
                state.currentLocation.longitude,
              );
              _remainingDistanceToPolyLine -= distance;
              if (_remainingDistanceToPolyLine <= 5) {
                polyline.removeAt(1);
                _remainingDistanceToPolyLine =
                    sl<LocationService>().calculateDistance(
                  state.currentLocation.latitude,
                  state.currentLocation.longitude,
                  polyline.first.latitude,
                  polyline.first.longitude,
                );
              } else {
                polyline.first = LatLng(state.currentLocation.latitude,
                    state.currentLocation.longitude);
              }

              // Todo : until here
              setState(() {
                polylines[_currentPolyLineId] = polylines[_currentPolyLineId]!
                    .copyWith(pointsParam: polyline);
              });
            }
          } else {
            _initialcameraposition = LatLng(state.currentLocation.latitude,
                state.currentLocation.longitude);
          }
          if (state.isPolylineUpdated) {
            setState(() {
              _setPolyLines(state);
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
          _setPolyLines(state);

          _setMarkers(state);
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
              myLocationEnabled: true,
              mapType: MapType.terrain,
              tiltGesturesEnabled: isTiltEnabled,
              compassEnabled: true,
              scrollGesturesEnabled: isScrollEnabled,
              zoomGesturesEnabled: isZoomEnabled,
              onMapCreated: _onMapCreated,
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    BlocProvider.of<DeliveryBloc>(context).add(
        DeliveryInitSocketEvent(context.read<AuthBloc>().state.user!.token!));
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
    List<Marker> markerArr =
        markers.entries.map((entry) => entry.value).toList();
    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
          sl<GoogleMapsHelper>().getBounds(markerArr), 100),
    );
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
