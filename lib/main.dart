import 'package:camera/camera.dart';
import 'package:convo/Screens/camera_screen.dart';
import 'package:convo/Screens/home_screen.dart';
import 'package:convo/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

late Logger log;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log = Logger();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          hintColor: Color(0xFF128C7E),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF075E54))),
      home: LoginScreen(),
    );
  }
}
