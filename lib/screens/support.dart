import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';
import 'package:wallet_app/widgets/support/support_social_network.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          children: [
            Center(
              child: Text(
                'Support 24/7',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 96,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Messengers'),
              ),
            ),
            SizedBox(
              height: 38,
            ),
            SupportSocialNetwork('WhatsApp'),
            SizedBox(
              height: 16,
            ),
            SupportSocialNetwork('Telegram'),
            SizedBox(
              height: 16,
            ),
            SupportSocialNetwork('Instagram'),
            SizedBox(
              height: 48,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Phones'),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            SupportSocialNetwork(
              'Phone',
              phoneNumber: '*1234',
            ),
            SizedBox(
              height: 24,
            ),
            SupportSocialNetwork(
              'Phone',
              phoneNumber: '+994 123 45 67',
            ),
          ],
        ),
      ),
    );
  }
}
