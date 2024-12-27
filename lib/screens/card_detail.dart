import 'package:flutter/material.dart';
import 'package:wallet_app/widgets/card_detail/card_delete.dart';
import 'package:wallet_app/widgets/card_detail/card_info.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';

import '../widgets/card_detail/card_header.dart';

class CardDetailScreen extends StatelessWidget {
  const CardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            CardHeader('Card Detail', true,),
            SizedBox(
              height: 64,
            ),
            CardInfo(),
              SizedBox(
              height: 64,
            ),
            CardDelete(),
          ],
        ),
      ),
    );
  }
}
