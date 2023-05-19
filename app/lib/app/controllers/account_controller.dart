import 'package:app/app/models/account_model.dart';
import 'package:app/app/repositories/account_repository.dart';

class AccountController {
  late AccountRepository repository;
  late List<AccountModel> accounts;
  late List<AccountTypeModel> accountTypes;
  late List<BankModel> banks;

  AccountController() {
    repository = AccountRepository();

    accounts = repository.getAccounts();
    accountTypes = repository.getAccountTypes();
    banks = repository.getBanks();
  }

  List<AccountModel> getAccounts() {
    return accounts;
  }

  List<AccountTypeModel> getAccountTypes() {
    return accountTypes;
  }

  List<BankModel> getBanks() {
    return banks;
  }

  createAccount(AccountModel account) {
    repository.insertAccount(account);
  }

  updaeAccount(AccountModel account) {
    repository.updateAccount(account);
  }
}
