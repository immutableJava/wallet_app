import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_app/screens/notifications.dart';
import 'package:wallet_app/screens/settings.dart';
import 'package:wallet_app/screens/stats.dart';

class WalletNavigationBar extends StatelessWidget {
  const WalletNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(top: 32),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 31, 114, 1.0),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return StatsScreen();
                  },
                ),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/chart-2.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              fit: BoxFit.contain,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SettingsScreen(),
                ),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/setting.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              fit: BoxFit.contain,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => NotificationsScreen(),
                ),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/notifications.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
