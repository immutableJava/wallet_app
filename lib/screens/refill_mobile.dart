import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/providers/card_provider.dart';
import 'package:wallet_app/widgets/common/main_app_bar.dart';
// import 'dart:developer' as developer;

class RefillMobileScreen extends ConsumerStatefulWidget {
  const RefillMobileScreen({super.key});

  @override
  ConsumerState<RefillMobileScreen> createState() => _RefillMobileScreenState();
}

class _RefillMobileScreenState extends ConsumerState<RefillMobileScreen> {
  final _amountController = TextEditingController();
  final _phoneNumberController = PhoneController();
  final FirestoreService firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String amount = _amountController.text;
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
      firestoreService.topUpBalance(
        amount,
        ref.read(cardNotifierProvider).cardNumber,
        topUpPhone: true,
        phoneNumber: _phoneNumberController.value.toString(),
      );
    } else {
      return;
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    ref.read(cardNotifierProvider.notifier).getCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Column(
            children: [
              Text(
                'Your phone number',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 48,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(173, 225, 225, 225),
                      ),
                      child: PhoneFormField(
                        validator: PhoneValidator.compose([
                          PhoneValidator.required(context),
                          PhoneValidator.validMobile(context)
                        ]),
                        controller: _phoneNumberController,
                        countrySelectorNavigator:
                            const CountrySelectorNavigator.page(),
                        // onChanged: (phoneNumber) =>
                        //     developer.log('changed into $phoneNumber'),
                        enabled: true,
                        isCountrySelectionEnabled: true,
                        isCountryButtonPersistent: true,
                        countryButtonStyle: const CountryButtonStyle(
                            showDialCode: true,
                            showIsoCode: true,
                            showFlag: true,
                            flagSize: 16),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black,
                            ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(173, 225, 225, 225),
                      ),
                      child: TextFormField(
                        controller: _amountController,
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
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please, enter amount for top up your number.';
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
                    SizedBox(
                      height: 150,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(91, 37, 159, 1)),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
