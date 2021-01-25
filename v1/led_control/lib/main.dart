import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:led_control/Data/device.dart';
import 'package:led_control/Data/mode_list.dart';
import 'package:led_control/UI/colors.dart';
import 'package:led_control/UI/main_screen.dart';
import 'package:led_control/Widgets/card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: MainScreen(),
      ),
    );
  }
}
