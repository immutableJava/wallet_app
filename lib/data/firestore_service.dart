import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/models/user_transaction.dart';
import 'package:wallet_app/providers/transactions_list_provider.dart';
import 'dart:developer' as developer;
import '../models/bank_card.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final container = ProviderContainer();

  Future<void> createUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      await _db.collection('users').doc(userId).set(
        {
          'username': username,
          'email': email,
          'card': null,
        },
      );
    } on FirebaseAuthException catch (e) {
      developer.log('createUserError: $e', error: e);
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      developer.log('loginUser Error: $e = $stackTrace',
          error: e, stackTrace: stackTrace);
      throw Exception(
        'Login failed: ${e.message}',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userSnapshot = await _db.collection('users').doc(user.uid).get();
        if (!userSnapshot.exists) {
          await _db.collection('users').doc(user.uid).set({
            'username':
                user.email != null ? user.email!.split('@')[0] : 'unnamed',
            'email': user.email,
            'card': null,
          });
        }
      }
    } catch (e) {
      developer.log('GoogleSignInError: $e');
    }
  }

  Future<void> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      developer.log('GoogleSignOutError: $e');
    }
  }

  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (user.providerData
            .any((provider) => provider.providerId == 'google.com')) {
          await GoogleSignIn().signOut();
        }
        await _auth.signOut();
      }
    } catch (e) {
      developer.log('signOut Error: $e', error: e);
    }
  }

  Future<DocumentSnapshot?> getAuthUser() async {
    try {
      String? authUserId = _auth.currentUser?.uid;
      if (authUserId == null) {
        throw Exception('User does not exist');
      }

      DocumentSnapshot userDoc =
          await _db.collection('users').doc(authUserId).get();

      if (userDoc.exists) {
        return userDoc;
      } else {
        throw Exception('User document does not exist or data is null');
      }
    } catch (e) {
      developer.log('getAuthUser Error: $e', error: e);
      return null;
    }
  }

  Future<void> generateCard(BankCard card) async {
    try {
      String? authUserId = _auth.currentUser?.uid;
      if (authUserId == null) {
        throw Exception('User does not exist');
      }
      await _db.collection('users').doc(authUserId).update({
        'card': card.toMap(),
      });
    } catch (e) {
      developer.log('addCard Error: $e', error: e);
    }
  }

  Future<User?> findUserByCardNumber(String cardNumber) async {
    QuerySnapshot<Map<String, dynamic>> usersDoc =
        await _db.collection('users').get();
    List<User> users = usersDoc.docs.map(
      (doc) {
        Map<String, dynamic> data = doc.data();
        return User.fromMap(doc.id, data);
      },
    ).toList();
    for (var user in users) {
      if (user.card == null) {
        continue;
      }
      if (user.card!.cardNumber == cardNumber) {
        return user;
      }
    }
    return null;
  }

  Future<String> findCardNumberOfAuthUser() async {
    try {
      DocumentSnapshot? doc = await getAuthUser();

      Map<String, dynamic> userData = doc!.data() as Map<String, dynamic>;
      if (userData.containsKey('card')) {
        String? cardNumber = userData['card']['cardNumber'];
        if (cardNumber == null || cardNumber.isEmpty) {
          throw Exception(
              'getCardNumberOfAuthUser error: cardNumber not found');
        }
        return cardNumber;
      }
      throw Exception('getCardNumberOfAuthUser error: Card data not found');
    } catch (e) {
      throw Exception('getCardNumberOfAuthUser error: $e');
    }
  }

  Future<String> findUsernameOfAuthUser() async {
    String? authUserId = _auth.currentUser?.uid;
    DocumentSnapshot? userDoc =
        await _db.collection('users').doc(authUserId).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    if (userData.containsKey('username')) {
      return userData['username'];
    }
    return '';
  }

  Future<void> deleteCard() async {
    try {
      String? authUserId = _auth.currentUser?.uid;
      await _db.collection('users').doc(authUserId).update(
        {
          'card': null,
        },
      );
      if (authUserId == null) {
        throw Exception('User does not exist');
      } else {}
    } catch (e) {
      developer.log('deleteCard Error: $e', error: e);
    }
  }

  Future<void> updateUserField(
      String field, String fieldValue, bool isImage) async {
    try {
      String? authUserId = _auth.currentUser?.uid;
      if (authUserId == null) {
        throw Exception('User does not exist');
      }
      isImage
          ? await _db.collection('users').doc(authUserId).set({
              field: fieldValue,
            }, SetOptions(merge: true))
          : await _db.collection('users').doc(authUserId).update(
              {
                field: fieldValue,
              },
            );
    } catch (e) {
      developer.log('updateUserField Error: $e', error: e);
    }
  }

  // Future<void> updateUserAvatar(File image) async {
  //   try {
  //     DocumentSnapshot? doc = await getAuthUser();
  //     if (doc == null) {
  //       throw Exception("User auth error");
  //     }
  //     User currentUser = User.fromFirestore(doc);

  //     String userId = currentUser.id;

  //     // Загружаем аватарку в Storage
  //     String avatarUrl = await uploadAvatar(userId, image);

  //     // Сохраняем URL в Firestore
  //     await saveAvatarUrl(userId, avatarUrl);
  //   } catch (e) {
  //     print("Ошибка обновления аватарки: $e");
  //   }
  // }

  Future<void> transferAmount(
    String receiverCardNumber,
    String amount,
  ) async {
    // 60002
    String senderCardNumber = await findCardNumberOfAuthUser();
    String? authUserId = _auth.currentUser?.uid;
    String trimmedReceiverCardNumber = receiverCardNumber.replaceAll(' ', '');
    bool isOurTransaction =
        trimmedReceiverCardNumber.substring(1, 6) == '60002';
    if (authUserId == null) {
      return;
    }

    if (isOurTransaction) {
      User? recevierUser =
          await findUserByCardNumber(trimmedReceiverCardNumber);
      if (recevierUser == null) {
        return;
      }
      updateBalance(authUserId, recevierUser.id, amount, senderCardNumber,
          trimmedReceiverCardNumber, false);
      updateBalance(authUserId, recevierUser.id, amount, senderCardNumber,
          trimmedReceiverCardNumber, true);
    } else {
      updateBalance(authUserId, 'AnotherBankId', amount, senderCardNumber,
          trimmedReceiverCardNumber, false);
    }
  }

  Future<void> topUpBalance(
    String amount,
    String senderCardNumber, {
    String phoneNumber = '',
    bool topUpPhone = false,
  }) async {
    DocumentSnapshot? doc = await getAuthUser();
    if (doc == null) {
      throw Exception('User does not exist');
    }
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    User currentUser = User.fromMap(doc.id, userData);
    if (currentUser.card!.balance < double.parse(amount)) {
      throw Exception('You have not enough amount');
    }
    UserTransaction newTransaction = UserTransaction(
      senderId: Uuid().v4(),
      receiverId: doc.id,
      senderCardNumber: senderCardNumber,
      receiverCardNumber:
          topUpPhone ? phoneNumber : currentUser.card!.cardNumber,
      title: topUpPhone ? 'Top Up Phone' : 'Card to Card',
      amount: double.parse(amount) * -1,
      senderCurrency: currentUser.card!.currency!,
      receiverCurrency: currentUser.card!.currency!,
      category: Category.others,
      date: DateTime.now(),
      icon: topUpPhone ? Icons.phone.codePoint : Icons.credit_card.codePoint,
    );

    _db.collection('users').doc(_auth.currentUser!.uid).update({
      'card.balance': FieldValue.increment(
        topUpPhone ? double.parse(amount) * -1 : double.parse(amount),
      ),
      'card.userTransactions': FieldValue.arrayUnion([newTransaction.toMap()]),
    });
  }

  Future<void> updateBalance(
    String senderId,
    String receiverId,
    String amount,
    String senderCardNumber,
    String trimmedReceiverCardNumber,
    bool isAdd,
  ) async {
    try {
      String userId = isAdd ? receiverId : senderId;

      String anotherUserId = isAdd ? senderId : receiverId;
      DocumentSnapshot? authUser = await getAuthUser();
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('users').doc(userId).get();
      User currentUser = User.fromMap(userId, snapshot.data()!);
      DocumentSnapshot<Map<String, dynamic>> anotherSnapshot =
          await _db.collection('users').doc(anotherUserId).get();
      User anotherUser = User.fromMap(anotherUserId, anotherSnapshot.data()!);
      if (authUser == null || authUser.data() == null) {
        throw Exception('User data not found.');
      }

      Map<String, dynamic> courseObject;

      final url = Uri.parse(
          'https://api.frankfurter.dev/v1/latest?base=${currentUser.card!.currency}');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          courseObject = jsonDecode(response.body);
        } else {
          throw Exception('Failed to fetch currency data.');
        }
      } catch (e) {
        throw Exception('Failed to fetch currency data. $e');
      }

      double currentBalance = (currentUser.card!.balance);
      double amountToChange = double.tryParse(amount) ?? 0.0;
      double newBalance;
      double transacBalance = double.tryParse(amount) ?? 0.0;

      if (amountToChange <= 0) {
        throw Exception('Invalid amount entered.');
      }

      if (isAdd) {
        newBalance = anotherUser.card!.currency! != currentUser.card!.currency!
            ? currentBalance +
                amountToChange /
                    courseObject['rates']['${anotherUser.card!.currency}']
            : currentBalance + amountToChange;
        transacBalance =
            anotherUser.card!.currency! != currentUser.card!.currency!
                ? amountToChange /
                    courseObject['rates']['${anotherUser.card!.currency}']
                : amountToChange;
      } else {
        if (currentBalance < amountToChange) {
          throw Exception('Insufficient funds.');
        }
        newBalance = currentBalance - amountToChange;
      }

      DocumentSnapshot<Map<String, dynamic>> receiverSnapshot =
          await _db.collection('users').doc(receiverId).get();
      User receiverUser = User.fromMap(receiverId, receiverSnapshot.data()!);
      UserTransaction newTransaction = UserTransaction(
        senderId: senderId,
        receiverId: receiverId,
        senderCardNumber: senderCardNumber,
        receiverCardNumber: trimmedReceiverCardNumber,
        title: 'Card to Card',
        amount: isAdd ? transacBalance : -transacBalance,
        senderCurrency:
            isAdd ? anotherUser.card!.currency! : currentUser.card!.currency!,
        receiverCurrency: receiverUser.card!.currency!,
        category: Category.others,
        date: DateTime.now(),
        icon: Icons.credit_card.codePoint,
      );
      await _db.collection('users').doc(userId).update({
        'card.balance': newBalance,
        'card.userTransactions':
            FieldValue.arrayUnion([newTransaction.toMap()]),
      });
      container
          .read(transactionsListNotifier.notifier)
          .addTransaction(newTransaction);

      developer.log('Balance updated successfully. New balance: $newBalance');
    } catch (e, stackTrace) {
      developer.log('transferAmountError updating balance: $e',
          stackTrace: stackTrace);
    }
  }
}
 // List<UserTransaction> defaultTransactions = [
      //   UserTransaction(
      //     title: 'Amazon Purchase',
      //     amount: -150.0,
      //     currency: Currency.USD,
      //     category: Category.shopping,
      //     icon: Icons.shopping_cart.codePoint.toString(),
      //     date: DateTime.now().subtract(Duration(days: 2)),
      //   ),
      //   UserTransaction(
      //     title: 'Salary',
      //     amount: 2000.0,
      //     currency: Currency.USD,
      //     category: Category.income,
      //     icon: Icons.attach_money.codePoint.toString(),
      //     date: DateTime.now().subtract(Duration(days: 5)),
      //   ),
      // ];