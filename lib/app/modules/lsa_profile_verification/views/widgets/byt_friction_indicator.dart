import 'package:flutter/material.dart';


class BytFrictionIndicator extends StatelessWidget {
  final int count;

  const BytFrictionIndicator({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool hasFriction = count > 0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: hasFriction ? 1 : 0.5,
      child: Chip(
        avatar: Icon(
          Icons.timer_outlined,
          size: 16,
          color: hasFriction ? scheme.tertiary : scheme.outline,
        ),
        label: Text('Friction events: $count'),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
