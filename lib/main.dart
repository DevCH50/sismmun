import 'package:sismmun/src/blocProvider.dart';
import 'package:sismmun/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:sismmun/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:sismmun/src/presentation/pages/home/HomePage.dart';
import 'package:sismmun/src/presentation/pages/splash/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show MultiBlocProvider;
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        title: 'SISMMUN',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          'login': (BuildContext context) => const LoginPage(),
          'register': (BuildContext context) => const RegisterPage(),
          'Homes': (BuildContext context) => const HomesPage(),
          'splash': (BuildContext context) => const SplashPage(),
        },
        initialRoute: 'splash',
      ),
    );
  }
}
