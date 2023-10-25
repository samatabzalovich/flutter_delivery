part of 'delivery_bloc.dart';

@immutable
sealed class DeliveryState extends Equatable {
  final CustomerEntity? customer;
  const DeliveryState({this.customer});
  @override
  List<Object> get props => [customer!];
}

final class DeliveryStateLoading extends DeliveryState {
  const DeliveryStateLoading();
}

class DeliveryStateFoundCustomer extends DeliveryState {
  const DeliveryStateFoundCustomer(CustomerEntity customer) : super(customer: customer);
}

class DeliveryStateFinished extends DeliveryState {
  const DeliveryStateFinished(CustomerEntity customer) : super(customer: customer);
}



