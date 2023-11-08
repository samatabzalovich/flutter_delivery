// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_delivery/core/constants/constants.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/core/resources/data_state.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_delivery/core/enum/user_enums.dart' as en;
import 'package:flutter_delivery/core/service/location.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/accept_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/close_error_stream.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/close_socket_stream.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/complete_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/disconnect.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/get_polyline.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/initalize_socket.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/off_line.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/on_line.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/pick_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/send_location.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/server_message.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/stream_order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: library_prefixes
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final InitializeUseCase _initializeUseCase;
  final OnLineUseCase _onLineUseCase;
  final OffLineUseCase _offLineUseCase;
  final StreamOrderUseCase _streamOrderUseCase;
  final ServerMessageUseCase _serverMessageUseCase;
  final AcceptOrderUseCase _acceptOrderUseCase;
  final SendLocationUseCase _sendLocationUseCase;
  final LocationService _locationService;
  final GetPolylineUseCase _getPolylineUseCase;
  final PickOrderUseCase _pickOrderUseCase;
  final CompleteOrderUseCase _completeOrderUseCase;
  final DisconnectUsecase _disconnectUsecase;
  final CloseErrorStreamUseCase _closeErrorStreamUseCase;
  final CloseSocketStreamUseCase _closeSocketStreamUseCase;
  DeliveryBloc(
    this._initializeUseCase,
    this._onLineUseCase,
    this._offLineUseCase,
    this._streamOrderUseCase,
    this._serverMessageUseCase,
    this._acceptOrderUseCase,
    this._sendLocationUseCase,
    this._locationService,
    this._getPolylineUseCase,
    this._pickOrderUseCase,
    this._completeOrderUseCase,
    this._disconnectUsecase,
    this._closeErrorStreamUseCase,
    this._closeSocketStreamUseCase,
  ) : super(const DeliveryStateLoading()) {
    on<DeliveryInitEvent>(initialize);
    on<DeliveryInitSocketEvent>(initializeSocket);
    on<DeliveryFindCustomerEvent>(online);
    on<DeliveryOffLineEvent>(offline);
    on<DeliveryFoundCustomerEvent>(found);
    on<DeliveryOrderExistsEvent>(onOrderExist);
    on<DeliveryAcceptOrderEvent>(accept);
    on<DeliveryMessageEvent>(onMessage);
    on<DeliveryReceivedLocationEvent>(onReceivedLocation);
    on<DeliveryPickEvent>(onPick);
    on<DeliveryDropEvent>(onDrop);
    on<DeliveryDisconnectEvent>(onDisconnect);
  }
  void onMessage(
      DeliveryMessageEvent event, Emitter<DeliveryState> emit) async {
    emit(DeliveryStateMessage(event.message,
        order: state.order, polylines: state.polylines));
  }

  Future<DataState<Polylines>> getPolyLines(DeliveryEvent event) async {
    final Position currentPosition = await _locationService.getPosition();
    PolylineUseCaseResult? polyLineResultFromCurrentToOrigin;
    PolylineUseCaseResult? walkingPolylineFromCurrentToOrigin;
    double distance;
    if (event.order!.deliveryState == en.OrderState.coming ||
        event.order!.deliveryState == en.OrderState.searching) {
      final firstDataState = await _getPolylineUseCase.call(
        params: PolylineUseCaseParams(
          origin: LocationEntity(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
          ),
          destination: LocationEntity(
            latitude: event.order!.origin.latitude,
            longitude: event.order!.origin.longitude,
          ),
        ),
      );
      if (firstDataState is DataFailed) {
        return DataFailed(StateException(message: polylineErrorMessage));
      }
      polyLineResultFromCurrentToOrigin = firstDataState.data!;
      distance = Geolocator.distanceBetween(
          polyLineResultFromCurrentToOrigin.polylineResult.last.latitude,
          polyLineResultFromCurrentToOrigin.polylineResult.last.longitude,
          event.order!.origin.latitude,
          event.order!.origin.longitude);
      if (distance <
          walkingLimit) //checks if walking polyline request is needed
      {
        walkingPolylineFromCurrentToOrigin = PolylineUseCaseResult(
          [
            LatLng(
              polyLineResultFromCurrentToOrigin.polylineResult.last.latitude,
              polyLineResultFromCurrentToOrigin.polylineResult.last.longitude,
            ),
            LatLng(event.order!.origin.latitude, event.order!.origin.longitude)
          ],
          [
            mapTool.LatLng(
              polyLineResultFromCurrentToOrigin.polylineResult.last.latitude,
              polyLineResultFromCurrentToOrigin.polylineResult.last.longitude,
            ),
            mapTool.LatLng(
                event.order!.origin.latitude, event.order!.origin.longitude)
          ],
        );
      } else {
        final secondDataState = await _getPolylineUseCase.call(
          params: PolylineUseCaseParams(
            travelMode: TravelMode.walking,
            origin: LocationEntity(
              latitude: polyLineResultFromCurrentToOrigin
                  .polylineResult.last.latitude,
              longitude: polyLineResultFromCurrentToOrigin
                  .polylineResult.last.longitude,
            ),
            destination: LocationEntity(
              latitude: event.order!.origin.latitude,
              longitude: event.order!.origin.longitude,
            ),
          ),
        );
        if (secondDataState is DataFailed) {
          return DataFailed(StateException(message: polylineErrorMessage));
        }
        walkingPolylineFromCurrentToOrigin = secondDataState.data!;
      }
    }
    PolylineUseCaseResult polyLineResultFromOriginToDest;
    final thirdDataState = await _getPolylineUseCase.call(
      params: PolylineUseCaseParams(
        origin: LocationEntity(
          latitude: polyLineResultFromCurrentToOrigin == null
              ? currentPosition.latitude
              : polyLineResultFromCurrentToOrigin.polylineResult.last.latitude,
          longitude: polyLineResultFromCurrentToOrigin == null
              ? currentPosition.longitude
              : polyLineResultFromCurrentToOrigin.polylineResult.last.longitude,
        ),
        destination: LocationEntity(
          latitude: event.order!.destination.latitude,
          longitude: event.order!.destination.longitude,
        ),
      ),
    );
    if (thirdDataState is DataFailed) {
      return DataFailed(StateException(message: polylineErrorMessage));
    }
    polyLineResultFromOriginToDest = thirdDataState.data!;
    PolylineUseCaseResult walkingPolylineFromOriginToDest;
    distance = Geolocator.distanceBetween(
        polyLineResultFromOriginToDest.polylineResult.last.latitude,
        polyLineResultFromOriginToDest.polylineResult.last.longitude,
        event.order!.destination.latitude,
        event.order!.destination.longitude);
    if (distance < walkingLimit) {
      walkingPolylineFromOriginToDest = PolylineUseCaseResult(
        [
          LatLng(
            polyLineResultFromOriginToDest.polylineResult.last.latitude,
            polyLineResultFromOriginToDest.polylineResult.last.longitude,
          ),
          LatLng(event.order!.destination.latitude,
              event.order!.destination.longitude)
        ],
        [
          mapTool.LatLng(
            polyLineResultFromOriginToDest.polylineResult.last.latitude,
            polyLineResultFromOriginToDest.polylineResult.last.longitude,
          ),
          mapTool.LatLng(event.order!.destination.latitude,
              event.order!.destination.longitude)
        ],
      );
    } else {
      //checks if walking polyline request is needed, if it is not we draw dotted (straight line to dest point) polyline by our own
      final fourthDataState = await _getPolylineUseCase.call(
        params: PolylineUseCaseParams(
          travelMode: TravelMode.walking,
          origin: LocationEntity(
            latitude:
                polyLineResultFromOriginToDest.polylineResult.last.latitude,
            longitude:
                polyLineResultFromOriginToDest.polylineResult.last.longitude,
          ),
          destination: LocationEntity(
            latitude: event.order!.destination.latitude,
            longitude: event.order!.destination.longitude,
          ),
        ),
      );
      if (fourthDataState is DataFailed) {
        return DataFailed(StateException(message: polylineErrorMessage));
      }
      walkingPolylineFromOriginToDest = fourthDataState.data!;
    }

    Polylines res = Polylines(
      fromCurrentToOrigin: polyLineResultFromCurrentToOrigin,
      fromOriginToDestination: polyLineResultFromOriginToDest,
      walkingPolylinefromCurrentToOrigin: walkingPolylineFromCurrentToOrigin,
      walkingPolylinefromOriginToDest: walkingPolylineFromOriginToDest,
    );
    return DataSuccess(res);
  }

  void initialize(DeliveryInitEvent event, Emitter<DeliveryState> emit) async {
    final locationSubscripton = await _locationService.getPositionStream();
    locationSubscripton.listen((event) {
      add(DeliveryReceivedLocationEvent(event));
    });
  }

  void initializeSocket(
      DeliveryInitSocketEvent event, Emitter<DeliveryState> emit) async {
    await _initializeUseCase(params: event.token);
    _streamOrderUseCase().listen((event) {
      if (event.deliveryId == null) {
        add(DeliveryFoundCustomerEvent(event));
      } else {
        add(DeliveryOrderExistsEvent(event));
      }
    });

    _serverMessageUseCase.call().listen(
      (event) {
        add(DeliveryMessageEvent(event));
      },
    );
  }

  void onOrderExist(
      DeliveryOrderExistsEvent event, Emitter<DeliveryState> emit) async {
    //Todo: DeliveryOrderExistsEvent
    final dataState = await getPolyLines(event);
    if (dataState is DataSuccess) {
      emit(DeliveryStateFoundCustomer(
        dataState.data!,
        event.order!,
      ));
    }
    if (dataState is DataFailed) {
      emit(DeliveryStateMessage(
        dataState.error!.message,
        order: event.order,
      ));
    }
  }

  void online(
      DeliveryFindCustomerEvent event, Emitter<DeliveryState> emit) async {
    await _onLineUseCase.call(params: event.deliveryLocation);
    emit(const DeliveryStateSearchingCustomer());
  }

  void offline(DeliveryOffLineEvent event, Emitter<DeliveryState> emit) async {
    await _offLineUseCase.call();
    emit(const DeliveryStateOffLine());
  }

  void found(
      DeliveryFoundCustomerEvent event, Emitter<DeliveryState> emit) async {
    final dataState = await getPolyLines(event);
    if (dataState is DataSuccess) {
      emit(DeliveryStateFoundCustomer(
        dataState.data!,
        event.order!,
      ));
    }
    if (dataState is DataFailed) {
      emit(DeliveryStateMessage(
        dataState.error!.message,
        order: event.order,
      ));
    }
  }

  void accept(
      DeliveryAcceptOrderEvent event, Emitter<DeliveryState> emit) async {
    // Todo: started from here
    await _acceptOrderUseCase.call(params: event.order);
    await _sendLocationUseCase(
      params: DeliveryUseCaseParams(
        from: event.order!.deliveryId!.toString(),
        to: event.order!.customerId.toString(),
        orderID: event.order!.id.toString(),
        isPolylineUpdated: true,
        location: LocationEntity(
          latitude: event.currentPosition.latitude,
          longitude: event.currentPosition.longitude,
        ),
        polylines: event.polylines,
      ),
    );
    emit(DeliveryStateOrderAccepted(event.order!, event.polylines!));
  }

  void onReceivedLocation(
      DeliveryReceivedLocationEvent event, Emitter<DeliveryState> emit) async {
    if (state.order != null) {
      en.OrderState orderState = state.order!.deliveryState;
      final List<mapTool.LatLng> checkingPolyline;
      switch (orderState) {
        case en.OrderState.coming:
          checkingPolyline = state
              .polylines!.fromCurrentToOrigin!.polylineResultForMapToolPlugin;
          break;
        case en.OrderState.searching:
          checkingPolyline = state
              .polylines!.fromCurrentToOrigin!.polylineResultForMapToolPlugin;
          break;
        case en.OrderState.picked:
          checkingPolyline = state.polylines!.fromOriginToDestination
              .polylineResultForMapToolPlugin;
          break;
        default:
          checkingPolyline = state.polylines!.fromOriginToDestination
              .polylineResultForMapToolPlugin;
      }
      // mapTool.SphericalUtil.computeArea(from, to, fraction)
      bool isOnEdge = mapTool.PolygonUtil.isLocationOnPath(
        mapTool.LatLng(
            event.currentPosition.latitude, event.currentPosition.longitude),
        checkingPolyline,
        true,
        tolerance: 10,
      );
      if (!isOnEdge) {
        final dataState = await getPolyLines(
          DeliveryGetPolylineEvent(state.order!),
        );
        if (dataState is DataSuccess) {
          // Todo: send polylines also
          if (state.order!.deliveryId != null) {
            await _sendLocationUseCase.call(
              params: DeliveryUseCaseParams(
                from: state.order!.deliveryId!.toString(),
                to: state.order!.customerId.toString(),
                orderID: state.order!.id!.toString(),
                isPolylineUpdated: true,
                location: LocationEntity(
                  latitude: event.currentPosition.latitude,
                  longitude: event.currentPosition.longitude,
                ),
                polylines: dataState.data,
              ),
            );
          }

          emit(
            DeliveryStateUpdateLocation(
              event.currentPosition,
              true,
              order: state.order,
              polylines: dataState.data,
            ),
          );
          if (dataState is DataFailed) {
            emit(DeliveryStateMessage(dataState.error!.message,
                order: state.order, polylines: state.polylines));
          }
        }
      } else {
        if (state.order!.deliveryId != null) {
          await _sendLocationUseCase.call(
            params: DeliveryUseCaseParams(
              from: state.order!.deliveryId!.toString(),
              to: state.order!.customerId.toString(),
              orderID: state.order!.id!.toString(),
              location: LocationEntity(
                latitude: event.currentPosition.latitude,
                longitude: event.currentPosition.longitude,
              ),
            ),
          );
        }

        emit(
          DeliveryStateUpdateLocation(
            event.currentPosition,
            false,
            order: state.order,
            polylines: state.polylines,
          ),
        );
      }
    } else {
      emit(DeliveryStateUpdateLocation(event.currentPosition, false));
    }
  }

  void onPick(DeliveryPickEvent event, Emitter<DeliveryState> emit) async {
    final double distance = _locationService.calculateDistance(
        event.currentPosition.latitude,
        event.currentPosition.longitude,
        event.order!.origin.latitude,
        event.order!.origin.longitude);
    Polylines updatedPolyLines = Polylines(
        walkingPolylinefromOriginToDest:
            state.polylines!.walkingPolylinefromOriginToDest,
        fromOriginToDestination: state.polylines!.fromOriginToDestination);

    if (distance > 150) {
      emit(const DeliveryStateMessage(
          'You are too far away from pick up point.'));
    } else {
      await _pickOrderUseCase.call(params: event.order);
      emit(DeliveryStateOrderPicked(event.order!, updatedPolyLines));
      emit(DeliveryStateMessage("You have picked the order",
          order: event.order!, polylines: updatedPolyLines));
    }
  }

  void onDrop(DeliveryDropEvent event, Emitter<DeliveryState> emit) async {
    final double distance = _locationService.calculateDistance(
        event.currentPosition.latitude,
        event.currentPosition.longitude,
        state.order!.destination.latitude,
        state.order!.destination.longitude);
    if (distance > 150) {
      emit(DeliveryStateMessage('You are too far away from drop off point.',
          order: state.order, polylines: state.polylines));
    } else {
      await _completeOrderUseCase.call(params: event.finishCode);
      emit(const DeliveryStateFinished());
    }
  }

  void onDisconnect(
      DeliveryDisconnectEvent event, Emitter<DeliveryState> emit) async {
    await _disconnectUsecase.call();
    _closeErrorStreamUseCase.call();
    _closeSocketStreamUseCase.call();
  }
}


