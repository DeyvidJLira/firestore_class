import 'package:finance_firebase/controllers/home.controller.dart';
import 'package:finance_firebase/extensions/date_time.extension.dart';
import 'package:finance_firebase/extensions/double.extension.dart';
import 'package:finance_firebase/models/transaction.model.dart';
import 'package:finance_firebase/stores/transactions.store.dart';
import 'package:finance_firebase/stores/user.store.dart';
import 'package:finance_firebase/ui/components/custom_alert_dialog.component.dart';
import 'package:finance_firebase/ui/components/progress_dialog.component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = GetIt.instance.get<HomeController>();
  final _userStore = GetIt.instance.get<UserStore>();
  final _transactionsStore = GetIt.instance.get<TransactionsStore>();

  final _progressDialog = ProgressDialog();
  final _alertDialog = CustomAlertDialog();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => preload());
  }

  Future preload() async {
    _progressDialog.show("Obtendo dados...");
    await _controller.getList();
    _progressDialog.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App de Finanças"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTransaction,
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Observer(
          builder: (_) => Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              _userStore.profile != null
                  ? Text("Seja bem vindo, ${_userStore.profile!.firstName}")
                  : const Text("Seja bem vindo, ..."),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _controller.decreaseMonth,
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Text(
                      "${_controller.currentDateTime.month}/${_controller.currentDateTime.year}"),
                  IconButton(
                    onPressed: _controller.increaseMonth,
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
              const Divider(
                height: 2,
              ),
              Expanded(
                child: _controller.isLoading
                    ? const SizedBox(
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                        )),
                      )
                    : _transactionsStore.list.isEmpty
                        ? const SizedBox(
                            child: Center(
                              child: Text("Nenhuma transação registrada!"),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 64),
                            itemCount: _transactionsStore.count,
                            itemBuilder: (_, index) => Dismissible(
                                  key: ValueKey<Transaction>(
                                      _transactionsStore.list[index]),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                  ),
                                  onDismissed: (direction) {
                                    _removeTransaction(
                                        _transactionsStore.list[index]);
                                  },
                                  child: ListTile(
                                    title: Text(_transactionsStore
                                        .list[index].description),
                                    subtitle: Text(_transactionsStore
                                        .list[index].date!.toBRLDate),
                                    trailing: Text(_transactionsStore
                                        .list[index].value.toBRL),
                                  ),
                                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _goToAddTransaction() {
    Navigator.pushNamed(context, "/add-transaction");
  }

  _removeTransaction(Transaction item) async {
    _progressDialog.show("Excluindo...");
    final response = await _controller.removeTransaction(item);
    _progressDialog.hide();
    if (response.isError) {
      _alertDialog.showInfo(title: "Ops!", message: response.message!);
    }
  }
}
