import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/providers/card_provider.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';
import 'dart:developer' as developer;

class CardTransactionForm extends ConsumerStatefulWidget {
  const CardTransactionForm({required this.isTransfer, super.key});

  final bool isTransfer;

  @override
  ConsumerState<CardTransactionForm> createState() =>
      _CardTransactionFormState();
}

class _CardTransactionFormState extends ConsumerState<CardTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService firestoreService = FirestoreService();
  final _cardNumberController = TextEditingController();
  final _amountController = TextEditingController();

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String amount = _amountController.text;
      String cardNumberText = _cardNumberController.text;
      double currentBalance = ref.read(cardNotifierProvider).balance;
      double currentAmount = double.parse(amount);

      if (currentBalance < currentAmount) {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 114, 0, 253),
              ),
              child: Center(
                child: Text(
                  'You have not enough amount',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            );
          },
        );
        if (mounted) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();
          });
        }
        return;
      }
      if (widget.isTransfer) {
        firestoreService.transferAmount(cardNumberText, amount);
      } else {
        firestoreService.topUpBalance(amount, cardNumberText);
      }
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        children: [
          Center(
            heightFactor: 5.5,
            child: Text(
              widget.isTransfer ? 'Transfer' : 'Top Up',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(173, 225, 225, 225),
                    ),
                    child: TextFormField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black),
                      controller: _cardNumberController,
                      maxLength: 19,
                      decoration: InputDecoration(
                          hintText: 'Card Number',
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.grey,
                                  )),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please, enter correct card number.';
                        }
                        String trimmedValue = value.replaceAll(' ', '');
                        if (!RegExp(r'^[0-9]{16}$').hasMatch(trimmedValue)) {
                          return 'Please enter a valid 16-digit card number.';
                        }

                        // if (!Luhn.validate(trimmedValue)) {
                        //   return 'Invalid card number.';
                        // }

                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberInputFormatter(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(173, 225, 225, 225),
                    ),
                    child: TextFormField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black),
                      maxLength: 19,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        border: InputBorder.none,
                        counterText: '',
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return widget.isTransfer
                              ? 'Please, enter amount for transfer.'
                              : 'Please, enter amount for top up.';
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Please enter a valid positive amount.';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 96,
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: TextButton(
                    onPressed: _validateForm,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 0, 253),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      widget.isTransfer ? 'Transfer' : 'Top up',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String filtered = newValue.text.replaceAll(RegExp(r'\D'), '');

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < filtered.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(filtered[i]);
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
