import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/account_model.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;

  List<AccountModel> accounts = [];
  List<AccountTypeModel> accountTypes = [];
  List<BankModel> banks = [];

  AccountRepository() {
    _initRepository();
  }

  void _initRepository() async {
    db = await DB.instance.database;
    listAccounts();
    listAccountTypes();
    listBanks();
  }

  listAccounts() async {
    final List<Map<String, dynamic>> data = await db.rawQuery(_selectAccounts);
    accounts = List.generate(data.length, (i) => AccountModel.fromMap(data[i]));
  }

  listAccountTypes() async {
    final List<Map<String, dynamic>> data = await db.query("account_type");
    accountTypes =
        List.generate(data.length, (i) => AccountTypeModel.fromMap(data[i]));
  }

  listBanks() async {
    final List<Map<String, dynamic>> data = await db.query("bank");
    banks = List.generate(data.length, (i) => BankModel.fromMap(data[i]));
  }

  String get _selectAccounts => '''
    SELECT a.id as id, a.name as name, b.name as bank_name, b.id as bank_id,
      at.name as type_name, at.id as type_id, b.image_url as bank_image, (
        SELECT SUM(value*type) FROM exchange WHERE account_id = a.id
      ) as total
    FROM account a
    JOIN account_type at ON a.account_type_id = at.id
    JOIN bank b ON a.bank_id = b.id;
  ''';

  updateAccount(AccountModel account) async {
    await db.update("account", account.toMap(),
        where: "id = ?", whereArgs: [account.id]);
  }

  insertAccount(AccountModel account) async {
    await db.insert("account", account.toMap());
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
}
