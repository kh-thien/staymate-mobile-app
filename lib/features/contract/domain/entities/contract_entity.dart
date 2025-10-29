class ContractEntity {
  const ContractEntity({
    required this.id,
    required this.roomId,
    this.tenantId,
    this.contractNumber,
    required this.status,
    this.startDate,
    this.endDate,
    required this.monthlyRent,
    this.deposit = 0.0,
    this.paymentCycle,
    required this.createdAt,
  });

  final String id;
  final String roomId;
  final String? tenantId;
  final String? contractNumber;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double monthlyRent;
  final double deposit;
  final String? paymentCycle;
  final DateTime createdAt;

  String get statusInVietnamese {
    switch (status) {
      case 'DRAFT':
        return 'Nháp';
      case 'ACTIVE':
        return 'Đang hoạt động';
      case 'EXPIRED':
        return 'Hết hạn';
      case 'TERMINATED':
        return 'Đã chấm dứt';
      default:
        return status;
    }
  }
}
