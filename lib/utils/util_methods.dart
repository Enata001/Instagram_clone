import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource image) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: image);

  if (file != null) {
    return await file.readAsBytes();
  }
  return;
}


extension AppSnackBar on BuildContext {
  void showSnackBar(String content) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }
  String get photoUrl => "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

}
