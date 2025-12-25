class RoomEntity {
  const RoomEntity({
    required this.id,
    required this.propertyId,
    required this.code,
    this.name,
    this.description,
    this.status,
    this.capacity,
    this.currentOccupants,
    required this.monthlyRent,
    this.depositAmount,
    this.areaSqm,
    this.roomType,
    this.amenities,
    this.utilitiesIncluded,
    this.images,
    this.rules,
    required this.createdAt,
  });

  final String id;
  final String propertyId;
  final String code;
  final String? name;
  final String? description;
  final String? status;
  final int? capacity;
  final int? currentOccupants;
  final double monthlyRent;
  final double? depositAmount;
  final double? areaSqm;
  final String? roomType;
  final Map<String, dynamic>? amenities;
  final Map<String, dynamic>? utilitiesIncluded;
  final List<String>? images;
  final String? rules;
  final DateTime createdAt;

  // Helper getters
  String get displayName => name ?? 'Phòng $code';

  String get statusInVietnamese {
    switch (status) {
      case 'AVAILABLE':
        return 'Còn trống';
      case 'OCCUPIED':
        return 'Đã cho thuê';
      case 'MAINTENANCE':
        return 'Đang bảo trì';
      default:
        return status ?? 'Không xác định';
    }
  }

  bool get isAvailable => status == 'AVAILABLE';

  bool get isFull =>
      capacity != null &&
      currentOccupants != null &&
      currentOccupants! >= capacity!;
}
