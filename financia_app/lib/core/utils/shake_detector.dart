import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

typedef ShakeCallback = void Function();

class ShakeDetector {
  final ShakeCallback onShake;
  late StreamSubscription _subscription;
  final double shakeThresholdGravity;
  final int minTimeBetweenShakes;

  int _lastShakeTimestamp = 0;

  ShakeDetector({
    required this.onShake,
    this.shakeThresholdGravity = 2.7, // Adjust threshold as needed
    this.minTimeBetweenShakes = 1000, // Minimum time (ms) between shakes
  });

  void startListening() {
    _subscription = accelerometerEvents.listen((event) {
      double gX = event.x / 9.81;
      double gY = event.y / 9.81;
      double gZ = event.z / 9.81;

      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (now - _lastShakeTimestamp > minTimeBetweenShakes) {
          _lastShakeTimestamp = now;
          onShake();
        }
      }
    });
  }

  void stopListening() {
    _subscription.cancel();
  }
}
