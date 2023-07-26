// ignore_for_file: sort_child_properties_last,, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rccarapp/firstScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: firstScreen(),
    );
  }
}
