class RouteAssistantException implements Exception {
  final String message;
  final bool isRetryable;

  const RouteAssistantException(this.message, {this.isRetryable = true});

  @override
  String toString() => message;
}
