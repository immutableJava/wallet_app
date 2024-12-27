import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';
import '../widgets/auth/auth_social.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false;

  void toggleLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                'Immediately feel the ease of transacting just by registering',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black, fontSize: 24),
              ),
              SizedBox(
                height: 64,
              ),
              AuthSocial(toggleLogin, isLogin),
              SizedBox(
                height: 36,
              ),
              AuthForm(toggleLogin, isLogin),
            ],
          ),
        ),
      ),
    );
  }
}
