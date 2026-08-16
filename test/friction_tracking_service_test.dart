import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habotconnect_lsa_verification/app/data/services/friction_tracking_service.dart';

void main() {
  test('flags a friction event after > 5s of no interaction', () {
    fakeAsync((async) {
      int firedCount = 0;
      final service = FrictionTrackingService(
        stallThreshold: const Duration(seconds: 5),
        onFrictionEvent: (total) => firedCount = total,
      );

      service.startTracking();
      async.elapse(const Duration(seconds: 4));
      expect(firedCount, 0, reason: 'should not fire before threshold');

      async.elapse(const Duration(seconds: 2));
      expect(firedCount, 1, reason: 'should fire once stalled past 5s');

      service.dispose();
    });
  });

  test('resets the stall clock on interaction', () {
    fakeAsync((async) {
      int firedCount = 0;
      final service = FrictionTrackingService(
        stallThreshold: const Duration(seconds: 5),
        onFrictionEvent: (total) => firedCount = total,
      );

      service.startTracking();
      async.elapse(const Duration(seconds: 4));
      service.registerInteraction(); // resets clock
      async.elapse(const Duration(seconds: 4));
      expect(firedCount, 0, reason: 'interaction should have reset the timer');

      service.dispose();
    });
  });
}
