# MyCast - AirPlay & Chromecast Test App

A Flutter application for testing AirPlay and Chromecast functionality with HLS video streaming and live streams.

## Features

- ✅ HLS Video Streaming Support
- ✅ Play/Pause/Seek Controls  
- ✅ AirPlay Support (iOS)
- ✅ Chromecast Support (Android)
- ✅ Multiple Test Streams (VOD & Live)
- ✅ Cross-platform UI
- ✅ Cast Device Discovery
- ✅ Media Control Interface

## Screenshots

The app includes:
- Video player with custom controls
- Stream selection (VOD and Live streams)
- Cast device discovery and connection
- Media playback controls for cast devices

## Setup Instructions

### Prerequisites

- Flutter SDK 3.7.2 or higher
- For iOS: Xcode 14+ and iOS 12+
- For Android: Android Studio and API level 21+

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd my_cast
```

2. Install dependencies:
```bash
flutter pub get
```

3. For iOS setup:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Configure your development team
   - Ensure the bundle identifier is unique

4. For Android setup:
   - Open `android/` folder in Android Studio
   - Sync the project
   - Ensure minimum SDK is API 21 or higher

### Running the App

```bash
# Run on iOS
flutter run -d ios

# Run on Android  
flutter run -d android

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## Configuration

### iOS AirPlay Setup

The app is pre-configured for AirPlay with:
- Network usage permissions
- Bonjour services for device discovery
- Background audio capability
- App Transport Security settings

### Android Chromecast Setup

The app includes:
- Chromecast framework integration
- MediaRouter service configuration
- Network permissions
- Wake lock permissions

### Custom Chromecast App ID

To use your own Chromecast receiver app:

1. Replace the app ID in `android/app/src/main/kotlin/uz/mcodevs/my_cast/CastOptionsProvider.kt`:
```kotlin
.setReceiverApplicationId(\"YOUR_CAST_APP_ID\")
```

2. Update the receiver app as needed for your HLS streams.

## Test Streams

The app includes several pre-configured test streams:

### VOD (Video on Demand) Streams:
- **Big Buck Bunny**: Sample HLS stream
- **Apple Sample Stream**: Official Apple test stream  
- **Sintel Movie**: Open source movie HLS stream

### Live Streams:
- **Live News Stream**: Sample live news feed
- **Red Bull TV**: Sample live TV stream
- **Custom HLS Test**: Mux test stream

## Architecture

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── stream_data.dart     # Stream data models
├── screens/
│   └── video_player_screen.dart # Main video player UI
├── services/
│   └── casting_service.dart # Casting logic and state management
└── widgets/
    ├── cast_button.dart     # Cast device selector button
    ├── stream_selector.dart # Stream selection UI
    └── video_controls.dart  # Custom video controls
```

## Key Components

### CastingService
- Manages casting state and device connections
- Handles device discovery and selection
- Provides media control methods (play/pause/seek/stop)
- Mock implementation for testing (replace with actual casting SDK)

### VideoPlayerScreen
- Main video playback interface
- Integrates video player with casting controls
- Stream selection and management
- Error handling and loading states

### StreamSelector
- Tabbed interface for VOD and Live streams
- Stream metadata display
- Easy stream switching

## Troubleshooting

### Common Issues:

1. **No devices found**: 
   - Ensure your device and cast target are on the same WiFi network
   - Check network permissions are granted

2. **Video fails to load**:
   - Verify the HLS stream URL is accessible
   - Check network connectivity
   - Some streams may have geographic restrictions

3. **Cast not working**:
   - Verify Chromecast device is set up correctly
   - Check if the receiver app ID is correct
   - Ensure media format is supported by the receiver

4. **iOS AirPlay not appearing**:
   - Ensure AirPlay device is on same network
   - Check iOS device's Control Center for AirPlay options
   - Verify Info.plist permissions are correct

## Development Notes

### Adding New Streams

Add new test streams in `lib/models/stream_data.dart`:

```dart
StreamData(
  title: 'Your Stream Name',
  url: 'https://your-hls-stream.m3u8',
  description: 'Stream description',
  isLive: false, // or true for live streams
),
```

### Customizing the UI

- Modify `lib/screens/video_player_screen.dart` for main layout changes
- Update `lib/widgets/` files for individual component modifications
- Adjust theme in `lib/main.dart`

### Implementing Real Casting

The current `CastingService` is a mock implementation. To implement real casting:

1. For Chromecast: Integrate Google Cast SDK
2. For AirPlay: Use native iOS AirPlay APIs via platform channels
3. Replace mock methods with actual SDK calls

## Dependencies

- **video_player**: Core video playback
- **chewie**: Video player UI controls
- **provider**: State management
- **wakelock_plus**: Prevent screen sleep during playback
- **http**: Network requests
- **shared_preferences**: Local storage

## License

This is a test application for demonstration purposes. Use appropriate licenses for production apps.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on both platforms
5. Submit a pull request

## Support

For issues and questions:
- Check the troubleshooting section above
- Review Flutter documentation for video_player and chewie
- Consult Google Cast SDK documentation for Chromecast
- Check Apple's AirPlay documentation for iOS