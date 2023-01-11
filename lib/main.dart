import 'package:finance_firebase/controllers/add_transaction.controller.dart';
import 'package:finance_firebase/controllers/home.controller.dart';
import 'package:finance_firebase/controllers/login.controller.dart';
import 'package:finance_firebase/controllers/register.controller.dart';
import 'package:finance_firebase/controllers/splash.controller.dart';
import 'package:finance_firebase/firebase_options.dart';
import 'package:finance_firebase/infra/repositories/auth.repository_impl.dart';
import 'package:finance_firebase/infra/repositories/profile.repository_impl.dart';
import 'package:finance_firebase/infra/repositories/transaction.repository_impl.dart';
import 'package:finance_firebase/infra/services/auth.service.dart';
import 'package:finance_firebase/infra/services/profile.service.dart';
import 'package:finance_firebase/infra/services/transaction.service.dart';
import 'package:finance_firebase/navigator_key.dart';
import 'package:finance_firebase/stores/transactions.store.dart';
import 'package:finance_firebase/stores/user.store.dart';
import 'package:finance_firebase/ui/pages/add_transaction.page.dart';
import 'package:finance_firebase/ui/pages/home.page.dart';
import 'package:finance_firebase/ui/pages/login.page.dart';
import 'package:finance_firebase/ui/pages/register.page.dart';
import 'package:finance_firebase/ui/pages/splash.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt.instance.registerSingleton(UserStore());
  GetIt.instance.registerSingleton(TransactionsStore());

  GetIt.instance.registerFactory(
    () => SplashController(AuthRepositoryImpl(AuthService()),
        ProfileRepositoryImpl(ProfileService())),
  );
  GetIt.instance.registerFactory(
    () => LoginController(AuthRepositoryImpl(AuthService()),
        ProfileRepositoryImpl(ProfileService())),
  );
  GetIt.instance.registerFactory(
    () => RegisterController(AuthRepositoryImpl(AuthService()),
        ProfileRepositoryImpl(ProfileService())),
  );
  GetIt.instance.registerFactory(
    () => HomeController(TransactionRepositoryImpl(TransactionService())),
  );
  GetIt.instance.registerFactory(
    () => AddTransactionController(
        TransactionRepositoryImpl(TransactionService())),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/login': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/home': (_) => const HomePage(),
        '/add-transaction': (_) => const AddTransactionPage()
      },
    );
  }
}
