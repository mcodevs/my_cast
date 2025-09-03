class StreamData {
  final String title;
  final String url;
  final String description;
  final String? thumbnailUrl;
  final bool isLive;

  const StreamData({
    required this.title,
    required this.url,
    required this.description,
    this.thumbnailUrl,
    this.isLive = false,
  });
}

class TestStreams {
  static const List<StreamData> streams = [
    StreamData(
      title: 'Big Buck Bunny',
      url:
          'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
      description: 'Sample HLS video stream - Tears of Steel',
      isLive: false,
    ),
    StreamData(
      title: 'Apple Sample Stream',
      url:
          'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8',
      description: 'Apple\'s official HLS test stream',
      isLive: false,
    ),
    StreamData(
      title: 'Sintel Movie',
      url: 'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
      description: 'Sintel - Open source movie HLS stream',
      isLive: false,
    ),
    StreamData(
      title: 'Live News Stream',
      url:
          'https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8',
      description: 'Sample live news stream (if available)',
      isLive: true,
    ),
    StreamData(
      title: 'Red Bull TV Sample',
      url:
          'https://rbmn-live.akamaized.net/hls/live/590964/BoRB-AT/master.m3u8',
      description: 'Red Bull TV sample stream',
      isLive: true,
    ),
    StreamData(
      title: 'Custom HLS Test',
      url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
      description: 'Mux test stream for HLS testing',
      isLive: false,
    ),
  ];

  static StreamData getDefaultStream() {
    return streams.first;
  }

  static List<StreamData> getLiveStreams() {
    return streams.where((stream) => stream.isLive).toList();
  }

  static List<StreamData> getVodStreams() {
    return streams.where((stream) => !stream.isLive).toList();
  }
}
