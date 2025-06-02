import 'dart:async';

import 'package:muscle_up_mobile/core/library/extensions.dart'
    show ParsingStringList;
import 'package:sqflite/sqflite.dart';

export 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm, Batch;

const String _kDatabaseName = 'app.db';

final String kTypeInteger = TypeColumn.integer.name;
final String kTypeText = TypeColumn.text.name;
final String kTypeReal = TypeColumn.real.name;

enum TypeColumn { integer, text, real }

final class ColumnTableEntity {
  final String name;
  final TypeColumn type;

  const ColumnTableEntity({required this.name, required this.type});
}

abstract interface class IMigrateService {
  Future<Database?> getDb();
  Future<void> onCreate(Database db, int version);
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion);
  Future<bool> deleteTables({bool deleteAll = false});
  Future<void> closeDataBase();
}

final class MigrateService implements IMigrateService {
  String? _databasesPath;
  Database? _database;

  MigrateService({Database? databaseTest, String? databasesPathTest}) {
    _database = databaseTest;
    _databasesPath = databasesPathTest;
  }

  @override
  Future<Database?> getDb() async {
    if (_database != null) return _database;
    return _database = await _createDatabase();
  }

  Future<Database> _createDatabase() async {
    _databasesPath = _databasesPath ?? await getDatabasesPath();
    final String path = [_databasesPath!, _kDatabaseName].joinPath;
    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
  }

  @override
  Future<void> onCreate(Database db, int _) async {
    await db.execute('''
      CREATE TABLE workout (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT
      );

      CREATE TABLE muscle_day (
        id TEXT PRIMARY KEY,
        workout_id TEXT,
        type TEXT,
        muscle_groups TEXT,
        FOREIGN KEY (workout_id) REFERENCES workout(id) ON DELETE CASCADE
      );

      CREATE TABLE exercise (
        id TEXT PRIMARY KEY,
        muscle_day_id TEXT,
        name TEXT,
        sets INTEGER,
        reps INTEGER,
        weight REAL,
        notes TEXT,
        FOREIGN KEY (muscle_day_id) REFERENCES muscle_day(id) ON DELETE CASCADE
      );

  ''');
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      // Lógica de upgrade de versão do banco.
    }
  }

  @override
  Future<void> closeDataBase() async {
    try {
      await _database?.close();
    } catch (_) {}
  }

  @override
  Future<bool> deleteTables({bool deleteAll = false}) async {
    final db = await getDb();
    if (db == null) return false;

    // Aqui você pode deletar tabelas específicas se quiser
    // ou simplesmente deixar como placeholder por enquanto.
    return true;
  }
}
