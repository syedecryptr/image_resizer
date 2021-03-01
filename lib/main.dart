import 'package:image_resizer/debug/file_analysis.dart';
import 'package:flutter/material.dart';
import 'package:image_resizer/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app resizer',
      home: HomePage(),
    );
  }
}
