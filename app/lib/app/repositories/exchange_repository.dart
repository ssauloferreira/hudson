import 'package:hudson/app/database/db.dart';
import 'package:hudson/app/models/exchange_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ExchangeRepository extends ChangeNotifier {
  late Database db;

  ExchangeRepository() {
    _initRepository();
  }

  void _initRepository() async {
    db = await DB.instance.database;
  }

  String get _selectExchanges => '''
    SELECT 
      e.id, e.description, e.value, e.movement_type, e.billing_id, e.account_id, e.date, e.payment_type,
      
      b.id as billing_id, b.month, b.year, b.paid, b.billing_due_day,
      b.billing_start_day, c.id as card_id, c.name as card_name,
      
      c.credit_limit, c.billing_due_day as card_billing_due_day,
      c.billing_start_day as card_billing_start_day, bd.id as brand_id,
      
      bd.name as brand_name, bd.image_url as brand_image, bk.id as bank_id,
      bk.name as bank_name, bk.image_url as bank_image, a.id as account_id,
      
      a.name as account_name, a.balance, at.id as account_type_id,
      
      at.name as account_type_name
    FROM exchange e
    LEFT JOIN billing b ON e.billing_id = b.id
    LEFT JOIN card c ON b.card_id = c.id
    LEFT JOIN brand bd ON c.brand_id = bd.id
    LEFT JOIN bank bk ON c.bank_id = bk.id
    LEFT JOIN account a ON e.account_id = a.id
    LEFT JOIN account_type at ON a.account_type_id = at.id
    ORDER BY e.date DESC;
  ''';

  updateExchange(ExchangeModel exchange) async {
    await db.update("exchange", exchange.toMap(), where: "id = ?", whereArgs: [exchange.id]);
  }

  insertExchange(ExchangeModel exchange) async {
    await db.insert("exchange", exchange.toMap());
  }

  deleteExchange(ExchangeModel exchange) async {
    await db.delete("exchange", where: "id = ?", whereArgs: [exchange.id]);
  }

  Future<List<ExchangeModel>> getExchanges() async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.rawQuery(_selectExchanges);
    return List.generate(data.length, (i) => ExchangeModel.fromMap(data[i]));
  }

  Future<List<ExchangeModel>> getExchangesByFilters(String where, List whereArgs) async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.query("exchange", where: where, whereArgs: whereArgs);
    return List.generate(data.length, (i) => ExchangeModel.fromMap(data[i]));
  }
}
