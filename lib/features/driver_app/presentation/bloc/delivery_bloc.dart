import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';
import 'package:flutter_delivery/features/driver_app/domain/repository/driver_repository.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/accept_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/close_error_stream.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/close_socket_stream.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/complete_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/disconnect.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/initalize_socket.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/on_line.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/pick_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/stream_order.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/send_location.dart';
import 'package:flutter_delivery/features/driver_app/domain/usecase/server_error.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;


part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final AcceptOrderUseCase _acceptOrderUseCase;
  final CompleteOrderUseCase _completeOrderUseCase;
  final DisconnectUsecase _disconnectUsecase;
  final InitializeUseCase _initializeUseCase;
  final OnLineUseCase _onLineUseCase;
  final PickOrderUseCase _pickOrderUseCase;
  final SendLocationUseCase _sendLocationUseCase;
  final StreamOrderUseCase _requestToTakeOrderUseCase;
  final ServerErrorUseCase _serverErrorUseCase;
  final CloseErrorStreamUseCase _closeErrorStreamUseCase;
  final CloseSocketStreamUseCase _closeSocketStreamUseCase; 
  DeliveryBloc(
    this._acceptOrderUseCase,
    this._completeOrderUseCase,
    this._disconnectUsecase,
    this._initializeUseCase,
    this._onLineUseCase,
    this._pickOrderUseCase,
    this._sendLocationUseCase,
    this._requestToTakeOrderUseCase,
    this._serverErrorUseCase,
    this._closeErrorStreamUseCase,
    this._closeSocketStreamUseCase,
  ) : super(const DeliveryStateLoading()) {
    on<DeliveryFindCustomerEvent>(
      (event, emit) {},
    );
    on<DeliveryPickEvent>(
      (event, emit) {},
    );
    on<DeliveryDropEvent>(
      (event, emit) {},
    );
  }

}
