class PropertyEntity {
  const PropertyEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    this.city,
    this.district,
    this.ward,
    this.latitude,
    this.longitude,
    this.description,
    this.propertyType,
    this.totalFloors,
    this.totalRooms,
    this.amenities,
    this.contactPhone,
    this.contactEmail,
    this.isActive,
    required this.createdAt,
  });

  final String id;
  final String ownerId;
  final String name;
  final String address;
  final String? city;
  final String? district;
  final String? ward;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? propertyType;
  final int? totalFloors;
  final int? totalRooms;
  final Map<String, dynamic>? amenities;
  final String? contactPhone;
  final String? contactEmail;
  final bool? isActive;
  final DateTime createdAt;

  // Helper getters
  String get fullAddress {
    final parts = <String>[
      address,
      if (ward != null) ward!,
      if (district != null) district!,
      if (city != null) city!,
    ];
    return parts.join(', ');
  }

  String get propertyTypeInVietnamese {
    switch (propertyType) {
      case 'APARTMENT':
        return 'Chung cư';
      case 'HOUSE':
        return 'Nhà riêng';
      case 'DORMITORY':
        return 'Ký túc xá';
      case 'VILLA':
        return 'Biệt thự';
      default:
        return propertyType ?? 'Không xác định';
    }
  }

  bool get hasCoordinates => latitude != null && longitude != null;
}
