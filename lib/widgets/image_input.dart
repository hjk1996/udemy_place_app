import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicuture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return;
    }

    setState(() {
      _storedImage = File(imageFile.path);
    });
    // 앱 저장소 경로
    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    // 파일 이름
    final fileName = path.basename(imageFile.path);
    await imageFile.saveTo(path.join(appDir.path, fileName));
    widget.onSelectImage(imageFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No Image Taken",
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextButton.icon(
          onPressed: _takePicuture,
          icon: Icon(Icons.camera),
          label: Text("Take Picuture"),
          style: TextButton.styleFrom(
              textStyle: TextStyle(color: Theme.of(context).primaryColor)),
        ))
      ],
    );
  }
}
