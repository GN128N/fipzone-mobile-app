import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Production API. Override at build time with:
///   flutter build apk --dart-define=FIP_API=https://staging.example.com
const String siteBase = String.fromEnvironment(
  'FIP_API',
  defaultValue: 'https://fipzone.com',
);
const String apiBase = '$siteBase/api/v1';

/// Tournament states that are safe to display in the public mobile app.
/// Draft, submitted and approved records are internal workflow states.
const publicTournamentStates = <String>{
  'published',
  'registration_open',
  'registration_closed',
  'in_progress',
  'results_pending',
  'final',
};

bool isPublicTournament(Map<String, dynamic> tournament) =>
    publicTournamentStates.contains(
      (tournament['state'] ?? '').toString().toLowerCase(),
    );

String? assetUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith('/')) return '$siteBase$path';
  return '$siteBase/$path';
}

class ApiException implements Exception {
  final String message;
  final int? status;
  ApiException(this.message, {this.status});
  @override
  String toString() => 'ApiException($status): $message';
}

Future<dynamic> apiGet(String path, {Map<String, String>? query}) async {
  final uri = Uri.parse(
    '$apiBase$path',
  ).replace(queryParameters: query == null || query.isEmpty ? null : query);
  final res = await http
      .get(uri, headers: {'Accept': 'application/json'})
      .timeout(const Duration(seconds: 12));
  if (res.statusCode >= 400) {
    throw ApiException(
      'HTTP ${res.statusCode} for $uri',
      status: res.statusCode,
    );
  }
  if (res.body.isEmpty) return null;
  return jsonDecode(res.body);
}

Future<List<Map<String, dynamic>>> fetchTournaments({String? state}) async {
  final body = await apiGet(
    '/tournaments',
    query: {if (state != null) 'state': state, 'per': '50'},
  );
  final data =
      (body is Map && body['data'] is List)
          ? (body['data'] as List)
          : const <dynamic>[];
  return [
    for (final r in data)
      if (isPublicTournament(Map<String, dynamic>.from(r as Map)))
        Map<String, dynamic>.from(r as Map),
  ];
}

Future<List<Map<String, dynamic>>> fetchFederations() async {
  final body = await apiGet('/federations');
  final data =
      (body is Map && body['data'] is List)
          ? (body['data'] as List)
          : const <dynamic>[];
  return [for (final r in data) Map<String, dynamic>.from(r as Map)];
}

Future<Map<String, dynamic>> fetchLive() async {
  final body = await apiGet('/live');
  if (body is Map) return Map<String, dynamic>.from(body);
  return {'matches': const <dynamic>[]};
}

Future<List<Map<String, dynamic>>> fetchResults() async {
  final body = await apiGet('/results', query: {'per': '25'});
  final data =
      (body is Map && body['data'] is List)
          ? (body['data'] as List)
          : const <dynamic>[];
  return [for (final r in data) Map<String, dynamic>.from(r as Map)];
}

Future<List<Map<String, dynamic>>> fetchPlayers() async {
  final body = await apiGet('/players', query: {'per': '50'});
  final data =
      (body is Map && body['data'] is List)
          ? (body['data'] as List)
          : const <dynamic>[];
  return [for (final r in data) Map<String, dynamic>.from(r as Map)];
}

Future<List<Map<String, dynamic>>> fetchClubs() async {
  final body = await apiGet('/clubs', query: {'per': '50'});
  final data =
      (body is Map && body['data'] is List)
          ? (body['data'] as List)
          : const <dynamic>[];
  return [for (final r in data) Map<String, dynamic>.from(r as Map)];
}

Future<Map<String, dynamic>> fetchGallery() async {
  final body = await apiGet('/gallery');
  if (body is! Map) {
    return {'data': const <dynamic>[], 'categories': const <String>[]};
  }
  return Map<String, dynamic>.from(body);
}

/// Emoji flag for a two-letter ISO country code (e.g. "NG" → 🇳🇬).
/// Returns a neutral flag when the code is missing or invalid.
String flagEmoji(String? iso) {
  if (iso == null || iso.length != 2) return '🏳️';
  final cc = iso.toUpperCase();
  final a = cc.codeUnitAt(0), b = cc.codeUnitAt(1);
  if (a < 0x41 || a > 0x5A || b < 0x41 || b > 0x5A) return '🏳️';
  return String.fromCharCodes([
    0x1F1E6 + (a - 0x41),
    0x1F1E6 + (b - 0x41),
  ]);
}

/// Generic loader widget: renders [onLoading] while fetching, [onError] on error,
/// [onData] when data arrives. Keeps call sites short.
class ApiBuilder<T> extends StatefulWidget {
  final Future<T> Function() load;
  final Widget Function(BuildContext, T) onData;
  final Widget Function(BuildContext)? onLoading;
  final Widget Function(BuildContext, Object error, VoidCallback retry)?
  onError;
  const ApiBuilder({
    super.key,
    required this.load,
    required this.onData,
    this.onLoading,
    this.onError,
  });
  @override
  State<ApiBuilder<T>> createState() => _ApiBuilderState<T>();
}

class _ApiBuilderState<T> extends State<ApiBuilder<T>> {
  late Future<T> _future;
  @override
  void initState() {
    super.initState();
    _future = widget.load();
  }

  void _retry() => setState(() => _future = widget.load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return widget.onLoading?.call(c) ??
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
        }
        if (s.hasError) {
          return widget.onError?.call(c, s.error!, _retry) ??
              _DefaultApiError(error: s.error!, onRetry: _retry);
        }
        return widget.onData(c, s.data as T);
      },
    );
  }
}

class _DefaultApiError extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const _DefaultApiError({required this.error, required this.onRetry});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.cloud_off_outlined,
          size: 32,
          color: Color(0xFF9BA8A1),
        ),
        const SizedBox(height: 8),
        const Text(
          'Could not reach FIP Zone E server.',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Check your connection and that the API is reachable at $apiBase',
          style: const TextStyle(fontSize: 11, color: Color(0xFF637067)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Retry'),
        ),
      ],
    ),
  );
}
