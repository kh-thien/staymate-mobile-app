import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/payment_account.dart';

part '../../../../generated/features/invoice/data/models/payment_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PaymentAccountModel {
  final String id;
  final String userId;
  final String bankCode;
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String? branch;
  final bool? isDefault;
  final bool? isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? acqId;

  const PaymentAccountModel({
    required this.id,
    required this.userId,
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    this.branch,
    this.isDefault,
    this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.acqId,
  });

  factory PaymentAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentAccountModelToJson(this);

  PaymentAccount toEntity() {
    return PaymentAccount(
      id: id,
      userId: userId,
      bankCode: bankCode,
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolder: accountHolder,
      branch: branch,
      isDefault: isDefault ?? false,
      isActive: isActive ?? true,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      acqId: acqId,
    );
  }
}
