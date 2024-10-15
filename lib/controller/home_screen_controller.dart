import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class HomeScreenController {
  static late Database myDatabase;
  static List<Map> employeesDataList = [];

  static Future initDb() async {
    var path = '/my/db/path';
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
      path = 'my_web_web.db';
    }

    myDatabase = await openDatabase("EmployeeData.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Employees (id INTEGER PRIMARY KEY, name TEXT, designation TEXT)');
    });
  }

  static Future addEmployee(String name, String designation) async {
    await myDatabase.rawInsert(
        'INSERT INTO Employees(name, designation) VALUES(?, ?)',
        [name, designation]);
    getAllEmployees();
  }

  static Future getAllEmployees() async {
    employeesDataList = await myDatabase.rawQuery('SELECT * FROM Employees');
    print(employeesDataList);
  }

  static Future removeEmployee(id) async {
    await myDatabase.rawDelete('DELETE FROM Employees WHERE id = ?', [id]);
    getAllEmployees();
  }

  updateEmployee(
    String name,
    String designation,
  ) async {
    await myDatabase.rawUpdate(
        'UPDATE Employees SET name = ?, designation = ? WHERE name = ?',
        ['updated name', '9876', 'some name']);
  }
}
