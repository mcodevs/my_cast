import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/casting_service.dart';
import '../models/stream_data.dart';
import '../widgets/cast_button.dart';
import '../widgets/stream_selector.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  StreamData _currentStream = TestStreams.getDefaultStream();
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeCasting();
    _initializePlayer();
  }

  void _initializeCasting() {
    final castingService = Provider.of<CastingService>(context, listen: false);
    castingService.initializeCasting();
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Enable wakelock to prevent screen from sleeping during playback
      await WakelockPlus.enable();

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(_currentStream.url),
      );

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurpleAccent,
          bufferedColor: Colors.grey[300]!,
          backgroundColor: Colors.grey[600]!,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading video',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
      debugPrint('Error initializing player: $e');
    }
  }

  Future<void> _changeStream(StreamData newStream) async {
    if (_currentStream.url == newStream.url) return;

    setState(() {
      _currentStream = newStream;
    });

    // Dispose current controllers
    _chewieController?.dispose();
    _videoController?.dispose();

    // Initialize with new stream
    await _initializePlayer();
  }

  Future<void> _startCasting() async {
    final castingService = Provider.of<CastingService>(context, listen: false);

    try {
      await castingService.startCasting(
        _currentStream.url,
        title: _currentStream.title,
        subtitle: _currentStream.description,
        imageUrl: _currentStream.thumbnailUrl,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Started casting to device'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start casting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyCast - Video Streaming'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [CastButton(onCastPressed: _startCasting)],
      ),
      body: Column(
        children: [
          // Video Player Section
          Container(
            width: double.infinity,
            height: 250,
            color: Colors.black,
            child: _buildVideoWidget(),
          ),

          // Stream Info Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentStream.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentStream.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _currentStream.isLive ? Icons.live_tv : Icons.movie,
                      size: 16,
                      color: _currentStream.isLive ? Colors.red : Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentStream.isLive ? 'LIVE' : 'VOD',
                      style: TextStyle(
                        color: _currentStream.isLive ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Stream Selector
          Expanded(
            child: StreamSelector(
              currentStream: _currentStream,
              onStreamSelected: _changeStream,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoWidget() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.deepPurple),
            SizedBox(height: 16),
            Text('Loading video...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Failed to load video',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializePlayer,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const Center(
      child: Text(
        'Video player not initialized',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
