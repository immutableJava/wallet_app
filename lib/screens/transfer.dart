import 'package:flutter/material.dart';
import 'package:wallet_app/widgets/common/card_transaction_form.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CardTransactionForm(
      isTransfer: true,
    );
  }
}
