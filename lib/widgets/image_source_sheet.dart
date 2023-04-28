import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:water_loss_project/constant/constant.dart';

class ImageSourceSheet extends StatelessWidget {
  // Constructor
  ImageSourceSheet({required this.onImageSelected});

  // Callback function to return image file
  final Function(File) onImageSelected;
  // ImagePicker instance
  final picker = ImagePicker();

  Future<void> selectedImage(BuildContext context, File image) async {
    // init i18n

    // Check file
    if (image != null) {
      final File? croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 80,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          maxWidth: 400,
          maxHeight: 400,
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Edit Image",
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
          ));
      onImageSelected(croppedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: ((context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// Select image from gallery
                TextButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.image,
                    color: COLOR_GREEN.withOpacity(0.8),
                    size: 20,
                  ),
                  label: Text(
                    "Gallery",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: COLOR_GREEN),
                  ),
                  onPressed: () async {
                    // Get image from device gallery
                    final PickedFile? pickedFile = await picker.getImage(
                      source: ImageSource.gallery,
                    );
                    selectedImage(context, File(pickedFile!.path));
                  },
                ),

                /// Capture image from camera
                TextButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.camera,
                    color: COLOR_GREEN.withOpacity(0.8),
                    size: 20,
                  ),
                  label: Text("Camera",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: COLOR_GREEN)),
                  onPressed: () async {
                    // Capture image from camera
                    final PickedFile? pickedFile = await picker.getImage(
                      source: ImageSource.camera,
                    );
                    selectedImage(context, File(pickedFile!.path));
                  },
                ),
              ],
            )));
  }
}
