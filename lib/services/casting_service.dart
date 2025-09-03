import 'package:flutter/material.dart';

class CastingService extends ChangeNotifier {
  bool _isConnected = false;
  bool _isLoading = false;
  String _connectedDeviceName = '';

  // Getters
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String get connectedDeviceName => _connectedDeviceName;

  // Initialize casting controllers
  void initializeCasting() {
    // Initialize casting - in a real implementation this would
    // initialize the actual casting SDKs
    notifyListeners();
  }

  // Session callbacks
  void onSessionStarted() {
    _isConnected = true;
    _isLoading = false;
    _connectedDeviceName = 'Cast Device';
    notifyListeners();
  }

  void onSessionEnded() {
    _isConnected = false;
    _isLoading = false;
    _connectedDeviceName = '';
    notifyListeners();
  }

  // Start casting with a video URL
  Future<void> startCasting(
    String videoUrl, {
    String? title,
    String? subtitle,
    String? imageUrl,
  }) async {
    if (!_isConnected) {
      throw Exception('No device connected');
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate casting delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real implementation, this would start casting the media
      debugPrint('Starting cast: $videoUrl');
      debugPrint('Title: $title');
      debugPrint('Subtitle: $subtitle');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error starting cast: $e');
      rethrow;
    }
  }

  // Show device selection dialog
  Future<void> showCastDialog(BuildContext context) async {
    final devices = await _getAvailableDevices();

    if (!context.mounted) return;

    if (devices.isEmpty) {
      await _showNoDevicesDialog(context);
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cast to Device'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  leading: Icon(
                    device.type == CastDeviceType.chromecast
                        ? Icons.cast
                        : Icons.airplay,
                  ),
                  title: Text(device.name),
                  subtitle: Text(device.type.toString().split('.').last),
                  onTap: () {
                    Navigator.of(context).pop();
                    _connectToDevice(device);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Get available casting devices (mock implementation)
  Future<List<CastDevice>> _getAvailableDevices() async {
    // Simulate device discovery delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock devices for testing
    return [
      CastDevice(
        id: '1',
        name: 'Living Room TV',
        type: CastDeviceType.chromecast,
      ),
      CastDevice(id: '2', name: 'Apple TV', type: CastDeviceType.airplay),
      CastDevice(
        id: '3',
        name: 'Bedroom Chromecast',
        type: CastDeviceType.chromecast,
      ),
    ];
  }

  // Connect to a specific device
  Future<void> _connectToDevice(CastDevice device) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate connection delay
      await Future.delayed(const Duration(seconds: 2));

      _isConnected = true;
      _connectedDeviceName = device.name;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error connecting to device: $e');
      rethrow;
    }
  }

  // Disconnect from current device
  Future<void> disconnect() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate disconnection delay
      await Future.delayed(const Duration(milliseconds: 500));

      _isConnected = false;
      _connectedDeviceName = '';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }

  // Media control methods
  Future<void> play() async {
    if (!_isConnected) return;
    debugPrint('Cast: Play');
    // In real implementation, send play command to cast device
  }

  Future<void> pause() async {
    if (!_isConnected) return;
    debugPrint('Cast: Pause');
    // In real implementation, send pause command to cast device
  }

  Future<void> seek(Duration position) async {
    if (!_isConnected) return;
    debugPrint('Cast: Seek to ${position.inSeconds} seconds');
    // In real implementation, send seek command to cast device
  }

  Future<void> stop() async {
    if (!_isConnected) return;
    debugPrint('Cast: Stop');
    // In real implementation, send stop command to cast device
  }

  Future<void> _showNoDevicesDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Devices Found'),
          content: const Text(
            'No casting devices were found. Please make sure your Chromecast or AirPlay device is connected to the same network.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Mock classes for demonstration (these would come from the actual plugin)
enum CastDeviceType { chromecast, airplay }

class CastDevice {
  final String name;
  final String id;
  final CastDeviceType type;

  CastDevice({required this.name, required this.id, required this.type});
}

class MediaInfo {
  final String contentId;
  final String contentType;
  final StreamType streamType;
  final MediaMetadata? metadata;

  MediaInfo({
    required this.contentId,
    required this.contentType,
    required this.streamType,
    this.metadata,
  });
}

class MediaMetadata {
  final String? title;
  final String? subtitle;
  final List<WebImage>? images;

  MediaMetadata({this.title, this.subtitle, this.images});
}

class WebImage {
  final String url;

  WebImage({required this.url});
}

enum StreamType { buffered, live }
