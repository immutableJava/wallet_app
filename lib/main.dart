import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wallet_app/screens/auth.dart';
import 'package:wallet_app/screens/wallet.dart';
// import 'package:wallet_app/screens/auth.dart';
// import 'package:wallet_app/screens/card_add.dart';
// import 'package:wallet_app/screens/card_detail.dart';
// import 'package:wallet_app/screens/notifications.dart';
// import 'package:wallet_app/screens/settings.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromRGBO(144, 56, 255, 1),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet App Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: kColorScheme,
        primaryColor: kColorScheme.primary,
        scaffoldBackgroundColor: Colors.white,
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        iconTheme: IconThemeData(color: kColorScheme.onPrimary),
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme.copyWith(
                titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorScheme.onPrimaryContainer,
                    ),
                bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kColorScheme.onPrimaryContainer,
                    ),
                bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kColorScheme.onPrimaryContainer,
                    ),
              ),
        ),
      ),
      home: AuthScreen(),
    );
  }
}
