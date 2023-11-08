// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delivery_bloc.dart';

abstract class DeliveryEvent extends Equatable {
  final OrderEntity? order;
  final DeliveryUseCaseParams? deliveryLocation;
  final LocationEntity? destination;
  final LocationEntity? origin;
  const DeliveryEvent({
    this.order,
    this.deliveryLocation,
    this.destination,
    this.origin,
  });
  @override
  List<Object> get props => [order!, deliveryLocation!];
}

class DeliveryFindCustomerEvent extends DeliveryEvent {
  const DeliveryFindCustomerEvent(DeliveryUseCaseParams deliveryUseCaseParams)
      : super(deliveryLocation: deliveryUseCaseParams);
}

class DeliveryPickEvent extends DeliveryEvent {
  const DeliveryPickEvent(OrderEntity order) : super(order: order);
}

class DeliveryDropEvent extends DeliveryEvent {
  const DeliveryDropEvent(OrderEntity order) : super(order: order);
}

class DeliveryGetLocationEvent extends DeliveryEvent {
  const DeliveryGetLocationEvent();
}

class DeliveryGetPolylineEvent extends DeliveryEvent {
  const DeliveryGetPolylineEvent(LocationEntity origin, LocationEntity destination) : super(origin: origin, destination: destination);
}
