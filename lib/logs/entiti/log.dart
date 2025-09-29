class Log {
  final String message;
  final DateTime timestamp;

  Log({required this.message, DateTime? timestamp})
      : this.timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return '[$timestamp] $message';
  }

}