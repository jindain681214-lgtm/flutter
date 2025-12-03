import 'package:flutter/material.dart';
import 'theme/constants.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LG ThinQ Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kBgTop,
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        fontFamily: 'Noto Sans KR',
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}