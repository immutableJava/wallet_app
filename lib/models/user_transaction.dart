import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class UserTransaction {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderCardNumber;
  final String receiverCardNumber;
  final String title;
  final double amount;
  final String senderCurrency;
  final String receiverCurrency;

  final Category category;
  final int icon;
  final DateTime date;

  UserTransaction({
    String? id,
    required this.senderId,
    required this.receiverId,
    required this.senderCardNumber,
    required this.receiverCardNumber,
    required this.title,
    required this.amount,
    required this.senderCurrency,
    required this.receiverCurrency,
    required this.category,
    required this.date,
    required this.icon,
  }) : id = id ?? Uuid().v4();

  IconData getIcon(int iconCode) {
    return IconData(iconCode, fontFamily: 'MaterialIcons');
  }

  factory UserTransaction.fromFirestore(transactionData) {
    Map data = transactionData.data() as Map;
    return UserTransaction(
      id: transactionData.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      senderCardNumber: data['senderCardNumber'],
      receiverCardNumber: data['receiverCardNumber'],
      title: data['title'],
      amount: data['amount'],
      senderCurrency: data['senderCurrency'],
      receiverCurrency: data['receiverCurrency'],
      category: data['category'],
      date: data['date'],
      icon: data['icon'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderCardNumber': senderCardNumber,
      'receiverCardNumber': receiverCardNumber,
      'title': title,
      'amount': amount,
      'senderCurrency': senderCurrency,
      'receiverCurrency': receiverCurrency,
      'category': category.name,
      'date': date,
      'icon': icon,
    };
  }

  factory UserTransaction.fromMap(Map<String, dynamic> map) {
    return UserTransaction(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      senderCardNumber: map['senderCardNumber'],
      receiverCardNumber: map['receiverCardNumber'],
      title: map['title'],
      amount: map['amount'].toDouble(),
      senderCurrency: map['senderCurrency'],
      receiverCurrency: map['receiverCurrency'],
      category: Category.values
          .firstWhere((e) => e.name.toString() == map['category']),
      date: (map['date'] as Timestamp).toDate(),
      icon: map['icon'],
    );
  }
  @override
  String toString() {
    return 'Transaction{id: $id, senderId: $senderId, receiverId: $receiverId, senderCardNumber: $senderCardNumber, receiverCardNumber: $receiverCardNumber, title: $title, amount: $amount, senderCurrency: $senderCurrency, receiverCurrency: $receiverCurrency, category: $category, icon: $icon, date: $date';
  }
}

enum Category {
  groceries,
  entertainment,
  utilities,
  income,
  dining,
  travel,
  healthcare,
  education,
  shopping,
  others,
}
