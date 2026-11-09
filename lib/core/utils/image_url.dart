import 'constants.dart';

/// The backend bakes broken absolute URLs (a hardcoded dev-machine path/host)
/// into several endpoints' image fields. Always rebuild from `/uploads`
/// onward against our own configured base URL instead of trusting whatever
/// host the server returned.
String resolveImageUrl(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  if (raw.startsWith('data:')) return raw;

  final uploadsIndex = raw.indexOf('/uploads');
  final path = uploadsIndex != -1 ? raw.substring(uploadsIndex) : raw;

  if (path.startsWith('http')) return path;
  return '${AppConstants.baseUrl}${path.startsWith('/') ? path : '/$path'}';
}
