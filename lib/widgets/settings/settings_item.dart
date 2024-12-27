import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_app/providers/card_provider.dart';
import 'package:wallet_app/screens/card_detail.dart';
import 'package:wallet_app/screens/notifications.dart';
import 'package:wallet_app/screens/profile.dart';
import 'package:wallet_app/screens/support.dart';
import 'package:wallet_app/screens/wallet.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';

class SettingsItem extends ConsumerWidget {
  const SettingsItem(this.title, this.assetName, {super.key});

  final String title;
  final String assetName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              switch (title) {
                case 'Notifications':
                  return NotificationsScreen();
                case 'Profile':
                  return ProfileScreen();
                case 'Your Wallet':
                  return ref.watch(cardNotifierProvider.notifier).isEmptyCard
                      ? CardDetailScreen()
                      : WalletScreen();
                case 'Support 24/7':
                  return SupportScreen();
                default:
                  return Scaffold(
                    appBar: MainAppBar(),
                    body: Center(child: Text('Page not found')),
                  );
              }
            },
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 0.2,
                    offset: Offset(3, 3),
                  )
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/icons/$assetName.svg',
                  colorFilter: ColorFilter.mode(
                    Color.fromRGBO(47, 17, 85, 1),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 32),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Color.fromRGBO(47, 17, 85, 1),
                  ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Color.fromRGBO(47, 17, 85, 1),
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
