library flipperkit_sqflite_driver;

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_flipperkit/flutter_flipperkit.dart';

class SqfliteDriverTableQueryer implements DatabaseDriverTableQueryer {
  const SqfliteDriverTableQueryer._({
    required this.db,
    required this.table,
    this.verbose = true,
  });

  static SqfliteDriverTableQueryer _singleton({
    required Database db,
    required String table,
    bool verbose = true,
  }) =>
      SqfliteDriverTableQueryer._(db: db, table: table, verbose: verbose);

  factory SqfliteDriverTableQueryer.delegate({
    required Database db,
    required String table,
    bool verbose = true,
  }) =>
      _singleton(db: db, table: table, verbose: verbose);

  final Database db;
  final String table;
  final bool verbose;

  @override
  Future<List<Map<String, dynamic>>> info() async {
    final tableInfo = await db.rawQuery('PRAGMA table_info($table)');

    db.close();
    return Future.value(tableInfo);
  }

  @override
  Future<List<Map<String, dynamic>>> count() async {
    final records = await db.rawQuery('SELECT count(*) as count FROM $table');

    db.close();
    return Future.value(records);
  }

  @override
  Future<List<Map<String, dynamic>>> get(
      {int limit = 20, int offset = 0}) async {
    String sqlString = 'SELECT * FROM $table LIMIT $limit OFFSET $offset';
    if (verbose) {
      print(sqlString);
    }

    final records = await db.rawQuery(sqlString);

    db.close();
    return Future.value(records);
  }
}

class SqfliteDriver implements DatabaseDriver {
  final String fileName;
  final String? path;
  final bool verbose;

  const SqfliteDriver(
    this.fileName, {
    this.path,
    this.verbose = true,
  });

  @override
  Future<SqfliteDriverTableQueryer> table(String name) async {
    return DatabaseHandler.delegate(name: fileName, path: path)
        .initialize()
        .then(
          (db) => SqfliteDriverTableQueryer.delegate(
            db: db,
            table: name,
            verbose: verbose,
          ),
        );
  }

  @override
  Future<List<Map<String, dynamic>>> tables() async {
    final delegate = DatabaseHandler.delegate(name: fileName, path: path);
    await delegate.initialize().then((db) async => await db.rawQuery(
          'SELECT * FROM sqlite_master',
        ));

    final records =
        await delegate.dbInstance.rawQuery('SELECT * FROM sqlite_master');
    await delegate.dbInstance.close();

    return records;
  }
}

class DatabaseHandler {
  DatabaseHandler._({required this.path, required this.name});

  static DatabaseHandler _singleton({
    required String name,
    String? path,
  }) =>
      DatabaseHandler._(name: name, path: path);

  factory DatabaseHandler.delegate({
    required String name,
    String? path,
  }) =>
      _singleton(name: name, path: path);

  final String name;
  final String? path;

  Future<String> get pathOrDefault async => path ?? await getDatabasesPath();

  Database get dbInstance => _database;
  late Database _database;
  bool _firstInitialization = true;

  Future<Database> initialize() async {
    if (_firstInitialization || _database.isOpen != true) {
      _database = await openDatabase(
        '${await pathOrDefault}/$name',
        singleInstance: false,
      );
      _firstInitialization = false;
    }

    return _database;
  }
}
