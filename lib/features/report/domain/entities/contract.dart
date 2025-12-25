class Contract {
  final String id;
  final String? roomId;
  final String? tenantId;
  final String? propertyId;
  final String contractNumber;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  // Join fields
  final String? roomCode;
  final String? roomName;
  final String? propertyName;

  const Contract({
    required this.id,
    this.roomId,
    this.tenantId,
    this.propertyId,
    required this.contractNumber,
    required this.status,
    this.startDate,
    this.endDate,
    this.roomCode,
    this.roomName,
    this.propertyName,
  });
}
