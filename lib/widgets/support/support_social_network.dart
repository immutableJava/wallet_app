import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SupportSocialNetwork extends StatelessWidget {
  const SupportSocialNetwork(this.title, {this.phoneNumber = '', super.key});

  final String title;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/${title.toLowerCase()}-icon.svg',
          width: 36,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          phoneNumber == '' ? title : phoneNumber,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.black),
        ),
      ],
    );
  }
}
