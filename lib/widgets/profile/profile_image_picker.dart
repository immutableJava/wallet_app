import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'dart:developer' as developer;

import 'package:wallet_app/providers/user_provider.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({super.key});

  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  File? _image;
  final picker = ImagePicker();
  final FirestoreService _firestoreService = FirestoreService();
  final Base64Codec base64 = Base64Codec();
  bool isAdded = false;
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      String encodedImage = await encodeImageToBase64(_image!);

      setState(() {
        try {
          _firestoreService.updateUserField('image', encodedImage, true);
          isAdded = true;
        } catch (e) {
          developer.log('Error updating Firestore: $e');
        }
      });
    } else {
      developer.log('No image selected');
    }
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future<String> encodeImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      if (bytes.isEmpty) {
        throw Exception('No Image Selected');
      }
      return base64Encode(bytes);
    } catch (e) {
      throw Exception('encodeImage Exception: $e');
    }
  }

  Uint8List base64Decode(String base64String) {
    return base64.decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    var userState = ref.read(userNotifier);
    if (userState.image.isNotEmpty) isAdded = true;
    return SizedBox(
      width: 100,
      child: InkWell(
        onTap: showOptions,
        child: CircleAvatar(
          backgroundImage: isAdded
              ? MemoryImage(base64Decode(userState.image))
              : AssetImage('assets/images/avatar-image.jpg'),
          // backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
