import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';


class RequestMetadata {
  final String traceId;
  final String logicHash;

  const RequestMetadata({required this.traceId, required this.logicHash});

  Map<String, String> toHeaders() => <String, String>{
        'trace_id': traceId,
        'logic_hash': logicHash,
      };
}

abstract class MetadataHeaderGenerator {
  MetadataHeaderGenerator._();

  static const Uuid _uuid = Uuid();

  static RequestMetadata generate(Map<String, dynamic> payload) {
    final String traceId = _uuid.v4();
    final String logicHash = _hashPayload(payload);
    return RequestMetadata(traceId: traceId, logicHash: logicHash);
  }


  static String _hashPayload(Map<String, dynamic> payload) {
    final Map<String, dynamic> sorted = Map.fromEntries(
      payload.entries.toList()
        ..sort((MapEntry<String, dynamic> a, MapEntry<String, dynamic> b) =>
            a.key.compareTo(b.key)),
    );
    final String canonical = jsonEncode(sorted);
    final Digest digest = sha256.convert(utf8.encode(canonical));
    return digest.toString();
  }
}
