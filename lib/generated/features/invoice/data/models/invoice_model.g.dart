// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/invoice/data/models/invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) => InvoiceModel(
  id: json['id'] as String,
  contractId: json['contract_id'] as String?,
  roomId: json['room_id'] as String?,
  tenantId: json['tenant_id'] as String?,
  billNumber: json['bill_number'] as String?,
  status: $enumDecode(
    _$BillStatusEnumMap,
    json['status'],
    unknownValue: BillStatus.unpaid,
  ),
  periodStart: json['period_start'] == null
      ? null
      : DateTime.parse(json['period_start'] as String),
  periodEnd: json['period_end'] == null
      ? null
      : DateTime.parse(json['period_end'] as String),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  totalAmount: (json['total_amount'] as num).toDouble(),
  lateFee: (json['late_fee'] as num).toDouble(),
  discountAmount: (json['discount_amount'] as num).toDouble(),
  billType: json['bill_type'] as String?,
  notes: json['notes'] as String?,
  roomCode: json['room_code'] as String?,
  roomName: json['room_name'] as String?,
  tenantName: json['tenant_name'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  billItems:
      (json['bill_items'] as List<dynamic>?)
          ?.map((e) => BillItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$InvoiceModelToJson(InvoiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contract_id': instance.contractId,
      'room_id': instance.roomId,
      'tenant_id': instance.tenantId,
      'bill_number': instance.billNumber,
      'status': _$BillStatusEnumMap[instance.status]!,
      'period_start': instance.periodStart?.toIso8601String(),
      'period_end': instance.periodEnd?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'total_amount': instance.totalAmount,
      'late_fee': instance.lateFee,
      'discount_amount': instance.discountAmount,
      'bill_type': instance.billType,
      'notes': instance.notes,
      'room_code': instance.roomCode,
      'room_name': instance.roomName,
      'tenant_name': instance.tenantName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'bill_items': instance.billItems.map((e) => e.toJson()).toList(),
    };

const _$BillStatusEnumMap = {
  BillStatus.unpaid: 'UNPAID',
  BillStatus.paid: 'PAID',
  BillStatus.overdue: 'OVERDUE',
  BillStatus.cancelled: 'CANCELLED',
  BillStatus.partiallyPaid: 'PARTIALLY_PAID',
};
