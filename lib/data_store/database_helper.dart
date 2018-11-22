import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';
import 'dart:io' as io;

class DatabaseHelper{
  static final DatabaseHelper _singleton = new DatabaseHelper._internal();
  DatabaseHelper._internal();

  factory DatabaseHelper.getInstance() => _singleton;

  factory DatabaseHelper() => _singleton;


  static Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDB();

      return _db;
    }

  }

  initDB() {

  }


}