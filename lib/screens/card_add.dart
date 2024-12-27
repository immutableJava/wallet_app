import 'package:flutter/material.dart';
import 'package:wallet_app/widgets/card_add/card_form.dart';
import 'package:wallet_app/widgets/card_detail/card_header.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';

class CardAddScreen extends StatefulWidget {
  const CardAddScreen({super.key});

  @override
  State<CardAddScreen> createState() => _CardAddScreenState();
}

class _CardAddScreenState extends State<CardAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CardHeader('Add Card', false),
              SizedBox(height: 12),
              CardForm(),
            ],
          ),
        ),
      ),
    );
  }
}
