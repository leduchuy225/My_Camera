import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MyToast {
  static void show(String message) {
    Fluttertoast.showToast(
      msg: message,
      fontSize: 16.0,
      textColor: Colors.white,
      backgroundColor: Colors.red,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}

Future saveToGallery(XFile file) async {
  return GallerySaver.saveImage(file.path, toDcim: true);
}
