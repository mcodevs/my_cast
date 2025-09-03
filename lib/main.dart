import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/video_player_screen.dart';
import 'services/casting_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CastingService(),
      child: MaterialApp(
        title: 'MyCast - AirPlay & Chromecast Test',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const VideoPlayerScreen(),
      ),
    );
  }
}
