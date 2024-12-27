import 'package:flutter/material.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/screens/wallet.dart';

class CardDelete extends StatefulWidget {
  const CardDelete({super.key});

  @override
  State<CardDelete> createState() => _CardDeleteState();
}

class _CardDeleteState extends State<CardDelete> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await FirestoreService().deleteCard();
        final localContext = context;
        if (!mounted) {
          return;
        }
        Navigator.of(localContext).push(
          MaterialPageRoute(
            builder: (context) => const WalletScreen(),
          ),
        );
      },
      child: Text(
        'Delete Card',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: const Color.fromRGBO(55, 25, 93, 1.0),
            ),
      ),
    );
  }
}
