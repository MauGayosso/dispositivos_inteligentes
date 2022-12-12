import 'package:flutter/material.dart';
import 'package:appejercicio/readData.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightGreen,
      ),
      debugShowCheckedModeBanner: false,
      home: ReadData(),
    );
  }
}