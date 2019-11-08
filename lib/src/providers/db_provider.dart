import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:qareaderapp/src/models/scan_model.dart';
export 'package:qareaderapp/src/models/scan_model.dart';

class DBProvider{

  static Database _dataBase;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if(_dataBase != null) return _dataBase;

    _dataBase = await initDB();
    return _dataBase;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'scansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  addScanRaw( ScanModel scanModel) async {
    final db = await database;
    final res = db.rawInsert(
      "INSERT INTO Scans (id, tipo, valor) "
      "VALUES (${scanModel.id} , '${scanModel.tipo}', '${scanModel.valor}')"
    );

    return res;
  }

  Future<int> addScan( ScanModel scanModel) async {
    final db = await database;
    final res = db.insert('Scans', scanModel.toJson());

    return res;
  }

  Future<List<ScanModel>>  getScan() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty ? res.map((f) => ScanModel.fromJson(f)).toList() : [];
    return list;
  }

  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null; 
  }

  Future<List<ScanModel>> getScanTipo(String tipo) async {
    final db = await database;
    final res = await db.query("Scans", where: "tipo = '?'", whereArgs: [tipo]);
    List<ScanModel> list = res.isNotEmpty ? res.map((f) => ScanModel.fromJson(f)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getScanValor(String valor) async {
    final db = await database;
    final res = await db.query("Scans", where: "valor = '?'", whereArgs: [valor]);
    List<ScanModel> list = res.isNotEmpty ? res.map((f) => ScanModel.fromJson(f)).toList() : [];
    return list;
  }

  Future<int> updateScan(ScanModel scanModel) async {
    final db = await database;
    final res = await db.update("Scans", scanModel.toJson(), where: 'id = ?' , whereArgs: [scanModel.id] );
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete("Scans", where: 'id = ?' , whereArgs: [id] );
    return res;
  }

  Future<int> deleteAllScan() async {
    final db = await database;
    final res = await db.delete("Scans");
    return res;
  }
}