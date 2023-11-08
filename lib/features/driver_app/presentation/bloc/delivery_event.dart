// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delivery_bloc.dart';

abstract class DeliveryEvent extends Equatable {
  final OrderEntity? order;
  final Polylines? polylines;
  const DeliveryEvent({this.order, this.polylines});

  @override
  List<Object?> get props => [order, polylines];
}

class DeliveryInitEvent extends DeliveryEvent {
  const DeliveryInitEvent();
  @override
  List<Object> get props => [];
}

class DeliveryInitMapEvent extends DeliveryEvent {
  final String token;
  final GoogleMapController mapController;
  const DeliveryInitMapEvent(
    this.mapController,
    this.token
  );
  @override
  List<Object> get props => [mapController, token];
}

class DeliveryInitSocketEvent extends DeliveryEvent {
  final String token;
  const DeliveryInitSocketEvent(
    this.token,
  );
  @override
  List<Object> get props => [token];
}

class DeliveryFindCustomerEvent extends DeliveryEvent {
  final DeliveryUseCaseParams deliveryLocation;

  const DeliveryFindCustomerEvent(this.deliveryLocation);
  @override
  List<Object> get props => [deliveryLocation];
}

class DeliveryAcceptOrderEvent extends DeliveryEvent {
  final Position currentPosition;
  const DeliveryAcceptOrderEvent(
      OrderEntity order, Polylines polylines, this.currentPosition)
      : super(order: order, polylines: polylines);
  @override
  List<Object> get props => [order!, polylines!, currentPosition];
}

class DeliveryOffLineEvent extends DeliveryEvent {
  const DeliveryOffLineEvent();
}

class DeliveryFoundCustomerEvent extends DeliveryEvent {
  const DeliveryFoundCustomerEvent(OrderEntity order) : super(order: order);
  @override
  List<Object> get props => [order!];
}

class DeliveryOrderExistsEvent extends DeliveryEvent {
  const DeliveryOrderExistsEvent(OrderEntity order) : super(order: order);
  @override
  List<Object> get props => [order!];
}

class DeliveryPickEvent extends DeliveryEvent {
  final Position currentPosition;

  const DeliveryPickEvent(
      OrderEntity order, Polylines polylines, this.currentPosition)
      : super(order: order, polylines: polylines);
  @override
  List<Object> get props => [order!, polylines!, currentPosition];
}

class DeliveryDropEvent extends DeliveryEvent {
  final Position currentPosition;
  final String finishCode;
  const DeliveryDropEvent(
    this.currentPosition,
    this.finishCode,
  );
  @override
  List<Object> get props => [currentPosition, finishCode];
}

class DeliveryGetLocationEvent extends DeliveryEvent {
  const DeliveryGetLocationEvent();
}

class DeliveryDisconnectEvent extends DeliveryEvent {
  const DeliveryDisconnectEvent();
}

class DeliveryReceivedLocationEvent extends DeliveryEvent {
  final Position currentPosition;

  const DeliveryReceivedLocationEvent(this.currentPosition);
  @override
  List<Object> get props => [currentPosition];
}

class DeliveryGetPolylineEvent extends DeliveryEvent {
  const DeliveryGetPolylineEvent(OrderEntity order) : super(order: order);
  @override
  List<Object> get props => [order!];
}

class DeliveryMessageEvent extends DeliveryEvent {
  final String message;

  const DeliveryMessageEvent(this.message,
      {OrderEntity? order, Polylines? polylines})
      : super(order: order, polylines: polylines);
  @override
  List<Object?> get props => [message, order, polylines];
}
