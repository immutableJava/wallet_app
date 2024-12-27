import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/models/bank_card.dart';
import 'package:wallet_app/models/user_transaction.dart';
import 'package:wallet_app/providers/card_provider.dart';
import 'package:wallet_app/providers/transactions_list_provider.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';
import 'package:wallet_app/widgets/home/wallet_transaction_list.dart';
import 'package:wallet_app/widgets/stats/stats_chart.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});
  @override
  ConsumerState<StatsScreen> createState() => _StatsScreen();
}

class _StatsScreen extends ConsumerState<StatsScreen> {
  final NumberFormat formatter = NumberFormat('#,##0.00', 'en_US');
  List<UserTransaction> transactions = [];
  late BankCard bankCard;

  @override
  void initState() {
    transactions =
        ref.read(transactionsListNotifier.notifier).getAllTransactions(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses = 0;
    bankCard = ref.read(cardNotifierProvider);
    for (var transac in transactions) {
      if (transac.amount < 0) {
        totalExpenses += transac.amount;
      }
    }

    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          children: [
            StatsChart(
              transactions: transactions,
            ),
            SizedBox(
              height: 48,
            ),
            Text(
              'Total Expenses',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey, fontSize: 20),
            ),
            Text(
              '${formatter.format(totalExpenses)} ${bankCard.currency}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Color.fromRGBO(144, 56, 255, 1), fontSize: 36),
            ),
            SizedBox(
              height: 48,
            ),
            Expanded(child: WalletTransactionList(onlyExpenses: true)),
            SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
