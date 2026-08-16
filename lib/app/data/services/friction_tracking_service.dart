import 'dart:async';

import '../../core/constants/api_constants.dart';
import '../../core/utils/app_logger.dart';


class FrictionTrackingService {
  final Duration stallThreshold;

  void Function(int totalFrictionEvents)? onFrictionEvent;

  Timer? _stallTimer;
  int _frictionEventCount = 0;

  FrictionTrackingService({
    Duration? stallThreshold,
    this.onFrictionEvent,
  }) : stallThreshold =
            stallThreshold ?? SystemThresholds.frictionStallThreshold;

  int get frictionEventCount => _frictionEventCount;

  void startTracking() => _rearmTimer();

  void registerInteraction() => _rearmTimer();

  void stopTracking() {
    _stallTimer?.cancel();
    _stallTimer = null;
  }

  void _rearmTimer() {
    _stallTimer?.cancel();
    _stallTimer = Timer(stallThreshold, _flagFrictionEvent);
  }

  void _flagFrictionEvent() {
    _frictionEventCount++;
    AppLogger.info(
      'Friction event #$_frictionEventCount: user stalled > '
      '${stallThreshold.inSeconds}s on primary field.',
    );
    onFrictionEvent?.call(_frictionEventCount);

    _rearmTimer();
  }

  void dispose() => stopTracking();
}
