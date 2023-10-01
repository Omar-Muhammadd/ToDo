import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../../modules/archived_tasks/archived.dart';
import '../../modules/done_tasks/doneTasks.dart';
import '../../modules/new_tasks/newTasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int CurrentIndex = 0;

  List<Widget> Tasks = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> Appbar = [
    'Tasks',
    'Done',
    'Archived',
  ];

  void changeIndex(int index) {
    CurrentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  bool sheetIsOpen = false;

  void changeSheetIsOpen({
    required bool isOpen,
  }) {
    sheetIsOpen = isOpen;
    emit(AppChangeSheetIsOpenState());
  }

  var database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (Database db, int version) {
      print('DataBase Created');
      db.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
          .then((value) {
        print('Table Created');
      }).catchError((error) {
        print('Error When Creating Table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppChangeCreateDatabaseState());
    });
  }

  void insertDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "New")')
          .then((value) {
        getDataFromDatabase(database);
        emit(AppChangeInsertDatabaseState());
        print('$value inserted successfully');
      }).catchError((error) {
        print('Error When Creating Table ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });

      emit(AppGetDatabaseState());
    }).catchError((error) {
      print('error when getDatabase is ${error.toString()}');
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ', [
      '$status',
      id,
    ]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    }).catchError((error) {
      print('Error when updateDatabase is ${error.toString()}');
    });
  }

  void deleteDatabase({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    }).catchError((error) {
      print('Error when DeleteDatabase is ${error.toString()}');
    });
  }
}