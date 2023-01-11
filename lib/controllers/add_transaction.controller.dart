import 'package:finance_firebase/infra/repositories/transaction.repository.dart';
import 'package:finance_firebase/models/transaction.model.dart';
import 'package:finance_firebase/stores/transactions.store.dart';
import 'package:get_it/get_it.dart';

class AddTransactionController {
  final TransactionRepository _repository;

  AddTransactionController(this._repository);

  final _store = GetIt.instance.get<TransactionsStore>();

  Future<bool> registerTransaction(
      double value, String description, DateTime date) async {
    Transaction transaction =
        Transaction(date: date, description: description, value: value);
    final response = await _repository.add(transaction);
    if (response.isSuccess) {
      _store.addTransaction(response.data!);
      return true;
    } else {
      return false;
    }
  }
}
