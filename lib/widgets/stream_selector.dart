import 'package:flutter/material.dart';
import '../models/stream_data.dart';

class StreamSelector extends StatelessWidget {
  final StreamData currentStream;
  final ValueChanged<StreamData> onStreamSelected;

  const StreamSelector({
    super.key,
    required this.currentStream,
    required this.onStreamSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.movie), text: 'VOD Streams'),
              Tab(icon: Icon(Icons.live_tv), text: 'Live Streams'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildStreamList(TestStreams.getVodStreams()),
                _buildStreamList(TestStreams.getLiveStreams()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamList(List<StreamData> streams) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: streams.length,
      itemBuilder: (context, index) {
        final stream = streams[index];
        final isSelected = stream.url == currentStream.url;

        return Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected ? Colors.deepPurple.withValues(alpha: 0.1) : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: stream.isLive ? Colors.red : Colors.blue,
              child: Icon(
                stream.isLive ? Icons.live_tv : Icons.movie,
                color: Colors.white,
              ),
            ),
            title: Text(
              stream.title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stream.description),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      stream.isLive ? Icons.circle : Icons.play_circle,
                      size: 12,
                      color: stream.isLive ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stream.isLive ? 'LIVE' : 'ON DEMAND',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: stream.isLive ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing:
                isSelected
                    ? const Icon(Icons.play_arrow, color: Colors.deepPurple)
                    : null,
            onTap: () => onStreamSelected(stream),
          ),
        );
      },
    );
  }
}
