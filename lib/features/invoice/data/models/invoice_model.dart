import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/invoice.dart';
import 'bill_item_model.dart';

part '../../../../generated/features/invoice/data/models/invoice_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class InvoiceModel {
  final String id;
  final String? contractId;
  final String? roomId;
  final String? tenantId;
  final String? billNumber;
  final String? name;
  @JsonKey(unknownEnumValue: BillStatus.unpaid)
  final BillStatus status;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? dueDate;
  final double totalAmount;
  final double lateFee;
  final double discountAmount;
  final String? billType;
  final String? notes;
  final String? roomCode;
  final String? roomName;
  final String? tenantName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BillItemModel> billItems;

  const InvoiceModel({
    required this.id,
    this.contractId,
    this.roomId,
    this.tenantId,
    this.billNumber,
    this.name,
    required this.status,
    this.periodStart,
    this.periodEnd,
    this.dueDate,
    required this.totalAmount,
    required this.lateFee,
    required this.discountAmount,
    this.billType,
    this.notes,
    this.roomCode,
    this.roomName,
    this.tenantName,
    required this.createdAt,
    required this.updatedAt,
    this.billItems = const [],
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceModelToJson(this);

  Invoice toEntity() {
    return Invoice(
      id: id,
      contractId: contractId,
      roomId: roomId,
      tenantId: tenantId,
      billNumber: billNumber,
      name: name,
      status: status,
      periodStart: periodStart,
      periodEnd: periodEnd,
      dueDate: dueDate,
      totalAmount: totalAmount,
      lateFee: lateFee,
      discountAmount: discountAmount,
      billType: billType,
      notes: notes,
      roomCode: roomCode,
      roomName: roomName,
      tenantName: tenantName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: billItems.map((item) => item.toEntity()).toList(),
    );
  }
}
