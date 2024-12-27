import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/models/user_transaction.dart';
import 'package:wallet_app/models/bank_card.dart';
import 'package:wallet_app/providers/card_provider.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';
import 'package:wallet_app/widgets/home/wallet_transaction_list.dart';
import '../models/user.dart';
import '../widgets/home/wallet_card.dart';
import '../widgets/home/wallet_header.dart';
import '../widgets/home/wallet_navigation_bar.dart';
import '../widgets/home/wallet_quick_actions.dart';
import 'dart:developer' as developer;

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  User? activeUser;
  List<UserTransaction>? transactions;
  BankCard? card;
  bool isLoading = true;
  late bool isEmptyCard;
  var formatter = NumberFormat('#,##0.00', 'en_US');
  var currencyFormatter = NumberFormat.simpleCurrency(locale: "en");

  Future<User?> fetchUser() async {
    FirestoreService firestoreService = FirestoreService();
    final userDoc = await firestoreService.getAuthUser();

    if (userDoc != null) {
      return User.fromFirestore(userDoc);
    } else {
      developer.log('No user document found.');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    activeUser = await fetchUser();
    card = activeUser?.card;
    transactions = card?.transactions;
    await ref.watch(cardNotifierProvider.notifier).getCard();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (activeUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error. Please, try again later.'),
        ),
      );
    }
    isEmptyCard = ref.read(cardNotifierProvider.notifier).isEmptyCard;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        child: Column(
          children: [
            WalletHeader(),
            SizedBox(
              height: 36,
            ),
            WalletCard(),
            SizedBox(
              height: 36,
            ),
            !isEmptyCard ? WalletQuickActions() : Text(''),
            SizedBox(
              height: 36,
            ),
            Expanded(child: WalletTransactionList()),
            WalletNavigationBar(),
          ],
        ),
      ),
    );
  }
}
