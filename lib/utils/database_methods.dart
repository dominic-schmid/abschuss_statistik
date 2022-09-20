import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/models/shooting_time.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kill_entry.dart';
import '../models/kill_page.dart';

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
    if (_db != null) await _db!.close();
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
        gpsLat REAL,
        gpsLon REAL,
        datetime $textType,
        aufseherDatum TEXT,
        aufseherZeit TEXT,
        aufseher TEXT,
       UNIQUE (key)
      )""");

      await db.execute("""
      CREATE TABLE IF NOT EXISTS ShootingTime (
        tag $textType,
        gpsLat REAL,
        gpsLon REAL,
        aufgang $textType,
        untergang $textType
      )""");
    });

    print('Initialized Database!');

    return _db;
  }

  Future<void> insertKills(int year, KillPage page) async {
    for (KillEntry k in page.kills) {
      // await d.rawDelete('Delete FROM Kill ');
      var database = await db;

      await database.transaction(
        (txn) async => await txn.insert(
          'Kill',
          {
            'key': '$year-${k.key}',
            'year': year,
            'revier': page.revierName,
            'nummer': k.nummer,
            'wildart': k.wildart,
            'geschlecht': k.geschlecht,
            'hegeinGebietRevierteil': k.hegeinGebietRevierteil,
            'alterm': k.alter,
            'alterw': k.alterw,
            'gewicht': k.gewicht,
            'erleger': k.erleger,
            'begleiter': k.begleiter,
            'ursache': k.ursache,
            'verwendung': k.verwendung,
            'ursprungszeichen': k.ursprungszeichen,
            'oertlichkeit': k.oertlichkeit,
            'gpsLat': k.gpsLat,
            'gpsLon': k.gpsLon,
            'datetime': k.datetime.toIso8601String(),
            'aufseherDatum': k.jagdaufseher == null ? null : k.jagdaufseher!['datum'],
            'aufseherZeit': k.jagdaufseher == null ? null : k.jagdaufseher!['zeit'],
            'aufseher': k.jagdaufseher == null ? null : k.jagdaufseher!['aufseher'],
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        ),
      );
    }
    return;
  }

  Future<void> insertShootingTime(ShootingTime t) async {
    // await d.rawDelete('Delete FROM Kill ');
    var database = await db;

    await database.transaction(
      (txn) async => await txn.insert(
        'ShootingTime',
        {
          'tag': DateFormat("yyyy-MM-dd").format(t.sunrise),
          'gpsLat': t.latLng.latitude,
          'gpsLon': t.latLng.longitude,
          'aufgang': t.sunrise.toIso8601String(),
          'untergang': t.sunset.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      ),
    );

    return;
  }

  Future<ShootingTime?> getShootingTimeFor(LatLng latLng, DateTime day) async {
    var database = await db;

    final res = await database.transaction(
      (txn) async => await txn.query(
        'ShootingTime',
        columns: ['aufgang', 'untergang'],
        orderBy: 'tag, gpsLat',
        whereArgs: [
          DateFormat("yyyy-MM-dd").format(day),
          latLng.latitude,
          latLng.longitude,
        ],
        where: 'tag = ? AND gpsLat = ? AND gpsLon = ?',
      ),
    );

    if (res.isEmpty) return null;

    try {
      DateTime sunrise = DateTime.parse(res.first['aufgang'] as String);
      DateTime sunset = DateTime.parse(res.first['untergang'] as String);
      return ShootingTime(latLng, sunrise, sunset);
    } catch (e) {
      print("Error parsing SQL shooting time: ${e.toString()}");
    }
    return null;
  }

  Future<void> deleteYear(int year) async {
    var database = await db;

    await database
        .transaction((txn) async => await txn.delete('Kill', where: 'year = $year'));
    return;
  }

  delteDb() async {
    if (_db != null) {
      await _db!.delete('Kill');
      _db = null;
    }
  }
}
