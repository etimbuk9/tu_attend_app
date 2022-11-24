import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class Connector {
  Future<List<Map>> getData(tableName) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);

    var dataList = await database.rawQuery('SELECT * from $tableName');

    return dataList;
  }

  Future<List<Map>> getUnsyncedData(tableName) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);

    var dataList =
        await database.rawQuery('SELECT * from $tableName WHERE sync = "0"');

    return dataList;
  }

  Future<List<Map>> getUnsyncedEventData(tableName, eventName) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);

    var dataList = await database.rawQuery(
        'SELECT * from $tableName WHERE sync = "0" AND eventname = "$eventName"');

    return dataList;
  }

  Future<void> changeSyncStatus(tableName, id) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);

    await database.rawQuery('UPDATE $tableName SET sync="1" WHERE id = "$id"');

    // return dataList;
  }

  Future<List<Map>> getEventData(tableName, eventname) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);

    var dataList = await database.rawQuery(
        'SELECT * from $tableName WHERE eventname = "$eventname"'); //AND sync = "0"');

    return dataList;
  }

  Future<void> createAttendTable(tableName) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);
    await database.execute(
        'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, eventname TEXT, studentNo TEXT, time TEXT, sync TEXT, hash TEXT)');
    print('Table $tableName created');
  }

  Future<void> createSignupTable(tableName) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);
    await database.execute(
        'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, firstname TEXT, surname TEXT, studentNo TEXT)');
    print('Table $tableName created');
  }

  Future<void> insertSignupData(tableName, data) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);
    await database.rawInsert(
        'INSERT INTO $tableName (firstname, surname, studentNo) VALUES (?,?,?)',
        data);
  }

  Future<void> deleteSignupData(tableName) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);
    await database.rawInsert('DELETE FROM $tableName');
  }

  Future<void> insertData(tableName, data) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);
    await database.rawInsert(
        'INSERT INTO $tableName (firstname, surname, studentNo) VALUES (?,?,?)',
        data);
  }

  Future<void> deleteAllData() async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);
    await database.execute('DELETE FROM attendance');
    print('deleted');
  }

  Future<void> deleteEvent(eventName) async {
    var dbpaths = await getDatabasesPath();
    var path = join(dbpaths, 'attendanceData.db');

    Database database = await openDatabase(path);
    await database
        .execute('DELETE FROM attendance WHERE eventname = "$eventName"');
    print('deleted');
  }

  Future<void> createDB(tableName) async {
    String databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "attendanceData.db");

    // Check if the database exists

    var exists = await databaseExists(path);
    print(exists);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      final Future<Database> database = openDatabase(
        path,
        // When you create a database, it also needs to create a table to store books.
        onCreate: (db, version) {
          // Run the CREATE TABLE statement.
          return db.execute(
              'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, eventname TEXT, studentNo TEXT, time TEXT, sync TEXT, hash TEXT)');
        },
        // Set the version to perform database upgrades and downgrades.
        version: 1,
      );
    }
  }
}
