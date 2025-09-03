import 'package:flutter_test/flutter_test.dart';
import 'package:my_cast/services/casting_service.dart';

void main() {
  group('CastingService', () {
    test('startCasting throws when not connected', () async {
      final service = CastingService();

      expect(service.isConnected, isFalse);
      expect(
        () => service.startCasting('https://example.com/video.m3u8'),
        throwsException,
      );
    });

    test('onSessionStarted sets connected state', () {
      final service = CastingService();

      service.onSessionStarted();

      expect(service.isConnected, isTrue);
      expect(service.isLoading, isFalse);
      expect(service.connectedDeviceName, equals('Cast Device'));
    });

    test('startCasting updates loading state and completes', () async {
      final service = CastingService();
      service.onSessionStarted();

      final future = service.startCasting(
        'https://example.com/video.m3u8',
        title: 'Sample',
      );

      // Should set loading immediately before awaiting
      expect(service.isLoading, isTrue);

      await future;

      expect(service.isLoading, isFalse);
    });

    test('disconnect resets connection state', () async {
      final service = CastingService();
      service.onSessionStarted();

      await service.disconnect();

      expect(service.isConnected, isFalse);
      expect(service.connectedDeviceName, isEmpty);
      expect(service.isLoading, isFalse);
    });

    test('media control methods do not throw when disconnected', () async {
      final service = CastingService();

      await service.play();
      await service.pause();
      await service.seek(const Duration(seconds: 5));
      await service.stop();

      // Reaching here without exceptions is success
      expect(true, isTrue);
    });
  });
}

