extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPhoneNumber {
    return RegExp(
      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
    ).hasMatch(this);
  }

  String removeExtraSpaces() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

extension DoubleExtension on double {
  String toCurrency({String symbol = 'đ'}) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return toString().replaceAllMapped(formatter, (Match m) => '${m[1]},') +
        ' $symbol';
  }
}

extension IntExtension on int {
  String toFormattedString() {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return toString().replaceAllMapped(formatter, (Match m) => '${m[1]},');
  }
}

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  String get formattedDate {
    return '$day/$month/$year';
  }

  String get formattedDateTime {
    return '$day/$month/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
