import 'package:flutter/material.dart';
import 'package:wallet_app/widgets/common/card_transaction_form.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CardTransactionForm(
      isTransfer: false,
    );
  }
}
