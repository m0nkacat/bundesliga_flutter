import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'di/locator.dart';
import 'screens/standings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Читаем API-ключ из .env, затем регистрируем зависимости
  await dotenv.load(fileName: '.env');
  setupLocator();
  runApp(const BundesligaApp());
}

class BundesligaApp extends StatelessWidget {
  const BundesligaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Бундеслига',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      home: const StandingsScreen(),
    );
  }
}
