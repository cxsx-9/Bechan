import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/custom_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User _user = config.USER_DATA;
  dynamic image;
  dynamic cropfile;

  Future<void> _fetchUserData() async {
    await UserService().fetch();
    setState(() {
      _user = config.USER_DATA;
    });
  }

  Future _pickImage() async {
    print('PICK');
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() {
        image = pickedFile;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> _cropImage() async {
    print('CROP');
    if (image != null) {
      print(image.path);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ]
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(
              width: 520,
              height: 520,
            ),
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          cropfile = croppedFile;
        });
      } else {
        setState(() {
          image = null;
        });
      }
    }
  }

  void onChooseFile () async {
    image = null;
    cropfile = null;
    await _pickImage();
    await _cropImage();
    if (image != null){
      PlatformFile file = PlatformFile(
        name: image.name,
        size: 1,
        path: cropfile.path
      );
      UserService().importFile(file).then((onValue) => {
        _fetchUserData()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 50,),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.shadow,
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 35,),
                                    Text(
                                      "${_user.firstname} ${_user.lastname}",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      _user.email,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                      child: CircleAvatar(
                                        radius: 56,
                                        backgroundImage: NetworkImage(
                                          '${config.BASE_URL}/${_user.profilePath}'
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: IconButton.filled(
                                  style: IconButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      foregroundColor: Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: (){onChooseFile();},
                                  icon: const Icon(Icons.mode_edit_outline_rounded, size: 20,),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: cardDecoration(context),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/changePasswordPage');
                        },
                        child: Text(
                          'Change password',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14
                          ),
                        )
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: cardDecoration(context),
                      child: TextButton(
                        onPressed: () {
                          CustomDialog().alertDialog(context, () => UserService().logout(context), 'Logout', 'Are you sure you want to Logout?');
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
