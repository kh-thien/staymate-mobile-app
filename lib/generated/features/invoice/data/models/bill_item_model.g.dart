// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/invoice/data/models/bill_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillItemModel _$BillItemModelFromJson(Map<String, dynamic> json) =>
    BillItemModel(
      id: json['id'] as String,
      billId: json['bill_id'] as String,
      description: json['description'] as String,
      serviceId: json['service_id'] as String?,
      serviceName: json['service_name'] as String?,
      serviceType: json['service_type'] as String?,
      serviceUnit: json['service_unit'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BillItemModelToJson(BillItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bill_id': instance.billId,
      'description': instance.description,
      'service_id': instance.serviceId,
      'service_name': instance.serviceName,
      'service_type': instance.serviceType,
      'service_unit': instance.serviceUnit,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'amount': instance.amount,
      'created_at': instance.createdAt.toIso8601String(),
    };
