import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  final String _databaseName = "posts.db";
  final int _databaseVersion = 1;
  static  final String table = 'posts';

  // make this singleton class
  DBProvider._();
  static final DBProvider instance = DBProvider._();

  // only have a single app-wide reference to the database
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  void _createTableV1(Batch batch) {
    batch.execute('''
    CREATE TABLE posts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      body TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    ) ''');
  }

  //this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    final Directory documentsDirectory =
    await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        var batch = db.batch();
        _createTableV1(batch);
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  /* -------- -------------*/


  //POSTの追加
  static Future<Post> create(String text) async {
    DateTime now = DateTime.now();
    final Map<String, dynamic> row = {
      'body': text,
      'created_at': now.toString(),
      'updated_at': now.toString(),
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return Post(
      id: id,
      body: row["body"],
      createdAt: now,
      updatedAt: now,
    );
  }

  //AllPOSTSの取得
  static Future<List<Post>> getAll() async {
    final db = await instance.database;
    final rows =
    await db.rawQuery('SELECT * FROM $table ORDER BY updated_at DESC');
    if (rows.isEmpty) return null;

    return rows.map((e) => Post.fromMap(e)).toList();
  }

  //A　POST　の取得
  static Future<Post> single(int id) async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table WHERE id = ?', [id]);
    if (rows.isEmpty) return null;

    return Post.fromMap(rows.first);
  }

  //POSTの更新
  static Future<int> update({int id, String text}) async {
    String now = DateTime.now().toString();
    final row = {
      'id': id,
      'body': text,
      'updated_at': now,
    };
    final db = await instance.database;
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  //POSTの削除
  static Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}



class Post {
  const Post({
    @required this.id,
    @required this.body,
    @required this.createdAt,
    @required this.updatedAt,
  })  : assert(id != null),
        assert(body != null),
        assert(createdAt != null),
        assert(updatedAt != null);

  final int id;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get getId => id;
  String get getBody => '$body';
  DateTime get getUpdatedAt => updatedAt;

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": body,
    "created_at": createdAt.toUtc().toIso8601String(),
    "dreated_at": updatedAt.toUtc().toIso8601String(),
  };

  factory Post.fromMap(Map<String, dynamic> json) => Post(
    id: json["id"],
    body: json["body"],
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
  );
}