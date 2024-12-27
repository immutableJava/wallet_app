import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_app/models/bank_card.dart';
import 'package:wallet_app/models/user.dart';
import '../../data/firestore_service.dart';

class CardNotifier extends StateNotifier<BankCard> {
  CardNotifier() : super(BankCard());
  bool isEmptyCard = true;
  FirestoreService firestoreService = FirestoreService();
  Future<void> getCard() async {
    DocumentSnapshot<Object?>? userDoc = await firestoreService.getAuthUser();
    if (userDoc != null) {
      User user = User.fromFirestore(userDoc);
      if (user.card == null) {
        state = BankCard.empty();
      } else {
        isEmptyCard = false;
        state = user.card!;
      }
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> setCard(BankCard card) async {
    state = card;
  }
}

final cardNotifierProvider = StateNotifierProvider<CardNotifier, BankCard>(
  (ref) => CardNotifier(),
);
