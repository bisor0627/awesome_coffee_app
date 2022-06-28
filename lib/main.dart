import 'package:awesome_cafe/global/provider/cafe_provider.dart';
import 'package:awesome_cafe/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CafeProvider()),
      ],
      child: MaterialApp(
        title: 'Awesome Cafe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MapPage(title: 'Awesome Cafe'),
      ),
    );
  }
}
