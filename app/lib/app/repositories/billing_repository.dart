import 'package:app/app/database/db.dart';
import 'package:app/app/models/billing_model.dart';
import 'package:app/app/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class BillingRepository extends ChangeNotifier {
  late Database db;

  BillingRepository() {
    _initRepository();
  }

  void _initRepository() async {
    db = await DB.instance.database;
  }

  String get _selectBillings => '''
    SELECT b.id, b.month, b.year, b.paid, b.billing_due_day,
      b.billing_start_day, c.id as card_id, c.name as card_name,
      c.credit_limit, c.billing_due_day as card_billing_due_day,
      c.billing_start_day as card_billing_start_day, bd.id as brand_id,
      bd.name as brand_name, bd.image_url as brand_image, bk.id as bank_id,
      bk.name as bank_name, bk.image_url as bank_image, a.id as account_id,
      a.name as account_name, a.balance, at.id as account_type_id,
      at.name as account_type_name
    FROM billing b
    JOIN card c ON b.card_id = c.id
    JOIN brand bd ON c.brand_id = bd.id
    LEFT JOIN bank bk ON c.bank_id = bk.id
    JOIN account a ON b.account_id = a.id
    JOIN account_type at ON a.account_type_id = at.id;
  ''';

  String get _selectBillingsByDate => '''
    SELECT b.id, b.month, b.year, b.paid, b.billing_due_day,
      b.billing_start_day, c.id as card_id, c.name as card_name,
      c.credit_limit, c.billing_due_day as card_billing_due_day,
      c.billing_start_day as card_billing_start_day, bd.id as brand_id,
      bd.name as brand_name, bd.image_url as brand_image, bk.id as bank_id,
      bk.name as bank_name, bk.image_url as bank_image, a.id as account_id,
      a.name as account_name, a.balance, at.id as account_type_id,
      at.name as account_type_name
    FROM billing b
    JOIN card c ON b.card_id = c.id
    JOIN brand bd ON c.brand_id = bd.id
    LEFT JOIN bank bk ON c.bank_id = bk.id
    JOIN account a ON b.account_id = a.id
    JOIN account_type at ON a.account_type_id = at.id
    WHERE b.month = ? AND b.year = ?;
  ''';

  updateBilling(BillingModel billing) async {
    await db.update("billing", billing.toMap(),
        where: "id = ?", whereArgs: [billing.id]);
  }

  insertBilling(BillingModel billing) async {
    await db.insert("billing", billing.toMap());
  }

  deleteBilling(BillingModel billing) async {
    await db.delete("billing", where: "id = ?", whereArgs: [billing.id]);
  }

  Future<List<BillingModel>> getBillings() async {
    db = await DB.instance.database;
    final List<Map<String, dynamic>> data = await db.rawQuery(_selectBillings);
    return List.generate(data.length, (i) => BillingModel.fromMap(data[i]));
  }

  Future<BillingModel> getBillingByDate(CardModel card, DateTime date) async {
    DateTime currentStartBilling;
    DateTime currentDueDay =
        DateTime(date.year, date.month, card.billingDueDay!);
    DateTime billingDueDay;
    BillingModel billing;

    if (card.billingDueDay! < card.billingStartDay!) {
      currentStartBilling =
          DateTime(date.year, date.month - 2, card.billingStartDay!);
    } else {
      currentStartBilling =
          DateTime(date.year, date.month - 1, card.billingStartDay!);
    }

    if (date.isBefore(currentStartBilling)) {
      billingDueDay = currentDueDay;
    } else {
      billingDueDay = DateTime(date.year, date.month + 1, card.billingDueDay!);
    }

    final List<Map<String, dynamic>> data = await db.query("billing",
        where: "card_id = ? AND month = ? AND year = ?",
        whereArgs: [card.id, billingDueDay.month, billingDueDay.year]);

    if (data.isEmpty) {
      billing = BillingModel(
          month: billingDueDay.month,
          year: billingDueDay.year,
          paid: false,
          billingDueDay: card.billingDueDay,
          billingStartDay: card.billingStartDay,
          card: card);
      insertBilling(billing);
    } else {
      billing = BillingModel.fromMap(data[0]);
    }
    return billing;
  }
}
