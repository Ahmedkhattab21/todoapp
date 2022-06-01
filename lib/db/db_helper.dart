import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vs1_application_1/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tabeName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint("not null db");
    } else {
      try {
        String _Path = await getDatabasesPath() + 'task.db';
        _db = await openDatabase(_Path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE $_tabeName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT ,'
            ' title TEXT,note TEXT, isCompleted INTEGER,'
            ' date TEXT,startTime TEXT,endTime TEXT,'
            'color INTEGER ,remind INTEGER ,repeat TEXT )',
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db!.insert(
      _tabeName,
      task!.toJson(),
    );
  }

  static Future<int> deleteAll() async {
    print("delete All functions ");
    return _db!.delete(_tabeName);
  }

  static Future<int> delete(Task? task) async {
    print("delete function called");
    return _db!.delete(
      _tabeName,
      where: 'id = ?',
      whereArgs: [task!.id],
    );
  }

  static Future<int> update(int id) async {
    print("update function called");
    return _db!.rawUpdate(
      '''
      UPDATE $_tabeName
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [1, id],
    );
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return _db!.query(_tabeName);
  }
}
