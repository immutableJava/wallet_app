import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/models/bank_card.dart';

class User {
  final String id;
  final String name;
  final String username;
  final String email;
  String image;
  final BankCard? card;

  User({
    String? id,
    required this.name,
    required this.email,
    this.card,
    required this.username,
    this.image = '',
  }) : id = id ?? Uuid().v4();

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      card: data['card'] != null
          ? BankCard.fromMap(data['card'])
          : BankCard.fromMap(BankCard.empty().toMap()),
    );
  }

  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
      card: data['card'] != null
          ? BankCard.fromMap(data['card'])
          : BankCard.fromMap(BankCard.empty().toMap()),
    );
  }

  @override
  String toString() {
    return 'User{id: $id, card: $card, email: $email, username: $username},';
  }
}
