import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'screens/take_picture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(
    MaterialApp(
      color: Colors.blue,
      theme: ThemeData.dark(),
      home: TakePictureScreen(camera: cameras),
    ),
  );
}
