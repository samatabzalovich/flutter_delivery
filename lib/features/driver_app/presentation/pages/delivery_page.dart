import 'package:flutter/material.dart';
import 'package:flutter_delivery/features/driver_app/presentation/widgets/delivery_body.dart';

class DeliveryPage extends StatelessWidget {
    static const String routeName = "/delivery-page";

  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: DeliveryBody()),
    );
  }
}