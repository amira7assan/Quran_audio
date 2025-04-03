import 'package:flutter/material.dart';
import 'Screens/All_Reciter_all_Surah.dart';

void main() async {
  print("=================== MY QURAN APP STARTING ===================");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Kareem',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SurahListScreen(),
    );
  }
}