import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});
  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void pickedImage() async {
    final imagePick = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    if (imagePick == null) {
      return;
    }
    setState(() {
      _pickedImage = File(imagePick.path);
    });
    widget.onPickedImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pickedImage,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            foregroundImage:
                _pickedImage != null ? FileImage(_pickedImage!) : null,
          ),
          const Text(
            "Add Image",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
