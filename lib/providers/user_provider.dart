import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/models/user.dart';
import 'dart:developer' as developer;

class UserNotifier extends StateNotifier<User> {
  final FirestoreService _firestoreService = FirestoreService();
  UserNotifier() : super(User(name: '', email: '', username: '', image: '')) {
    loadUserData();
  }
  Future<void> loadUserData() async {
    try {
      DocumentSnapshot? authUserDoc = await _firestoreService.getAuthUser();
      if (authUserDoc == null || !authUserDoc.exists) {
        throw Exception('User does not exist');
      }
      state = User.fromFirestore(authUserDoc);
    } catch (e) {
      developer.log('Error to download user: $e');
    }
  }
}

final userNotifier = StateNotifierProvider<UserNotifier, User>(
  (ref) => UserNotifier(),
);
