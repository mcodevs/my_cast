import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/casting_service.dart';

class CastButton extends StatelessWidget {
  final VoidCallback onCastPressed;

  const CastButton({super.key, required this.onCastPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<CastingService>(
      builder: (context, castingService, child) {
        return PopupMenuButton<String>(
          icon: Icon(
            castingService.isConnected ? Icons.cast_connected : Icons.cast,
            color: castingService.isConnected ? Colors.deepPurple : null,
          ),
          onSelected: (String value) {
            switch (value) {
              case 'cast':
                castingService.showCastDialog(context);
                break;
              case 'start_casting':
                onCastPressed();
                break;
              case 'disconnect':
                castingService.disconnect();
                break;
            }
          },
          itemBuilder:
              (BuildContext context) => [
                if (!castingService.isConnected)
                  const PopupMenuItem<String>(
                    value: 'cast',
                    child: ListTile(
                      leading: Icon(Icons.devices),
                      title: Text('Connect to Device'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (castingService.isConnected) ...[
                  PopupMenuItem<String>(
                    value: 'start_casting',
                    child: ListTile(
                      leading: const Icon(Icons.play_arrow),
                      title: const Text('Start Casting'),
                      subtitle: Text(
                        'To ${castingService.connectedDeviceName}',
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'disconnect',
                    child: ListTile(
                      leading: Icon(Icons.stop_circle),
                      title: Text('Disconnect'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ],
        );
      },
    );
  }
}
