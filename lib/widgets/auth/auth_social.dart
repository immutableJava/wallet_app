import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as developer;

import 'package:wallet_app/data/firestore_service.dart';
import 'package:wallet_app/screens/wallet.dart';
import 'package:wallet_app/widgets/home/wallet_card.dart';

class AuthSocial extends StatefulWidget {
  AuthSocial(this.toggleLogin, this.isLogin, {super.key});

  final bool isLogin;

  final void Function() toggleLogin;

  @override
  State<AuthSocial> createState() => _AuthSocialState();
}

class _AuthSocialState extends State<AuthSocial> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                  child: TextButton.icon(
                    icon: SvgPicture.asset(
                      'assets/icons/google-logo.svg',
                      width: 24,
                      height: 24,
                    ),
                    label: Text(
                      !widget.isLogin
                          ? 'Sign up with Google'
                          : 'Log in with Google',
                      style: GoogleFonts.montserrat(
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                    ),
                    onPressed: () async {
                      await _firestoreService.signInWithGoogle();
                      if (mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => WalletScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 25,
        ),
      ],
    );
  }
}
