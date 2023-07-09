import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/account_model.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;

  AccountRepository() {
    _initRepository();
  }

  void _initRepository() async {
    db = await DB.instance.database;
  }

  String get _selectAccounts => '''
    SELECT a.id as id, a.name as name, b.name as bank_name, b.id as bank_id,
      at.name as type_name, at.id as type_id, b.image_url as bank_image, a.balance as balance
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

  deleteAccount(AccountModel account) async {
    await db.delete("account", where: "id = ?", whereArgs: [account.id]);
  }

  Future<List<AccountModel>> getAccounts() async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.rawQuery(_selectAccounts);
    return List.generate(data.length, (i) => AccountModel.fromMap(data[i]));
  }

  Future<List<AccountTypeModel>> getAccountTypes() async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.query("account_type");
    return List.generate(data.length, (i) => AccountTypeModel.fromMap(data[i]));
  }

  Future<List<BankModel>> getBanks() async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.query("bank");
    return List.generate(data.length, (i) => BankModel.fromMap(data[i]));
  }
}
