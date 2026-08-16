import 'package:equatable/equatable.dart';

class ValidationResult extends Equatable {
  final bool isValid;
  final String? quarantineReason;

  const ValidationResult._({required this.isValid, this.quarantineReason});

  const ValidationResult.valid() : this._(isValid: true);

  const ValidationResult.quarantined(String reason)
      : this._(isValid: false, quarantineReason: reason);

  @override
  List<Object?> get props => [isValid, quarantineReason];
}
