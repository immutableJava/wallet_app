import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/models/user_transaction.dart';

class BankCard {
  final String id;
  final String bankName = 'Mabank';
  final String cardHolderName;
  final String cardNumber;
  final DateTime expiryDate;
  final String cvv;
  double balance;
  String? cardType;
  String? currency;
  String? cardNetwork;
  List<UserTransaction> transactions;

  BankCard({
    String? id,
    this.cardType,
    this.cardHolderName = '',
    this.cardNumber = '',
    DateTime? expiryDate,
    this.cvv = '',
    this.currency,
    this.cardNetwork,
    this.transactions = const [],
    this.balance = 0,
  })  : id = id ?? Uuid().v4(),
        expiryDate = expiryDate ?? DateTime.now();

  BankCard.empty()
      : id = Uuid().v4(),
        cardHolderName = '',
        cardNumber = '',
        expiryDate = DateTime.now(),
        cvv = '',
        balance = 0,
        cardType = null,
        currency = null,
        cardNetwork = null,
        transactions = [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardType': cardType,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'currency': currency,
      'cardNetwork': cardNetwork,
      'balance': balance,
      'userTransactions':
          transactions.map((transaction) => transaction.toMap()).toList(),
    };
  }

  factory BankCard.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return BankCard(
      id: data['id'],
      cardHolderName: data['cardHolderName'],
      cardNumber: data['cardNumber'],
      expiryDate: data['expiryDate'] is Timestamp
          ? (data['expiryDate'] as Timestamp).toDate()
          : data['expiryDate'] as DateTime,
      cvv: data['cvv'],
      cardType: data['cardType'],
      currency: data['currency'],
      cardNetwork: data['cardNetwork'],
      balance: (data['balance'] is int
          ? (data['balance'] as int).toDouble()
          : data['balance']) as double,
      transactions: (data['userTransactions'] as List)
          .map((transactionData) =>
              UserTransaction.fromFirestore(transactionData))
          .toList(),
    );
  }

  factory BankCard.fromMap(Map<String, dynamic> data) {
    return BankCard(
      id: data['id'],
      cardHolderName: data['cardHolderName'],
      cardNumber: data['cardNumber'],
      expiryDate: data['expiryDate'] is Timestamp
          ? (data['expiryDate'] as Timestamp).toDate()
          : data['expiryDate'] as DateTime,
      cvv: data['cvv'],
      cardType: data['cardType'],
      currency: data['currency'],
      cardNetwork: data['cardNetwork'],
      balance: (data['balance'] is int
          ? (data['balance'] as int).toDouble()
          : data['balance']) as double,
      transactions: ((data['userTransactions'] ?? []) as List)
          .map((transactionData) => UserTransaction.fromMap(transactionData))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'BankCard{'
        'id: $id, '
        'cardType: $cardType, '
        'cardHolderName: $cardHolderName, '
        'cardNumber: $cardNumber, '
        'expiryDate: $expiryDate, '
        'cvv: $cvv, '
        'currency: $currency, '
        'cardNetwork: $cardNetwork, '
        'balance: $balance, '
        'transactions: $transactions'
        '}';
  }
}
