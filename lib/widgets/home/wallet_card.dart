import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/providers/card_provider.dart';
import 'package:wallet_app/screens/card_detail.dart';
import '../../models/user.dart';
import '../../screens/card_add.dart';

class WalletCard extends ConsumerStatefulWidget {
  const WalletCard({super.key});

  @override
  ConsumerState<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends ConsumerState<WalletCard> {
  FirestoreService firestoreService = FirestoreService();
  User? currentUser;
  var formatter = NumberFormat('#,##0.00', 'en_US');
  var currencyFormatter = NumberFormat.simpleCurrency(locale: "en");
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<User?> getCurrentUser() async {
    DocumentSnapshot? doc = await firestoreService.getAuthUser();
    if (doc == null) return null;
    return User.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> fetchUserData() async {
    currentUser = await getCurrentUser();
    setState(() {
      isLoading = false;
      ref.read(cardNotifierProvider.notifier).getCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardState = ref.watch(cardNotifierProvider);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CardDetailScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromRGBO(55, 25, 93, 1.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/card-image.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: 140,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cardState.cardHolderName.isEmpty
                ? [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) {
                              return CardAddScreen();
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add_circle_outline_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                    )
                  ]
                : [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          '${formatter.format(cardState.balance)} ${cardState.currency}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          cardState.bankName,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    )
                  ],
          ),
        ),
      ),
    );
  }
}
