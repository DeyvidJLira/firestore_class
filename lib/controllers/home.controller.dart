import 'package:finance_firebase/infra/repositories/transaction.repository.dart';
import 'package:finance_firebase/models/api_response.model.dart';
import 'package:finance_firebase/models/transaction.model.dart';
import 'package:finance_firebase/stores/transactions.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'home.controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  final TransactionRepository _transactionRepository;

  HomeControllerBase(this._transactionRepository) {
    _currentDateTime = DateTime.now();
    _currentDateTime = DateTime(
        _currentDateTime.year, _currentDateTime.month, _currentDateTime.day);
  }

  @readonly
  DateTime _currentDateTime = DateTime.now();

  @readonly
  bool _isLoading = false;

  @action
  increaseMonth() async {
    _isLoading = true;
    _currentDateTime = _currentDateTime.add(const Duration(days: 31));
    await getList();
    _isLoading = false;
  }

  @action
  decreaseMonth() async {
    _isLoading = true;
    _currentDateTime = _currentDateTime.subtract(const Duration(days: 31));
    await getList();
    _isLoading = false;
  }

  Future<APIResponse<List<Transaction>>> getList() async {
    final response = await _transactionRepository.getMonth(_currentDateTime);
    if (response.isSuccess) {
      final store = GetIt.instance.get<TransactionsStore>();
      store.replaceList(response.data!);
    }
    return response;
  }

  Future<APIResponse<bool>> removeTransaction(Transaction item) async {
    final response = await _transactionRepository.remove(item);
    if (response.isSuccess) {
      final store = GetIt.instance.get<TransactionsStore>();
      store.removeTransaction(item);
    }
    return response;
  }
}
