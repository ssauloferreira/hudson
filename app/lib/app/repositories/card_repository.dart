import 'package:app/app/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';

class CardRepository extends ChangeNotifier {
  late Database db;

  CardRepository() {
    _initRepository();
  }

  void _initRepository() async {
    db = await DB.instance.database;
  }

  String get _selectCards => '''
    SELECT  c.id, c.name, c.credit_limit,
      billing_due_day, billing_start_day,
      bd.id as brand_id, bd.name as brand_name,
      bd.image_url as brand_image, bk.id as bank_id,
      bk.name as bank_name, bk.image_url as bank_image, (
      credit_limit + COALESCE(
        (
          SELECT SUM(value * movement_type)
          FROM billing b, exchange e
          WHERE e.billing_id = b.id
          AND b.card_id = c.id
          AND b.paid = 0
        ), 0
      )
    ) as available_limit
    FROM card c
    JOIN brand bd ON c.brand_id = bd.id
    LEFT JOIN bank bk ON c.bank_id = bk.id;
  ''';

  updateCard(CardModel card) async {
    await db.update("card", card.toMap(), where: "id = ?", whereArgs: [card.id]);
  }

  insertCard(CardModel card) async {
    await db.insert("card", card.toMap());
  }

  deleteCard(CardModel card) async {
    await db.delete("card", where: "id = ?", whereArgs: [card.id]);
  }

  Future<List<CardModel>> getCards() async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.rawQuery(_selectCards);
    return List.generate(data.length, (i) => CardModel.fromMap(data[i]));
  }

  Future<List<BrandModel>> getBrands() async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.query("brand");
    return List.generate(data.length, (i) => BrandModel.fromMap(data[i]));
  }
}
