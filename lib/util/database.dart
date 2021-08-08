import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider{
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if(_database !=null)
        return _database;
      
    _database = await initDB();
    return _database;
  }

  initDB() async {

    Directory documentsDirectory = await  getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){    
        ByteData data = await rootBundle.load(join('assets', 'database.db'));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);       
        await new File(path).writeAsBytes(bytes);
      }

    return await openDatabase(path, version: 1, onOpen: (db) {
    });
  }

  getStates () async{
    
    final db = await database;   

    var res = await db.rawQuery("SELECT * FROM states;");
    return res;
  }

  getDistricts (int stateId) async{
    
    final db = await database;   

    var res = await db.rawQuery("SELECT * FROM districts where state ="+stateId.toString()+";");
    return res;
  }
} 