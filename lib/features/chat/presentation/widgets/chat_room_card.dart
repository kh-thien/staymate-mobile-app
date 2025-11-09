import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/chat_room.dart';

/// Chat room card widget for displaying room in list
class ChatRoomCard extends StatelessWidget {
  final ChatRoom room;
  final VoidCallback onTap;

  const ChatRoomCard({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final lastMessage = room.messages?.isNotEmpty == true
        ? room.messages!.first
        : null;

    final unreadCount = _getUnreadCount();
    final address = _getAddress();
    final propertyName = room.room?.properties?.name ?? '';
    final roomCode = room.room?.code;
    final ownerAvatar = room.room?.properties?.owner?.avatar;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unreadCount > 0 ? Colors.blue.withOpacity(0.03) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: unreadCount > 0
                ? Colors.blue.withOpacity(0.2)
                : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Address Avatar - show location icon or property image
            _buildAddressAvatar(ownerAvatar, address),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address with better typography
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMessage != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _formatTimestamp(lastMessage.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Property name with room code and icon
                  if (propertyName.isNotEmpty || roomCode != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.apartment_rounded,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            propertyName.isNotEmpty && roomCode != null
                                ? '$propertyName - $roomCode'
                                : propertyName.isNotEmpty
                                    ? propertyName
                                    : roomCode != null
                                        ? 'Phòng $roomCode'
                                        : '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                  // Last message with better styling
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage != null
                              ? _formatLastMessage(
                                  lastMessage.content,
                                  lastMessage.messageType,
                                )
                              : 'Chưa có tin nhắn',
                          style: TextStyle(
                            fontSize: 14,
                            color: unreadCount > 0
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red[500]!, Colors.red[700]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAddress() {
    final property = room.room?.properties;
    if (property != null) {
      // Format: address, ward, city (excluding district)
      final parts = <String>[
        property.address,
        if (property.ward != null && property.ward!.isNotEmpty) property.ward!,
        if (property.city != null && property.city!.isNotEmpty) property.city!,
      ];
      return parts.join(', ');
    }
    return 'Địa chỉ không xác định';
  }

  int _getUnreadCount() {
    // Get real current user ID
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) return 0;

    if (room.participants == null || room.messages == null) return 0;

    try {
      final participant = room.participants!.firstWhere(
        (p) => p.userId == currentUserId,
      );

      // Count messages after lastReadAt that are NOT from current user
      final unreadMessages = room.messages!
          .where(
            (msg) =>
                msg.createdAt.isAfter(participant.lastReadAt) &&
                msg.senderId != currentUserId, // Exclude own messages
          )
          .toList();

      return unreadMessages.length;
    } catch (e) {
      print('❌ [ChatRoomCard] Error getting unread count: $e');
      return 0;
    }
  }

  String _formatLastMessage(String content, String messageType) {
    switch (messageType) {
      case 'IMAGE':
        return '📷 Hình ảnh';
      case 'FILE':
        return '📎 File';
      default:
        return content;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    // Convert UTC timestamp to local time
    final localTimestamp = timestamp.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localTimestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(localTimestamp);
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'vi').format(localTimestamp);
    } else {
      return DateFormat('dd/MM').format(localTimestamp);
    }
  }

  /// Build address avatar with network image or fallback to location icon
  Widget _buildAddressAvatar(String? avatarUrl, String address) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      // Show network image
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            avatarUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) {
              // Fallback to location icon if image fails
              return _buildLocationIcon();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // Fallback to location icon
      return _buildLocationIcon();
    }
  }

  /// Build location icon with gradient
  Widget _buildLocationIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.location_on,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
