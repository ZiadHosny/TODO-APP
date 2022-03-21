// ignore_for_file: avoid_print

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
  List<Map> tasks = [];
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
        getDataFromDataBase(database).then((value) {
          tasks = value;
          print('on opened');
          print(tasks);
          emit(TasksGetDataBaseStates());
        });
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
      print('${value.toString()} inserted successfuly');
      emit(TasksInsertDataBaseStates());
      getDataFromDataBase(database).then((value) {
        tasks = value;
        print(tasks);
        emit(TasksGetDataBaseStates());
      });
    }).catchError((e) {
      print('$e error');
    });
  }

  Future<List<Map>> getDataFromDataBase(Database database) async {
    emit(TaskGetDataProgressIndcator());
    List<Map> tasks = await database.rawQuery('SELECT * FROM tasks');
    return tasks;
  }

  Future<int> UpdateDataBase({required String status, required int id}) async {
    return await database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
      status,
      id,
    ]);
  }
}
