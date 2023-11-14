// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delivery_bloc.dart';

abstract class DeliveryState extends Equatable {
  final OrderEntity? order;
  final Polylines? polylines;
  final List<LatLng>? polyline;
  const DeliveryState({
    this.order,
    this.polylines,
    this.polyline,
  });

  @override
  List<Object?> get props => [order, polylines, polyline];
}

class DeliveryStateLoading extends DeliveryState {
  const DeliveryStateLoading();
}

class DeliveryStateOffLine extends DeliveryState {
  const DeliveryStateOffLine();
}

class DeliveryStateSearchingCustomer extends DeliveryState {
  const DeliveryStateSearchingCustomer();
}

class DeliveryStateFoundCustomer extends DeliveryState {
  const DeliveryStateFoundCustomer(Polylines polylines, OrderEntity orderEntity)
      : super(polylines: polylines, order: orderEntity,);
  @override
  List<Object> get props => [order!, polylines!];
}

class DeliveryStateOrderAccepted extends DeliveryState {
  const DeliveryStateOrderAccepted(OrderEntity order, Polylines polylines)
      : super(order: order, polylines: polylines);
}

class DeliveryStateOrderPicked extends DeliveryState {
  const DeliveryStateOrderPicked(OrderEntity order, Polylines polylines)
      : super(order: order, polylines: polylines);
}

class DeliveryStateFinished extends DeliveryState {
  const DeliveryStateFinished();
}

class DeliveryStateUpdateLocation extends DeliveryState {
  final Position currentLocation;
  final bool isPolylineUpdated;

  const DeliveryStateUpdateLocation(
      this.currentLocation, this.isPolylineUpdated,
      {OrderEntity? order, Polylines? polylines, List<LatLng>? polyline})
      : super(order: order, polylines: polylines, polyline: polyline);

  @override
  List<Object?> get props => [currentLocation, order];
}

class DeliveryStateMessage extends DeliveryState {
  final String message;
  const DeliveryStateMessage(this.message,
      {OrderEntity? order, Polylines? polylines})
      : super(order: order, polylines: polylines);
  @override
  List<Object?> get props => [message, order, polylines];
}

class DeliveryStatePolylineUpdated extends DeliveryState {
  final Position currentLocation;
  const DeliveryStatePolylineUpdated(this.currentLocation, Polylines polylines)
      : super(polylines: polylines);
  @override
  List<Object?> get props => [polylines];
}
