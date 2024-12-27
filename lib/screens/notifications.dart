import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_app/providers/transactions_list_provider.dart';

import 'package:wallet_app/widgets/common/main_app_bar.dart';
import 'package:wallet_app/widgets/notification/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(transactionsListNotifier.notifier).fetchTransactionsList();
    final transactionsState = ref.read(transactionsListNotifier);
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Center(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Notifications',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: transactionsState.when(
                  data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: NotificationCard(
                          transaction: data[index],
                        ),
                      );
                    },
                  ),
                  error: (error, stack) => Text('Error: $error'),
                  loading: () => CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
