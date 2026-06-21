class JoinQrCodec {
  static const scheme = 'formationgo';
  static const host = 'join';

  static String encodeJoinQr(String passCode) {
    return '$scheme://$host?code=$passCode';
  }

  static String? parseJoinQr(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    if (RegExp(r'^\d{6}$').hasMatch(trimmed)) {
      return trimmed;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null &&
        uri.scheme == scheme &&
        uri.host == host &&
        uri.queryParameters['code'] != null) {
      final code = uri.queryParameters['code']!.trim();
      if (RegExp(r'^\d{6}$').hasMatch(code)) {
        return code;
      }
    }

    final codeMatch = RegExp(r'code=(\d{6})').firstMatch(trimmed);
    if (codeMatch != null) {
      return codeMatch.group(1);
    }

    return null;
  }
}
