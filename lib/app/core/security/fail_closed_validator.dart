import '../../data/models/lsa_profile_model.dart';
import '../utils/app_logger.dart';
import 'validation_result.dart';

abstract class FailClosedValidator {
  FailClosedValidator._();

  static ValidationResult validate(LSAProfileModel profile) {
    final List<ValidationResult Function()> gates = <ValidationResult Function()>[
      () => _checkRequiredField(profile.fullName, field: 'fullName'),
      () => _checkRequiredField(profile.email, field: 'email'),
      () => _checkEmailFormat(profile.email),
      () => _checkRequiredField(profile.phone, field: 'phone'),
      () => _checkRequiredField(
            profile.certificationNumber,
            field: 'certificationNumber',
          ),
      () => _checkYearsOfExperience(profile.yearsOfExperience),

      () => _checkPredecessorId(profile.predecessorId),
    ];

    for (final ValidationResult Function() gate in gates) {
      final ValidationResult result = gate();
      if (!result.isValid) {
        AppLogger.securityQuarantine(result.quarantineReason ?? 'unknown');
        return result;
      }
    }

    return const ValidationResult.valid();
  }

  static ValidationResult _checkRequiredField(
    String? value, {
    required String field,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.quarantined(
        'Field "$field" is null or empty — fail-closed halt.',
      );
    }
    return const ValidationResult.valid();
  }

  static ValidationResult _checkEmailFormat(String? email) {
    final RegExp emailPattern = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (email == null || !emailPattern.hasMatch(email)) {
      return const ValidationResult.quarantined(
        'Field "email" failed format compliance — fail-closed halt.',
      );
    }
    return const ValidationResult.valid();
  }

  static ValidationResult _checkYearsOfExperience(int? years) {
    if (years == null || years < 0 || years > 60) {
      return const ValidationResult.quarantined(
        'Field "yearsOfExperience" is null or out of bounds — '
        'fail-closed halt.',
      );
    }
    return const ValidationResult.valid();
  }

  static ValidationResult _checkPredecessorId(String? predecessorId) {
    if (predecessorId == null || predecessorId.trim().isEmpty) {
      return const ValidationResult.quarantined(
        'Missing predecessor_id — orphan data lineage, fail-closed halt.',
      );
    }
    return const ValidationResult.valid();
  }
}
