import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_delivery/features/rider_app/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  DeliveryBloc() : super(const DeliveryStateLoading()) {
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
