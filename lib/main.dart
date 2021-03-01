import 'package:image_resizer/providers/image_process/image_processor.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_resizer/views/home_page.dart';

void main() {
  var initial_route = "/home_screen";
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ImageProcessingProvider()),
    ],
    child: MaterialApp(
      initialRoute: initial_route,
      routes: {
        '/home_screen': (context) => HomePage(),
      },
      title: 'app resizer',
    )
    )
  );
}
