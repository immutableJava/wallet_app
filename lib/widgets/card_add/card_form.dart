import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/models/bank_card.dart';
import 'package:wallet_app/providers/card_provider.dart';
import 'package:wallet_app/screens/wallet.dart';
import 'dart:math';

class CardForm extends ConsumerStatefulWidget {
  const CardForm({super.key});

  @override
  ConsumerState<CardForm> createState() => _CardFormState();
}

class _CardFormState extends ConsumerState<CardForm> {
  final FirestoreService firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardHolderNameController =
      TextEditingController();

  String? _selectedCurrency;
  String? _selectedCardNetwork;
  String? _selectedCardType;

  final List<String> _currencies = ['USD', 'EUR', 'GBP'];
  final List<String> _cardNetworks = ['Visa', 'MasterCard'];
  final List<String> _cardTypes = ['Credit Card', 'Debit Card'];

  void _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    BankCard card = BankCard(
      cardNumber: generateCardNumber(_selectedCardNetwork),
      cvv: _generateRandomDigits(3),
      cardHolderName: _cardHolderNameController.text,
      currency: _selectedCurrency.toString(),
      cardNetwork: _selectedCardNetwork.toString(),
      cardType: _selectedCardType.toString(),
      expiryDate: DateTime.now().add(
        Duration(days: 5 * 365),
      ),
    );

    firestoreService.generateCard(card);
    ref.read(cardNotifierProvider.notifier).setCard(card);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WalletScreen()),
    );
  }

  String generateCardNumber(cardNetwork) {
    String cardNumber = '';

    switch (cardNetwork) {
      case 'Visa':
        cardNumber += '4';
        cardNumber += '60002';
        cardNumber += _generateRandomDigits(10);
        break;
      case 'MasterCard':
        cardNumber += '5';
        cardNumber += '60002';
        cardNumber += _generateRandomDigits(10);
        break;
      default:
        throw Exception('Unsupported card network');
    }

    return cardNumber;
  }

  String _generateRandomDigits(length) {
    String randomDigits = '';
    Random random = Random();
    for (var i = 0; i < length; i++) {
      randomDigits += (random.nextInt(10)).toString();
    }
    return randomDigits;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _cardHolderNameController,
                hintText: 'Full Name',
                icon: Icons.person,
                validator: _validateCardHolderName,
              ),
              SizedBox(height: 12),
              _buildDropdownField(
                hintText: 'Select Currency',
                value: _selectedCurrency,
                items: _currencies,
                icon: Icons.attach_money,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                },
              ),
              SizedBox(height: 12),
              _buildDropdownField(
                hintText: 'Card Network',
                value: _selectedCardNetwork,
                items: _cardNetworks,
                icon: Icons.account_balance_wallet,
                onChanged: (value) {
                  setState(() {
                    _selectedCardNetwork = value;
                  });
                },
              ),
              SizedBox(height: 12),
              _buildDropdownField(
                hintText: 'Card Type',
                value: _selectedCardType,
                items: _cardTypes,
                icon: Icons.credit_card,
                onChanged: (value) {
                  setState(() {
                    _selectedCardType = value;
                  });
                },
              ),
              SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(130, 130, 130, 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: controller,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(130, 130, 130, 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                hintText,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.black,
              ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? 'Please select an option' : null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(91, 37, 159, 1)),
        padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        )),
      ),
      onPressed: _validateForm,
      child: Text(
        'Submit',
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontSize: 24),
      ),
    );
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the card holder name';
    }
    if (value.length < 2) {
      return 'Card holder name must be at least 2 characters long';
    }
    if (value.length > 50) {
      return 'Card holder name must not exceed 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Card holder name can only contain letters and spaces';
    }
    return null;
  }
}
