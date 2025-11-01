class BillItem {
  final String id;
  final String billId;
  final String description;
  final String? serviceId;
  final String? serviceName;
  final String? serviceType;
  final String? unit;
  final double quantity;
  final double unitPrice;
  final double amount;
  final DateTime createdAt;

  const BillItem({
    required this.id,
    required this.billId,
    required this.description,
    this.serviceId,
    this.serviceName,
    this.serviceType,
    this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.createdAt,
  });
}
