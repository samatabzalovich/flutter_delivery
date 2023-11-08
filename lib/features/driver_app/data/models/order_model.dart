
import 'package:flutter_delivery/core/enum/user_enums.dart';
import 'package:flutter_delivery/features/driver_app/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.isCompleted,
    required super.destination,
    required super.origin,
    required super.destinationAddress,
    required super.originAddress,
    required super.deliveryId,
    required super.customerId,
    required super.deliveryState,
    required super.version,
    required super.finishCode
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt!.millisecondsSinceEpoch,
      'updatedAt': updatedAt!.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'destination': destination.toMap(),
      'origin': origin.toMap(),
      'destinationAddress': destinationAddress,
      'originAddress': originAddress,
      'deliveryId': deliveryId,
      'customerId': customerId,
      'deliveryState': deliveryState.name,
      'version': version,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? 0 ,
      createdAt: DateTime.parse(map['createdAt'] ),
      updatedAt: DateTime.parse(map['updatedAt'] ),
      isCompleted: map['isCompleted'] ?? false,
      destination: LocationEntity.fromMap(map['destination'] as Map<String,dynamic>),
      origin: LocationEntity.fromMap(map['origin'] as Map<String,dynamic>),
      destinationAddress: map['destinationAddress'] as String,
      originAddress: map['originAddress'] as String,
      deliveryId: map['deliveryId'],
      customerId: map['customerId'] as int,
      deliveryState: OrderState.searching.getValueFromString(map['deliveryState']),
      version: map['version'] ?? 0,
      finishCode: map['finishCode'] ?? ''
    );
  }


  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id ,
      createdAt: entity.createdAt ,
      updatedAt: entity.updatedAt ,
      isCompleted: entity.isCompleted ,
      destination: entity.destination ,
      origin: entity.origin ,
      destinationAddress:entity. destinationAddress ,
      originAddress: entity.originAddress ,
      deliveryId: entity.deliveryId ,
      customerId: entity.customerId ,
      deliveryState: entity.deliveryState ,
      version: entity.version ,
      finishCode: entity.finishCode
    );
  }

}
