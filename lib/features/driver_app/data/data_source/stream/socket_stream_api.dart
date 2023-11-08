import 'package:flutter_delivery/features/driver_app/data/models/order_model.dart';

abstract class SocketStreamApiService {
  Stream<OrderModel> streamOrder();
  void close();
}