part of 'delivery_bloc.dart';

@immutable
sealed class DeliveryEvent extends Equatable {
  final CustomerEntity? customer;
  const DeliveryEvent({this.customer});
  @override
  List<Object> get props => [customer!];
}

class DeliveryFindCustomerEvent extends DeliveryEvent{
  const DeliveryFindCustomerEvent();
}

class DeliveryPickEvent extends DeliveryEvent {
  const DeliveryPickEvent(CustomerEntity customer) : super(customer: customer);
}

class DeliveryDropEvent extends DeliveryEvent {
  const DeliveryDropEvent(CustomerEntity customer) : super(customer: customer);
}
