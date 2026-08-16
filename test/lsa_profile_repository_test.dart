import 'package:flutter_test/flutter_test.dart';
import 'package:habotconnect_lsa_verification/app/core/network/api_exception.dart';
import 'package:habotconnect_lsa_verification/app/data/models/lsa_profile_model.dart';
import 'package:habotconnect_lsa_verification/app/data/models/submission_result.dart';
import 'package:habotconnect_lsa_verification/app/data/repositories/lsa_profile_repository_mock.dart';

void main() {
  final LSAProfileRepositoryMock repository = LSAProfileRepositoryMock();

  const LSAProfileModel base = LSAProfileModel(
    fullName: 'Amara Okafor',
    email: 'amara.okafor@example.com',
    phone: '+2348000000000',
    certificationNumber: 'LSA-CERT-2026-00931',
    yearsOfExperience: 4,
    bio: 'Experienced LSA specializing in dyslexia support.',
    predecessorId: 'PRED-APPLICATION-4471',
  );

  test('Test Case 1 — Valid Submission returns success with a trace_id', () async {
    final SubmissionResult result = await repository.submitProfile(base);
    expect(result.outcome, SubmissionOutcome.success);
    expect(result.traceId, isNotNull);
    expect(result.traceId, isNotEmpty);
  });

  test(
    'Test Case 2 — Missing Lineage throws QuarantinedException before any '
    '"network" call',
    () async {
      final LSAProfileModel orphan = LSAProfileModel(
        fullName: base.fullName,
        email: base.email,
        phone: base.phone,
        certificationNumber: base.certificationNumber,
        yearsOfExperience: base.yearsOfExperience,
        bio: base.bio,
        predecessorId: null,
      );

      expect(
        () => repository.submitProfile(orphan),
        throwsA(isA<QuarantinedException>()),
      );
    },
  );

  test(
    'Test Case 3 — Fail-Closed Error State: server-side rejection is '
    'surfaced as SubmissionOutcome.serverError, not silently accepted',
    () async {
      final LSAProfileModel simulatedServerError = LSAProfileModel(
        fullName: base.fullName,
        email: base.email,
        phone: base.phone,
        certificationNumber: base.certificationNumber,
        yearsOfExperience: base.yearsOfExperience,
        bio: base.bio,
        predecessorId: LSAProfileRepositoryMock.simulateServerErrorSentinel,
      );

      final SubmissionResult result =
          await repository.submitProfile(simulatedServerError);
      expect(result.outcome, SubmissionOutcome.serverError);
    },
  );
}
