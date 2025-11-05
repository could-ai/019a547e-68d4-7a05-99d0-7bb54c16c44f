import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const IndianDrivingGame());
}

class IndianDrivingGame extends StatelessWidget {
  const IndianDrivingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indian Driving 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
