String formatTimeAgo(Duration age) {
  final minutes = age.inMinutes;
  if (minutes < 60) {
    return '${minutes}m ago';
  }

  final hours = age.inHours;
  if (hours < 24) {
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    }
    final hourLabel = hours == 1 ? '1 hour' : '$hours hours';
    return '$hourLabel ${remainingMinutes}m ago';
  }

  final days = age.inDays;
  if (days < 7) {
    return days == 1 ? '1 day ago' : '$days days ago';
  }

  if (days < 30) {
    final weeks = days ~/ 7;
    return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
  }

  if (days < 365) {
    final months = days ~/ 30;
    return months == 1 ? '1 month ago' : '$months months ago';
  }

  final years = days ~/ 365;
  return years == 1 ? '1 year ago' : '$years years ago';
}
