import 'dart:developer' as developer;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_app/screens/wallet.dart';
import '../../data/firestore_service.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.toggleLogin, this.isLogin, {super.key});

  final bool isLogin;

  final void Function() toggleLogin;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  void _validateForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    try {
      if (widget.isLogin) {
        await _firestoreService.loginUser(
            _emailController.text, _passwordController.text);
      } else {
        await _firestoreService.createUser(_usernameController.text,
            _emailController.text, _passwordController.text);
      }
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => WalletScreen(),
        ),
      );
    } catch (e, stackTrace) {
      developer.log('Validate Error: $e', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = widget.isLogin;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              !isLogin
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(130, 130, 130, 0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/profile.svg'),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _usernameController,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Username',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.grey,
                                      ),
                                  counterText: '',
                                ),
                                maxLength: 20,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length >= 20 ||
                                      value.length <= 3) {
                                    return 'Please enter username between 3 and 20 characters long';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              !isLogin
                  ? SizedBox(
                      height: 24,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromRGBO(130, 130, 130, 0.1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/sms.svg'),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'E-mail',
                            hintStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: [AutofillHints.email],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid e-mail';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromRGBO(130, 130, 130, 0.1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/key-square.svg'),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            hintStyle:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                          obscureText: isObscure,
                          autofillHints: [AutofillHints.password],
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length <= 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/hide.svg',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 64,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Color.fromRGBO(91, 37, 159, 1),
                  ),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Закругленные углы
                    ),
                  ),
                ),
                onPressed: _validateForm,
                child: Text(
                  !isLogin ? 'Register' : 'Log in',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white, fontSize: 24),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              RichText(
                text: TextSpan(
                  text: !isLogin
                      ? 'You have an account? '
                      : 'Don\'t have an account yet? ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: !isLogin ? 'Log in' : 'Register',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Color.fromRGBO(91, 37, 159, 1)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.toggleLogin();
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
