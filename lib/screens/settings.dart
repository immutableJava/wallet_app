import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/screens/auth.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';
import 'package:wallet_app/widgets/settings/settings_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            heightFactor: 5.5,
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          SizedBox(
            height: 36,
          ),
          SettingsItem('Profile', 'profile'),
          SizedBox(
            height: 36,
          ),
          SettingsItem('Notifications', 'notifications'),
          SizedBox(
            height: 36,
          ),
          SettingsItem('Your Wallet', 'wallet-2'),
          SizedBox(
            height: 36,
          ),
          SettingsItem('Support 24/7', 'call-calling'),
          SizedBox(
            height: 128,
          ),
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
    );
  }
}
