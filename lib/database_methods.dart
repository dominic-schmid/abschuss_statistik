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

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  SqliteDB.internal();

  /// Initialize DB
  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'scraper.db');
    print('Database path: $path');
    var taskDb = await openDatabase(path, version: 1, onOpen: (db) async {
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
      // UNIQUE (year, revier, nummer, wildart, geschlecht, hegeinGebietRevierteil, alterm, alterw, gewicht, erleger, begleiter, ursache, verwendung, ursprungszeichen, oertlichkeit, datetime, aufseherDatum, aufseherZeit, aufseher) ON CONFLICT IGNORE
    });
    //   //db.transaction((txn) => txn.query(table))

    print('Initialized Database!');
    return taskDb;
  }

  /// Count number of tables in DB
  Future countTable() async {
    var dbClient = await db;
    var res =
        await dbClient.rawQuery("""SELECT count(*) as count FROM sqlite_master
         WHERE type = 'table' 
         AND name != 'android_metadata' 
         AND name != 'sqlite_sequence';""");
    return res[0]['count'];
  }
}
