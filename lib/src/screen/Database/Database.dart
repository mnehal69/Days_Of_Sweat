import 'dart:io';
import 'dart:async';

import 'package:days_of_sweat/src/screen/Database/PlayList.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;
  final tableName = "PlayList";

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "PlayListDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      print("\n-----DATABASE CREATED ---\n");

      await db.execute("CREATE TABLE $tableName ("
          "id INTEGER PRIMARY KEY,"
          "songID INTEGER,"
          "type TEXT"
          ")");
    });
  }

  void printTable() async {
    final db = await database;
    var table = await db.rawQuery("SELECT * from $tableName");
    print("\n|-------------PLAYLIST TABLE-----------|\n");
    print("|    id    |     songID    |   type    |\n");
    List<PlayListModel> list = table.isNotEmpty
        ? table.map((c) => PlayListModel.fromMap(c)).toList()
        : [];

    for (int i = 0; i < list.length; i++) {
      print(
          "\n|    ${list[i].id}    |     ${list[i].songID}    |   ${list[i].type}    |\n");
    }
  }
  
  addNewPlaylistIndex(PlayListModel newPlaylist) async {
    final db = await database;
    var res;

    res = await db.insert(tableName, newPlaylist.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<bool> existsPlaylistIndex(int id, String type) async {
    final db = await database;
    var table = await db.query("$tableName",
        where: "SongID = ? AND type = ?", whereArgs: [id, type]);
    return table.length > 0;
  }

  deletePlaylistIndex(int id, String type) async {
    final db = await database;
    return db.delete("$tableName",
        where: "songID = ? AND type = ?", whereArgs: [id, type]);
  }

  getNewID() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    return table.first["id"];
  }

  String typefromMap(Map<String, dynamic> json) => json["type"];

  getType() async {
    final db = await database;
    var table = await db.rawQuery("SELECT DISTINCT type FROM $tableName");
    List<String> list =
        table.isNotEmpty ? table.map((c) => typefromMap(c)).toList() : [];
    return list;
  }

  getPlayList(String type) async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT * FROM $tableName WHERE type = '$type'");

    List<PlayListModel> list =
        res.isNotEmpty ? res.map((c) => PlayListModel.fromMap(c)).toList() : [];
    return list;
  }

  deletePlaylist(String type) async {
    final db = await database;
    return db.delete("$tableName", where: "type = ?", whereArgs: [type]);
  }

  deleteAll() async {
    final db = await database;
    return db.rawDelete("Delete * from $tableName");
  }
}
