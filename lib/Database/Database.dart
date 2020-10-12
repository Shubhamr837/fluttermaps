import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/RouteModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Route ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "description TEXT,"
              "source_lat FLOAT,"
              "source_long FLOAT,"
              "dest_lat FLOAT,"
              "dest_long FLOAT"
              ")");
        });
  }

  newRoute(RouteModel newRoute) async {
    final db = await database;

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Route");
    int id = table.first["id"];

    var raw = await db.rawInsert(
        "INSERT Into Route ("
            "id,"
            "title,"
            "description,"
            "source_lat ,"
            "source_long ,"
            "dest_lat,"
            "dest_long"
            ")"
            " VALUES (?,?,?,?,?,?,?)",
        [id, newRoute.title, newRoute.description, newRoute.source_lat,newRoute.source_long,newRoute.dest_lat,newRoute.dest_long]);
    return raw;
  }




  getRoute(int id) async {
    final db = await database;
    var res = await db.query("Route", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? RouteModel.fromMap(res.first) : null;
  }



  Future<List<RouteModel>> getAllRoutes() async {
    final db = await database;
    var res = await db.query("Route");
    List<RouteModel> list =
    res.isNotEmpty ? res.map((c) => RouteModel.fromMap(c)).toList() : [];
    return list;
  }

  deleteRoute(int id) async {
    final db = await database;
    return db.delete("Route", where: "id = ?", whereArgs: [id]);
  }


}