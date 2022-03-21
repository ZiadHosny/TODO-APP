// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../screens/archived_tasks.dart';
import '../screens/done_tasks.dart';
import '../screens/tasks.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  static TasksCubit get(context) => BlocProvider.of(context);

  int index = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;
  bool bottomSheetIsShowen = false;
  IconData fabIcon = Icons.edit;

  final List<Widget> screens = [
    TasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  final List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    this.index = index;

    emit(TasksChangeBottomNavBarState());
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    bottomSheetIsShowen = isShow;
    fabIcon = icon;

    emit(TasksChangeBottomSheetState());
  }

  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('on create');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then(
          (value) {
            print('table created');
          },
        ).catchError(
          (e) {
            print('$e error when table created');
          },
        );
      },
      onOpen: (database) {
        getDataFromDataBase(database);
      },
    ).then((value) {
      database = value;
      emit(TasksCreateDataBaseStates());
    });
  }

  void insertDataBase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "New")');
    }).then((value) {
      print('inserted successfuly');
      emit(TasksInsertDataBaseStates());
      getDataFromDataBase(database);
    }).catchError((e) {
      print('$e error');
    });
  }

  void getDataFromDataBase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(TaskGetDataProgressIndcator());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach(
        (element) {
          if (element['status'] == 'New') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else if (element['status'] == 'archive') {
            archivedTasks.add(element);
          }
        },
      );
      print(value);
      emit(TasksGetDataBaseStates());
    });
  }

  void updateDataBase({required String status, required int id}) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
      status,
      id,
    ]).then((value) {
      getDataFromDataBase(database);
      emit(TasksUpdateDataBase());
    });
  }

  void deleteFromDataBase(int id) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  }
}
