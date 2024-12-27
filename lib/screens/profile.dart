import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/models/user.dart';
import 'package:wallet_app/screens/auth.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';
import 'package:wallet_app/widgets/profile/profile_image_picker.dart';
import 'package:wallet_app/widgets/profile/profile_item.dart';
import 'package:wallet_app/providers/user_provider.dart';
import 'dart:developer' as developer;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  late final String username;
  bool isEditing = false;

  var _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late User user;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    try {
      _firestoreService.updateUserField(
          'username', _usernameController.text, false);
      ref.read(userNotifier.notifier).loadUserData();
    } catch (e) {
      developer.log('Validate6Error: $e', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userNotifier);
    _usernameController = TextEditingController(text: user.username);
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 96),
        child: Column(
          children: [
            Expanded(
              child: ProfileImagePicker(),
            ),
            Row(
              mainAxisAlignment: isEditing
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                isEditing
                    ? Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _usernameController,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.ltr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              maxLength: 20,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length >= 20 ||
                                    value.length <= 3) {
                                  return 'Please enter username between 3 and 20 characters long';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      )
                    : Text(
                        user.username,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black),
                      ),
                isEditing
                    ? Flexible(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
                            _validateForm();
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/check.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/edit-2.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Center(
              child: Text(
                user.email,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 64,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileItem(title: 'Connected Account'),
                  SizedBox(
                    height: 35,
                  ),
                  ProfileItem(title: 'Privacy and Security'),
                  SizedBox(
                    height: 35,
                  ),
                  // ProfileItem(title: 'Login Settings'),
                  // SizedBox(
                  //   height: 35,
                  // ),
                  // ProfileItem(title: 'Service Center'),
                ],
              ),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size(48, 48),
              ),
              onPressed: () {
                FirestoreService().signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AuthScreen(),
                  ),
                );
              },
              label: Text('Log out'),
              icon: SvgPicture.asset('assets/icons/login.svg'),
            )
          ],
        ),
      ),
    );
  }
}
