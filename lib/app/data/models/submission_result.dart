
enum SubmissionOutcome { success, quarantined, serverError }

class SubmissionResult {
  final SubmissionOutcome outcome;
  final String message;
  final String? traceId;

  const SubmissionResult({
    required this.outcome,
    required this.message,
    this.traceId,
  });
}
