import 'package:finance_firebase/controllers/splash.controller.dart';
import 'package:finance_firebase/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = GetIt.instance.get<SplashController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => preload());
  }

  Future preload() async {
    if (_controller.checkIfUserLogged()) {
      final response = await _controller.login();
      if (response.isSuccess) {
        if (response.data!) {
          Navigator.pushReplacementNamed(navigatorKey.currentContext!, "/home");
        } else {
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, "/login");
        }
      } else {
        Navigator.pushReplacementNamed(navigatorKey.currentContext!, "/login");
      }
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.blue,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
