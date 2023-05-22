import 'package:app/app/models/account_model.dart';
import 'package:app/app/repositories/account_repository.dart';

class AccountController {
  late AccountRepository repository;

  AccountController() {
    repository = AccountRepository();
  }

  Future<List<AccountModel>> getAccounts() {
    return repository.getAccounts();
  }

  Future<List<AccountTypeModel>> getAccountTypes() {
    return repository.getAccountTypes();
  }

  Future<List<BankModel>> getBanks() {
    return repository.getBanks();
  }

  createAccount(AccountModel account) {
    repository.insertAccount(account);
  }

  updateAccount(AccountModel account) {
    repository.updateAccount(account);
  }

  deleteAccount(AccountModel account) {
    repository.deleteAccount(account);
  }
}
