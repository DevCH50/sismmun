// Tests unitarios para AppDurations
// Verifica que los timeouts y duraciones tengan valores correctos y consistentes
import 'package:flutter_test/flutter_test.dart';
import 'package:sismmun/src/core/constants/app_durations.dart';

void main() {
  group('AppDurations', () {
    test('httpTimeout es 30 segundos', () {
      expect(AppDurations.httpTimeout, equals(const Duration(seconds: 30)));
    });

    test('httpImageUploadTimeout es mayor que httpTimeout', () {
      expect(AppDurations.httpImageUploadTimeout,
          greaterThan(AppDurations.httpTimeout));
    });

    test('animationFast < animationNormal < animationSlow', () {
      expect(AppDurations.animationFast,
          lessThan(AppDurations.animationNormal));
      expect(AppDurations.animationNormal,
          lessThan(AppDurations.animationSlow));
    });

    test('splashMinDuration es positivo', () {
      expect(AppDurations.splashMinDuration.inMilliseconds, greaterThan(0));
    });
  });
}
