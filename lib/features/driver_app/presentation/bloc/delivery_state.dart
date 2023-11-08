// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delivery_bloc.dart';

abstract class DeliveryState extends Equatable {
  final OrderEntity? order;
  final Position? currentLocation;
  final List<LatLng>? polylineResult;
  final List<mapTool.LatLng>? polylineResultForMapToolPlugin;

  const DeliveryState({
    this.order,
    this.currentLocation,
    this.polylineResult,
    this.polylineResultForMapToolPlugin,
  });
  @override
  List<Object> get props => [order!];
}

class DeliveryStateLoading extends DeliveryState {
  const DeliveryStateLoading();
}

class DeliveryStateSearchingCustomer extends DeliveryState {
  const DeliveryStateSearchingCustomer();
}

class DeliveryStateFoundCustomer extends DeliveryState {
  const DeliveryStateFoundCustomer(OrderEntity order) : super(order: order);
}

class DeliveryStateFinished extends DeliveryState {
  const DeliveryStateFinished(OrderEntity customer) : super(order: customer);
}

class DeliveryStateUpdateLocation extends DeliveryState {
  const DeliveryStateUpdateLocation(Position currentLocation)
      : super(currentLocation: currentLocation);
}

class DeliveryStatePolylineUpdated extends DeliveryState {
  const DeliveryStatePolylineUpdated(List<LatLng> res, List<mapTool.LatLng>? polylineResultForMapToolPlugin)
      : super(polylineResult: res, polylineResultForMapToolPlugin: polylineResultForMapToolPlugin);
}