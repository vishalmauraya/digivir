import 'package:flutter_test/flutter_test.dart';
import 'package:habotconnect_lsa_verification/app/core/security/fail_closed_validator.dart';
import 'package:habotconnect_lsa_verification/app/data/models/lsa_profile_model.dart';

void main() {
  group('FailClosedValidator', () {
    const LSAProfileModel validProfile = LSAProfileModel(
      fullName: 'Amara Okafor',
      email: 'amara.okafor@example.com',
      phone: '+2348000000000',
      certificationNumber: 'LSA-CERT-2026-00931',
      yearsOfExperience: 4,
      bio: 'Experienced LSA specializing in dyslexia support.',
      predecessorId: 'PRED-APPLICATION-4471',
    );

    test('Test Case 1 — Valid Submission passes every gate', () {
      final result = FailClosedValidator.validate(validProfile);
      expect(result.isValid, isTrue);
      expect(result.quarantineReason, isNull);
    });

    test(
      'Test Case 2 — Missing Lineage (null predecessor_id) is quarantined',
      () {
        final LSAProfileModel orphanProfile = LSAProfileModel(
          fullName: validProfile.fullName,
          email: validProfile.email,
          phone: validProfile.phone,
          certificationNumber: validProfile.certificationNumber,
          yearsOfExperience: validProfile.yearsOfExperience,
          bio: validProfile.bio,
          predecessorId: null, // orphan record — no upstream lineage
        );
        final result = FailClosedValidator.validate(orphanProfile);
        expect(result.isValid, isFalse);
        expect(result.quarantineReason, contains('predecessor_id'));
      },
    );

    test(
      'Test Case 3 — Fail-Closed Error State: null field halts immediately',
      () {
        final LSAProfileModel invalidProfile = LSAProfileModel(
          fullName: validProfile.fullName,
          email: null, // simulates a null compliance field response
          phone: validProfile.phone,
          certificationNumber: validProfile.certificationNumber,
          yearsOfExperience: validProfile.yearsOfExperience,
          bio: validProfile.bio,
          predecessorId: validProfile.predecessorId,
        );
        final result = FailClosedValidator.validate(invalidProfile);
        expect(result.isValid, isFalse);
        expect(result.quarantineReason, isNotNull);
      },
    );

    test('rejects malformed email', () {
      final LSAProfileModel badEmail =
          validProfile.copyWith(email: 'not-an-email');
      final result = FailClosedValidator.validate(badEmail);
      expect(result.isValid, isFalse);
    });

    test('rejects out-of-bounds years of experience', () {
      final LSAProfileModel badYears =
          validProfile.copyWith(yearsOfExperience: -1);
      final result = FailClosedValidator.validate(badYears);
      expect(result.isValid, isFalse);
    });
  });
}
