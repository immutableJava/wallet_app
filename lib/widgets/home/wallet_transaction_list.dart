import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/models/user.dart';
import 'package:wallet_app/models/user_transaction.dart';

// import 'dart:developer' as developer;
import 'package:wallet_app/providers/transactions_list_provider.dart';

class WalletTransactionList extends ConsumerStatefulWidget {
  const WalletTransactionList({super.key, this.onlyExpenses = false});

  final bool onlyExpenses;

  @override
  ConsumerState<WalletTransactionList> createState() =>
      _WalletTransactionListState();
}

class _WalletTransactionListState extends ConsumerState<WalletTransactionList> {
  FirestoreService firestoreService = FirestoreService();

  User? currentUser;
  var viewedTransactionsCount = 2;
  var formatter = NumberFormat('#,##0.00', 'en_US');
  var viewFlag = true;
  Widget? transactionsListWidget;

  Future<User?> getCurrentUser() async {
    DocumentSnapshot? doc = await firestoreService.getAuthUser();
    if (doc == null || !doc.exists) return null;
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    return User.fromMap(doc.id, docData);
  }

  Future<void> fetchCurrentUser() async {
    User? userInfo = await getCurrentUser();
    if (userInfo == null) return;
    setState(() {
      currentUser = userInfo;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchCurrentUser();
    Future.microtask(
      () => ref.read(transactionsListNotifier.notifier).fetchTransactionsList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionsListNotifier);
    transactionState.fetchTransactionsList();

    final transactions =
        ref.watch(transactionsListNotifier.notifier).getAllTransactions();

    viewedTransactionsCount = viewFlag
        ? transactions.length
        : (transactions.length < 2 ? transactions.length : 2);

    if (currentUser == null ||
        currentUser!.card == null ||
        transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(''),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 230,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Center(
                  child: Text(
                    'There is no transactions',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Transactions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      viewFlag = !viewFlag;
                    });
                  },
                  child: Text(
                    viewFlag ? 'View less' : 'View all',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color.fromRGBO(132, 56, 255, 1),
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                itemCount: viewedTransactionsCount,
                itemBuilder: (context, index) {
                  String categoryName = transactions[index].category.name;

                  // if (transactions[index].amount > 0) {
                  //   return SizedBox.shrink();
                  // }
                  return ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromRGBO(132, 56, 255, 1),
                      ),
                      child: Icon(
                        transactions[index].getIcon(transactions[index].icon),
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(transactions[index].title),
                    subtitle: Text(
                      categoryName[0].toUpperCase() + categoryName.substring(1),
                    ),
                    trailing: Text(
                      '${formatter.format(transactions[index].amount)} ${currentUser!.card!.currency}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    // loading: () {
    //   return const Center(child: CircularProgressIndicator());
    // },
    // error: (error, stackTrace) {
    //   return Center(
    //     child: Text(
    //       'Error: $error',
    //       style: Theme.of(context)
    //           .textTheme
    //           .bodyMedium
    //           ?.copyWith(color: Colors.red),
    //     ),
    //   );
    // },
  }
}

extension on AsyncValue<List<UserTransaction>> {
  void fetchTransactionsList() {}
}
