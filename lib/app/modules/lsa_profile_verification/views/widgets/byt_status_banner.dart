import 'package:flutter/material.dart';

import '../../controllers/lsa_profile_verification_controller.dart';


class BytStatusBanner extends StatelessWidget {
  final ViewStatus status;
  final String message;
  final String? traceId;

  const BytStatusBanner({
    super.key,
    required this.status,
    required this.message,
    this.traceId,
  });

  ({Color background, Color foreground, IconData icon, String title})
      _visualsFor(ViewStatus status, ColorScheme scheme) {
    switch (status) {
      case ViewStatus.success:
        return (
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          icon: Icons.check_circle_rounded,
          title: 'Valid Submission',
        );
      case ViewStatus.quarantined:
        return (
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
          icon: Icons.block_rounded,
          title: 'Fail-Closed: Quarantined',
        );
      case ViewStatus.serverError:
        return (
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
          icon: Icons.error_rounded,
          title: 'Server Error',
        );
      case ViewStatus.idle:
      case ViewStatus.submitting:
        return (
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurfaceVariant,
          icon: Icons.info_outline_rounded,
          title: 'Status',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == ViewStatus.idle) {
      return const SizedBox.shrink();
    }

    final ColorScheme scheme = Theme.of(context).colorScheme;
    final visuals = _visualsFor(status, scheme);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: visuals.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(visuals.icon, color: visuals.foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  visuals.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: visuals.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: visuals.foreground),
                ),
                if (traceId != null) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    'trace_id: $traceId',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: visuals.foreground.withOpacity(0.8),
                          fontFamily: 'monospace',
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
