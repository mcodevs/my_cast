import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:my_cast/services/casting_service.dart';
import 'package:my_cast/widgets/cast_button.dart';

Widget _buildWithProvider({
  required CastingService service,
  required VoidCallback onCastPressed,
}) {
  return ChangeNotifierProvider.value(
    value: service,
    child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            CastButton(onCastPressed: onCastPressed),
          ],
        ),
        body: const SizedBox.shrink(),
      ),
    ),
  );
}

void main() {
  testWidgets('shows connect option and opens device dialog', (tester) async {
    final service = CastingService();
    var castPressed = false;

    await tester.pumpWidget(
      _buildWithProvider(
        service: service,
        onCastPressed: () => castPressed = true,
      ),
    );

    expect(find.byIcon(Icons.cast), findsOneWidget);

    // Open the popup menu
    await tester.tap(find.byIcon(Icons.cast));
    await tester.pumpAndSettle();

    expect(find.text('Connect to Device'), findsOneWidget);

    // Tap connect and wait for device discovery + dialog
    await tester.tap(find.text('Connect to Device'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Cast to Device'), findsOneWidget);
    expect(find.text('Living Room TV'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Cast to Device'), findsNothing);
    expect(castPressed, isFalse);
  });

  testWidgets('shows start/disconnect when connected and triggers actions', (tester) async {
    final service = CastingService();
    var castPressed = false;

    await tester.pumpWidget(
      _buildWithProvider(
        service: service,
        onCastPressed: () => castPressed = true,
      ),
    );

    // Simulate active cast session
    service.onSessionStarted();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cast_connected), findsOneWidget);

    // Open menu
    await tester.tap(find.byIcon(Icons.cast_connected));
    await tester.pumpAndSettle();

    expect(find.text('Start Casting'), findsOneWidget);
    expect(find.text('Disconnect'), findsOneWidget);

    // Trigger start casting callback
    await tester.tap(find.text('Start Casting'));
    await tester.pumpAndSettle();
    expect(castPressed, isTrue);

    // Open menu again and disconnect
    await tester.tap(find.byIcon(Icons.cast_connected));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Disconnect'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(service.isConnected, isFalse);
  });
}

