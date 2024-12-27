import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_app/models/bank_card.dart';
import 'package:wallet_app/providers/card_provider.dart';

class CardHeader extends ConsumerStatefulWidget {
  const CardHeader(this.title, this.isCreated, {super.key});

  final String title;
  final bool isCreated;

  @override
  ConsumerState<CardHeader> createState() => _CardHeaderState();
}

class _CardHeaderState extends ConsumerState<CardHeader> {
  Widget content = Text('');
  bool shouldShowCVV = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isCreated) {
      setState(() {
        final bankCardNotifier = ref.read(cardNotifierProvider.notifier);
        bankCardNotifier.getCard();
        BankCard currentCard = ref.read(cardNotifierProvider);
        Widget imageWidget;
        double leftCoordinate = 35;
        double bottomCoordinate = 50;
        if (currentCard.cardNetwork == 'Visa') {
          imageWidget = SvgPicture.asset(
            'assets/icons/visa-logo.svg',
            width: 50,
          );
        } else {
          imageWidget = Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: SvgPicture.asset(
              'assets/icons/mastercard-logo.svg',
              width: 64,
            ),
          );

          bottomCoordinate -= 15;
        }
        String formattedCardNumber = currentCard.cardNumber.replaceAllMapped(
          RegExp(r"(\d{4})(?=\d)"),
          (match) => "${match.group(1)} ",
        );

        content = Stack(children: [
          Positioned(
            left: 35,
            bottom: 100,
            child: Text(formattedCardNumber,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white)),
          ),
          Positioned(
            right: 50,
            bottom: 37,
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: shouldShowCVV
                      ? Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                shouldShowCVV = false;
                              });
                            },
                            child: Text(
                              currentCard.cvv,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: !shouldShowCVV
                      ? Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                shouldShowCVV = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/hide.svg',
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                    width: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Positioned(
            left: leftCoordinate,
            bottom: bottomCoordinate,
            child: imageWidget,
          ),
        ]);
      });
    }
    return Column(
      children: [
        Text(
          widget.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.black),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: const Color.fromRGBO(55, 25, 93, 1.0),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: SvgPicture.asset(
                    'assets/icons/mask-group.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 60,
                top: 60,
                child: SvgPicture.asset('assets/icons/card-chip.svg'),
              ),
              Positioned(
                left: 35,
                top: 60,
                child: Text(
                  'Mabank',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                ),
              ),
              content,
            ],
          ),
        ),
      ],
    );
  }
}
