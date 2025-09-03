import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../services/casting_service.dart';

class VideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final bool showControls;

  const VideoControls({
    super.key,
    required this.controller,
    this.showControls = true,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    _initializeListeners();
  }

  void _initializeListeners() {
    widget.controller.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _isPlaying = widget.controller.value.isPlaying;
        _position = widget.controller.value.position;
        _duration = widget.controller.value.duration;
        _isBuffering = widget.controller.value.isBuffering;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _playPause() {
    if (_isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
  }

  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    widget.controller.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showControls) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    value:
                        _duration.inSeconds > 0
                            ? _position.inSeconds.toDouble()
                            : 0.0,
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    activeColor: Colors.deepPurple,
                    inactiveColor: Colors.grey,
                    onChanged: _seekTo,
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

          // Control buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Rewind button
                IconButton(
                  onPressed: () {
                    final newPosition = _position - const Duration(seconds: 10);
                    widget.controller.seekTo(
                      newPosition < Duration.zero ? Duration.zero : newPosition,
                    );
                  },
                  icon: const Icon(Icons.replay_10, color: Colors.white),
                  iconSize: 32,
                ),

                // Play/Pause button
                IconButton(
                  onPressed: _playPause,
                  icon: Icon(
                    _isBuffering
                        ? Icons.hourglass_empty
                        : (_isPlaying ? Icons.pause : Icons.play_arrow),
                    color: Colors.white,
                  ),
                  iconSize: 48,
                ),

                // Fast forward button
                IconButton(
                  onPressed: () {
                    final newPosition = _position + const Duration(seconds: 10);
                    widget.controller.seekTo(
                      newPosition > _duration ? _duration : newPosition,
                    );
                  },
                  icon: const Icon(Icons.forward_10, color: Colors.white),
                  iconSize: 32,
                ),

                // Cast controls
                Consumer<CastingService>(
                  builder: (context, castingService, child) {
                    if (!castingService.isConnected) {
                      return const SizedBox.shrink();
                    }

                    return Row(
                      children: [
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => castingService.play(),
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                        ),
                        IconButton(
                          onPressed: () => castingService.pause(),
                          icon: const Icon(Icons.pause, color: Colors.white),
                          iconSize: 24,
                        ),
                        IconButton(
                          onPressed: () => castingService.stop(),
                          icon: const Icon(Icons.stop, color: Colors.white),
                          iconSize: 24,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Casting status
          Consumer<CastingService>(
            builder: (context, castingService, child) {
              if (!castingService.isConnected) {
                return const SizedBox.shrink();
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cast_connected,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Casting to ${castingService.connectedDeviceName}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Spacer(),
                    if (castingService.isLoading)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
