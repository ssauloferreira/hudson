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
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'hudson.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_accountType);
    await db.execute(_bank);
    await db.execute(_account);
    await db.execute(_card);
    await db.execute(_billing);
    await db.execute(_exchange);

    await db.insert("bank", {
      "name": "Santander",
      "image_url":
          "https://i.pinimg.com/originals/d7/96/dc/d796dcc6d450e585e28a550777211b0a.jpg"
    });
    // await db.execute(_insertAccountTypes);
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

      FOREIGN KEY(bank_id) REFERENCES bank (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
      FOREIGN KEY(account_type_id) REFERENCES account_type (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    );
  ''';

  String get _card => '''
    CREATE TABLE card (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      bank_id INTEGER,
      credit_limit REAL DEFAULT 0,
      billing_due_day INTEGER NOT NULL,
      billing_start_day INTEGER NOT NULL,

      FOREIGN KEY(bank_id) REFERENCES bank (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    );
  ''';

  String get _billing => '''
    CREATE TABLE billing (
      id INTEGER PRIMARY KEY,
      day INTEGER NOT NULL,
      month INTEGER NOT NULL,
      year INTEGER NOT NULL,
      card_id INTEGER,
      due_day INTEGER NOT NULL,
      start_day INTEGER NOT NULL,

      FOREIGN KEY(card_id) REFERENCES card (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    );
  ''';

  String get _exchange => '''
    CREATE TABLE exchange (
      id INTEGER PRIMARY KEY,
      date INTEGER NOT NULL,
      value REAL NOT NULL,
      type INTEGER,
      billing_id INTEGER,
      account_id id NOT NULL,
      
      FOREIGN KEY(account_id) REFERENCES account (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
      FOREIGN KEY(billing_id) REFERENCES billing (id)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
    );
  ''';

  // String get _insertBanks => '''
  //   INSERT INTO banks (name, image_url) VALUES ('Santander', 'https://i.pinimg.com/originals/d7/96/dc/d796dcc6d450e585e28a550777211b0a.jpg');
  //   INSERT INTO banks (name, image_url) VALUES ('Itaú', 'https://apprecs.org/gp/images/app-icons/300/20/com.itau.jpg ');
  // ''';

  // String get _insertAccountTypes => '''
  //   INSERT INTO banks (name) VALUES ('Conta Corrente');
  //   INSERT INTO banks (name) VALUES ('Conta de Pagamento');
  //   INSERT INTO banks (name) VALUES ('Poupança');
  // ''';
}
