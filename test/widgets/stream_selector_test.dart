import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_cast/models/stream_data.dart';
import 'package:my_cast/widgets/stream_selector.dart';

void main() {
  testWidgets('renders tabs and invokes onStreamSelected', (tester) async {
    final current = TestStreams.getDefaultStream();
    StreamData? lastSelected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 500,
            child: StreamSelector(
              currentStream: current,
              onStreamSelected: (s) => lastSelected = s,
            ),
          ),
        ),
      ),
    );

    expect(find.text('VOD Streams'), findsOneWidget);
    expect(find.text('Live Streams'), findsOneWidget);

    // VOD list is visible by default
    expect(find.text('Big Buck Bunny'), findsOneWidget);

    // Switch to live tab
    await tester.tap(find.text('Live Streams'));
    await tester.pumpAndSettle();

    // Tap a live stream item
    await tester.tap(find.text('Live News Stream'));
    await tester.pump();

    expect(lastSelected, isNotNull);
    expect(lastSelected!.isLive, isTrue);
  });
}

