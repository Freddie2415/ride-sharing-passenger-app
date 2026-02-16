/// Formats a [DateTime] as a human-readable relative time string.
String formatTimeAgo(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';

  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  return '$day.$month.${dateTime.year}';
}
