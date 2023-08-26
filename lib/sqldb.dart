import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  // the database object
  static Database? _db;

  // the getter of the database
  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  _initialDb() async {
    // first we have to find a path to store the database
    // and the method getDatabasesPath() can help us to do that
    String databasesPath = await getDatabasesPath();
    // after we got the path we add the name of the database to it with the method join
    String path = join(databasesPath, 'text.db');
    // and finally we declare the database
    Database myDb = await openDatabase(path,
        onCreate: _onCreate, version: 2, onUpgrade: _onUpgrade);
    return myDb;
  }

  // this method function one time, when tha database first created
  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes"(
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "note" TEXT NOT NULL
      )
    ''');
    print('onCreate=============================================');
  }

  // this method function when we update the application
  _onUpgrade(Database db, int oldversion, int newversion) async {
    print('onUpgrade=============================================');
  }

  // read the data
  Future<List<Map>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, Object?>> response = await mydb!.rawQuery(sql);
    return response;
  }

  // insert the data
  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  // update the data
  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  // delete the data
  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  dropDatabase() async {
    String databasesPath = await getDatabasesPath();
    // after we got the path we add the name of the database to it with the method join
    String path = join(databasesPath, 'text.db');
    await deleteDatabase(path);
    print('onDrop=============================================');
  }
}
