import 'package:finance_firebase/controllers/login.controller.dart';
import 'package:finance_firebase/navigator_key.dart';
import 'package:finance_firebase/ui/components/custom_alert_dialog.component.dart';
import 'package:finance_firebase/ui/components/progress_dialog.component.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatelessWidget {
  final _controller = GetIt.instance.get<LoginController>();

  LoginPage({super.key});

  final _progressDialog = ProgressDialog();
  final _alertDialog = CustomAlertDialog();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: _controller.changeEmail,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha"),
              onChanged: _controller.changePassword,
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 48,
              child: ElevatedButton(
                onPressed: _doLogin,
                child: const Text("Entrar"),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/register"),
                child: const Text("Se Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _doLogin() async {
    _progressDialog.show("Autenticando...");
    final response = await _controller.doLogin();
    if (response.isSuccess) {
      Navigator.pushNamed(navigatorKey.currentContext!, "/home");
    } else {
      _progressDialog.hide();
      _alertDialog.showInfo(title: "Ops!", message: response.message!);
    }
  }
}
