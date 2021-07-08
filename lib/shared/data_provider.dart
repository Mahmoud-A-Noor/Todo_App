import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DataProvider with ChangeNotifier {
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  late Database DB;

  DataProvider() {
    createDB();
  }

  Future insertIntoDB({required title, required time, required date}) async {
    return await DB.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value insert successfully');
        notifyListeners();
      }).catchError((error) {});
    });
  }

  getDataFromDB(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery('select * from tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      notifyListeners();
    });
  }

  createDB() async {
    DB = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
      await database
          .execute(
              'create table tasks (id integer primary key,title text,date text,time text,status text)')
          .then((value) => print('database created'));
      print('DB Created');
    }, onOpen: (database) async {
      print('DB Opened');
      getDataFromDB(database);
    });
    notifyListeners();
  }

  Future<int?> update({required String status, required int id}) async {
    await DB.rawUpdate('update tasks set status = ? where id = ?',
        ['$status', id]).then((value) {
      getDataFromDB(DB);
      notifyListeners();
      return value;
    });
  }

  Future<int?> delete({required int id}) async {
    await DB.rawUpdate('delete from tasks where id=?', [id]).then((value) {
      getDataFromDB(DB);
      notifyListeners();
      return value;
    });
  }
}
