import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/utils/utils.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final List<CameraDescription> camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;

  bool isBackCamera = true;

  final theLastTakenImageNotifier = ValueNotifier<String?>(null);
  final _initializeControllerFuture = ValueNotifier<Future<void>?>(null);

  void initCamera() {
    _controller = CameraController(
        widget.camera[isBackCamera ? 0 : 1], ResolutionPreset.medium);
    _initializeControllerFuture.value = _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        IconButton(
          icon: const Icon(Icons.rotate_90_degrees_ccw),
          onPressed: () {
            isBackCamera = !isBackCamera;
            initCamera();
          },
        ),
        const SizedBox(width: 8),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(50),
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: ValueListenableBuilder(
            valueListenable: theLastTakenImageNotifier,
            builder: (context, value, child) {
              if (value == null) {
                return const SizedBox.shrink();
              }
              return CircleAvatar(
                radius: 50,
                backgroundImage: Image.file(File(value)).image,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _initializeControllerFuture,
          child: const Center(child: CircularProgressIndicator()),
          builder: (context, value, child) {
            if (value == null) {
              return child!;
            }
            return FutureBuilder<void>(
              future: value,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                }
                return child!;
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            if (_initializeControllerFuture.value != null) {
              await _initializeControllerFuture.value;
            }

            if (!mounted) {
              return;
            }

            final image = await _controller.takePicture();
            theLastTakenImageNotifier.value = image.path;

            await saveToGallery(image);
          } catch (e) {
            MyToast.show(e.toString());
          }
        },
      ),
    );
  }
}
