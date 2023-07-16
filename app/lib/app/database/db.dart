import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DB {
  DB._();

  static final DB instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    WidgetsFlutterBinding.ensureInitialized();
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'hudson-0.1.1.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) {
    db.execute(_accountType);
    db.execute(_brand);
    db.execute(_bank);
    db.execute(_account);
    db.execute(_card);
    db.execute(_billing);
    db.execute(_exchange);

    db.execute(_insertAccountTypes);
    db.execute(_insertBanks);
    db.execute(_insertBrands);
    db.execute(_insertAccounts);
    db.execute(_insertCards);
    db.execute(_insertBillings);
    db.execute(_insertExchanges);
  }

  String get _bank => '''
    CREATE TABLE bank (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      image_url TEXT
    )
  ''';

  String get _accountType => '''
    CREATE TABLE account_type (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL
    )
  ''';

  String get _account => '''
    CREATE TABLE account (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      bank_id INTEGER NOT NULL,
      account_type_id INTEGER NOT NULL,
      balance REAL NOT NULL DEFAULT 0,

      FOREIGN KEY(bank_id) REFERENCES bank (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
      FOREIGN KEY(account_type_id) REFERENCES account_type (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    )
  ''';

  String get _brand => '''
    CREATE TABLE brand (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      image_url TEXT NOT NULL
    )
  ''';

  String get _card => '''
    CREATE TABLE card (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      bank_id INTEGER,
      brand_id INTEGER,
      credit_limit REAL DEFAULT 0,
      billing_due_day INTEGER NOT NULL,
      billing_start_day INTEGER NOT NULL,

      FOREIGN KEY(bank_id) REFERENCES bank (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
      FOREIGN KEY(brand_id) REFERENCES brand (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    )
  ''';

  String get _billing => '''
    CREATE TABLE billing (
      id INTEGER PRIMARY KEY,
      month INTEGER NOT NULL,
      year INTEGER NOT NULL,
      card_id INTEGER,
      paid INTEGER NOT NULL,
      billing_due_day INTEGER NOT NULL,
      billing_start_day INTEGER NOT NULL,

      FOREIGN KEY(card_id) REFERENCES card (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    )
  ''';

  String get _exchange => '''
    CREATE TABLE exchange (
      id INTEGER PRIMARY KEY,
      description TEXT NOT NULL,
      date INTEGER NOT NULL,
      value REAL NOT NULL,
      payment_type TEXT NOT NULL,
      movement_type INTEGER NOT NULL,
      billing_id INTEGER,
      account_id INTEGER,
      
      FOREIGN KEY(account_id) REFERENCES account (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
      FOREIGN KEY(billing_id) REFERENCES billing (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    )
  ''';

  String get _insertBanks => '''
    INSERT INTO bank (name, image_url)
    VALUES ('Santander', 'https://i.pinimg.com/originals/d7/96/dc/d796dcc6d450e585e28a550777211b0a.jpg'),
    ('Itaú', 'https://apprecs.org/gp/images/app-icons/300/20/com.itau.jpg');
  ''';

  String get _insertBrands => '''
    INSERT INTO brand (name, image_url) VALUES ('Mastercard', 'https://www.mastercard.com/content/dam/public/brandcenter/content-1.png'),
    ('Visa', 'https://logowik.com/content/uploads/images/857_visa.jpg');
  ''';

  String get _insertAccountTypes => '''
    INSERT INTO account_type (name) VALUES ('Conta Corrente'), ('Conta de Pagamento'),('Poupança')
  ''';

  String get _insertAccounts => '''
    INSERT INTO "main"."account" ("id", "name", "bank_id", "account_type_id", "balance") 
    VALUES (1, 'Minha poupança', 1, 1, 111.13)
  ''';

  String get _insertCards => '''
    INSERT INTO "main"."card" ("id", "name", "bank_id", "brand_id", "credit_limit", "billing_due_day", "billing_start_day") 
    VALUES (1, 'Uniclass Platinum', 1, 2, 1100.0, 5, 28)
  ''';

  String get _insertBillings => '''
  INSERT INTO "main"."billing" ("id", "month", "year", "card_id", "paid", "billing_due_day", "billing_start_day") 
  VALUES 
    (1, 6, 2023, 1, 0, 1, 12),
    (2, 7, 2023, 1, 0, 5, 28)
  ''';

  String get _insertExchanges => '''
    INSERT INTO "main"."exchange" 
      ("id", "description", "date", "value", "payment_type", "movement_type", "billing_id", "account_id") 
    VALUES 
      (1, 'Compra genérica', 1234, 135.0, 'DEBIT', -1, 1, 1),
      (2, 'Teste 2', 1688007600000, 120.09, 'DEBIT', -1, 1, 1),
      (3, 'Salário', 1685588400000, 1500.0, 'DEBIT', 1, null, 1),
      (4, 'Outro gasto', 1662433200000, 90.87, 'DEBIT', -1, null, 1),
      (9, 'Teste 3', 1688526000000, 19.0, 'DEBIT', -1, null, 1),
      (5, 'Teste 23', 1685674800000, 12.22, 'CREDIT', -1, 1, null),
      (10, 'bhubub', 1688526000000, 30.0, 'DEBIT', 1, null, 1),
      (6, 'aa', 1685847600000, 1212.12, 'CREDIT', -1, 2, null),
      (7, 'Teste 1', 1688353200000, 122.22, 'DEBIT', -1, null, 1),
      (8, 'Teste 2', 1688353200000, 10000.0, 'DEBIT', -1, null, 1),
      (11, 'drdrdr', 1688526000000, 10.0, 'DEBIT', -1, null, 1)
''';
}
