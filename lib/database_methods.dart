import 'package:jagdverband_scraper/models/kill_entry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDB {
  static final SqliteDB _instance = SqliteDB.internal();

  factory SqliteDB() => _instance;
  static Database? _db;

  final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final textType = 'TEXT NOT NULL';
  final boolType = 'BOOLEAN NOT NULL';
  final integerType = 'INTEGER NOT NULL';

  Future<Database> get db async => _db ?? await initDb();

  SqliteDB.internal();

  /// Initialize DB
  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'scraper.db');
    _db = await openDatabase(path, version: 1, onOpen: (db) async {
      // await db.execute('DROP TABLE IF EXISTS Kill');
      await db.execute("""
      CREATE TABLE IF NOT EXISTS Kill (
        key TEXT PRIMARY KEY,
        year INTEGER,
        revier $textType,
        nummer $integerType,
        wildart $textType,
        geschlecht $textType,
        hegeinGebietRevierteil $textType,
        alterm $textType,
        alterw $textType,
        gewicht REAL,
        erleger $textType,
        begleiter $textType,
        ursache $textType,
        verwendung $textType,
        ursprungszeichen $textType,
        oertlichkeit $textType,
        datetime $textType,
        aufseherDatum TEXT,
        aufseherZeit TEXT,
        aufseher TEXT,
       UNIQUE (key)
      )""");
    });

    print('Initialized Database!');

    return _db;
  }
}
