import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:wallet_app/models/user_transaction.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({required this.transaction, super.key});

  final UserTransaction transaction;
  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _NotificationCardState extends State<NotificationCard> {
  var formatter = NumberFormat('#,##0.00', 'en_US');

  var isSender = true;
  @override
  Widget build(BuildContext context) {
    isSender =
        _auth.currentUser?.uid == widget.transaction.senderId ? true : false;
    String notificationText = isSender
        ? 'You spent ${formatter.format(widget.transaction.amount.abs())} ${widget.transaction.senderCurrency} for ${widget.transaction.title} operation'
        : 'You receive ${formatter.format((widget.transaction.amount))} ${widget.transaction.receiverCurrency} from ${widget.transaction.title} operation';
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd.MM.yyyy HH:mm')
                      .format(widget.transaction.date),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
                Text(
                  notificationText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                ),
                Text(
                  widget.transaction.category.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          isSender
              ? SvgPicture.asset(
                  'assets/icons/arrow-bottom.svg',
                  width: 32,
                  height: 32,
                )
              : SvgPicture.asset(
                  'assets/icons/arrow-top.svg',
                  width: 32,
                  height: 32,
                ),
        ],
      ),
    );
  }
}
