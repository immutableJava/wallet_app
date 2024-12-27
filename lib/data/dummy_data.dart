// import 'package:flutter/material.dart';
// import '../models/user.dart';
// import '../models/user_transaction.dart';
// import '../models/bank_card.dart';

// List<User> users = [
//   User(
//     name: 'Alice',
//     email: 'alice@example.com',
//     username: 'alice123', // Добавлено поле username
//     card: BankCard(
//       type: BankCardType.creditCard,
//       currency: Currency.USD,
//       transactions: [
//         UserTransaction(
//           title: 'Amazon Purchase',
//           amount: -150.0,
//           currency: Currency.USD,
//           category: Category.shopping,
//           icon: Icons.shopping_cart.toString(),
//           date: DateTime.now().subtract(Duration(days: 2)),
//         ),
//         UserTransaction(
//           title: 'Salary',
//           amount: 2000.0,
//           currency: Currency.USD,
//           category: Category.income,
//           icon: Icons.attach_money.toString(),
//           date: DateTime.now().subtract(Duration(days: 5)),
//         ),
//       ],
//     ),
//   ),
//   User(
//     name: 'Bob',
//     email: 'bob@example.com',
//     username: 'bob456', // Добавлено поле username
//     card: BankCard(
//       type: BankCardType.debitCard,
//       currency: Currency.GBP,
//       transactions: [
//         UserTransaction(
//           title: 'Groceries',
//           amount: -100.0,
//           currency: Currency.GBP,
//           category: Category.shopping,
//           icon: Icons.shopping_basket.toString(),
//           date: DateTime.now().subtract(Duration(days: 1)),
//         ),
//         UserTransaction(
//           title: 'Freelance Payment',
//           amount: 500.0,
//           currency: Currency.GBP,
//           category: Category.income,
//           icon: Icons.work.toString(),
//           date: DateTime.now().subtract(Duration(days: 6)),
//         ),
//       ],
//     ),
//   ),
//   User(
//     name: 'Charlie',
//     email: 'charlie@example.com',
//     username: 'charlie789', // Добавлено поле username
//     card: BankCard(
//       type: BankCardType.creditCard,
//       currency: Currency.RUB,
//       transactions: [
//         UserTransaction(
//           title: 'Tech Store',
//           amount: -300.0,
//           currency: Currency.RUB,
//           category: Category.entertainment,
//           icon: Icons.devices_other.toString(),
//           date: DateTime.now().subtract(Duration(days: 4)),
//         ),
//         UserTransaction(
//           title: 'Stock Dividend',
//           amount: 200.0,
//           currency: Currency.RUB,
//           category: Category.income,
//           icon: Icons.trending_up.toString(),
//           date: DateTime.now().subtract(Duration(days: 7)),
//         ),
//       ],
//     ),
//   ),
// ];
