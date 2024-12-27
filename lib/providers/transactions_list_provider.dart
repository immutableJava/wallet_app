import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_app/data/firestore_service.dart';

import 'package:wallet_app/models/user.dart';
import 'package:wallet_app/models/user_transaction.dart';
// import 'dart:developer' as developer;

class TransactionsListNotifier
    extends StateNotifier<AsyncValue<List<UserTransaction>>> {
  TransactionsListNotifier() : super(const AsyncLoading());

  FirestoreService firestoreService = FirestoreService();

  Future<void> fetchTransactionsList() async {
    try {
      DocumentSnapshot<Object?>? userDoc = await firestoreService.getAuthUser();
      if (userDoc != null && userDoc.exists) {
        User currentUser =
            User.fromMap(userDoc.id, userDoc.data() as Map<String, dynamic>);
        state = AsyncData(currentUser.card?.transactions ?? []);
      } else {
        state = AsyncError('User not found', StackTrace.current);
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.fromString(e.toString()));
    }
  }

  void addTransaction(UserTransaction transaction) {
    state = AsyncData([...state.value ?? [], transaction]);
  }

  List<UserTransaction> getAllTransactions([bool onlyExpenses = false]) {
    return state.map(
      data: (data) {
        if (onlyExpenses) {
          var expenses = data.value;
          var filteredExpenses =
              expenses.where((trans) => trans.amount < 0).toList();

          return filteredExpenses;
        } else {
          return data.value;
        }
      },
      loading: (loading) => [],
      error: (error) {
        return [];
      },
    );
  }
}

final transactionsListNotifier = StateNotifierProvider<TransactionsListNotifier,
    AsyncValue<List<UserTransaction>>>(
  (ref) => TransactionsListNotifier(),
);
