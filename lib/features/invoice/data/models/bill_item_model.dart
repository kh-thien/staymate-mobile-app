import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/bill_item.dart';

part '../../../../generated/features/invoice/data/models/bill_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BillItemModel {
  final String id;
  final String billId;
  final String description;
  final String? serviceId;
  final String? serviceName;
  final String? serviceType;
  final String? serviceUnit;
  final double quantity;
  final double unitPrice;
  final double amount;
  final DateTime createdAt;

  const BillItemModel({
    required this.id,
    required this.billId,
    required this.description,
    this.serviceId,
    this.serviceName,
    this.serviceType,
    this.serviceUnit,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.createdAt,
  });

  factory BillItemModel.fromJson(Map<String, dynamic> json) =>
      _$BillItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BillItemModelToJson(this);

  BillItem toEntity() {
    return BillItem(
      id: id,
      billId: billId,
      description: description,
      serviceId: serviceId,
      serviceName: serviceName,
      serviceType: serviceType,
      unit: serviceUnit,
      quantity: quantity,
      unitPrice: unitPrice,
      amount: amount,
      createdAt: createdAt,
    );
  }
}
