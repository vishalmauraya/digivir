import 'package:flutter_test/flutter_test.dart';
import 'package:habotconnect_lsa_verification/app/core/security/metadata_header_generator.dart';

void main() {
  group('MetadataHeaderGenerator', () {
    test('generates a well-formed UUID v4 trace_id each call', () {
      final metadataA = MetadataHeaderGenerator.generate({'a': 1});
      final metadataB = MetadataHeaderGenerator.generate({'a': 1});

      final uuidPattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: false,
      );

      expect(uuidPattern.hasMatch(metadataA.traceId), isTrue);
      expect(metadataA.traceId, isNot(equals(metadataB.traceId)));
    });

    test('logic_hash is deterministic regardless of key insertion order', () {
      final metadataA =
          MetadataHeaderGenerator.generate({'b': 2, 'a': 1});
      final metadataB =
          MetadataHeaderGenerator.generate({'a': 1, 'b': 2});

      expect(metadataA.logicHash, equals(metadataB.logicHash));
      expect(metadataA.logicHash.length, 64); // SHA-256 hex length
    });

    test('logic_hash changes when payload content changes', () {
      final metadataA = MetadataHeaderGenerator.generate({'a': 1});
      final metadataB = MetadataHeaderGenerator.generate({'a': 2});

      expect(metadataA.logicHash, isNot(equals(metadataB.logicHash)));
    });
  });
}
