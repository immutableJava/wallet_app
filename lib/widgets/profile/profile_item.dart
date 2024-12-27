import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Color.fromRGBO(47, 17, 85, 1),
                fontSize: 19,
              ),
        ),
        Spacer(),
        SvgPicture.asset('assets/icons/arrow-3.svg'),
      ],
    );
  }
}
