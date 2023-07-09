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
    return await openDatabase(
      join(dbPath, 'hudson-0.1.1.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_accountType);
    await db.execute(_brand);
    await db.execute(_bank);
    await db.execute(_account);
    await db.execute(_card);
    await db.execute(_billing);
    await db.execute(_exchange);

    await db.execute(_insertAccountTypes);
    await db.execute(_insertBanks);
    await db.execute(_insertBrands);
  }

  String get _bank => '''
    CREATE TABLE bank (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      image_url TEXT
    );
  ''';

  String get _accountType => '''
    CREATE TABLE account_type (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL
    );
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
    );
  ''';

  String get _brand => '''
    CREATE TABLE brand (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      image_url TEXT NOT NULL
    );
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
    );
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
    );
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
    );
  ''';

  String get _insertBanks => '''
    INSERT INTO bank (name, image_url) VALUES ('Santander', 'https://i.pinimg.com/originals/d7/96/dc/d796dcc6d450e585e28a550777211b0a.jpg');
    INSERT INTO bank (name, image_url) VALUES ('Itaú', 'https://apprecs.org/gp/images/app-icons/300/20/com.itau.jpg');
  ''';

  String get _insertBrands => '''
    INSERT INTO brand (name, image_url) VALUES ('Mastercard', 'https://www.mastercard.com/content/dam/public/brandcenter/content-1.png');
    INSERT INTO brand (name, image_url) VALUES ('Visa', 'https://logowik.com/content/uploads/images/857_visa.jpg');
  ''';

  String get _insertAccountTypes => '''
    INSERT INTO account_type (name) VALUES ('Conta Corrente');
    INSERT INTO account_type (name) VALUES ('Conta de Pagamento');
    INSERT INTO account_type (name) VALUES ('Poupança');
  ''';
}
