import 'package:altx/firebase_options.dart';
import 'package:altx/pages/home.dart';
import 'package:altx/pages/loginpage.dart';
import 'package:altx/providers/user_provider.dart';
import 'package:altx/theme/dark_mode.dart';
import 'package:altx/theme/light_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ref.read(userProvider.notifier).login(snapshot.data!.email!);
              return const Home();
            }
            return LoginPage();
          }),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
