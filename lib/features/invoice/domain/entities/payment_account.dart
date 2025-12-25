class PaymentAccount {
  final String id;
  final String userId;
  final String bankCode;
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String? branch;
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? acqId;

  const PaymentAccount({
    required this.id,
    required this.userId,
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    this.branch,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.acqId,
  });
}
