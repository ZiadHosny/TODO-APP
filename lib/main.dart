// ignore_for_file: use_key_in_widget_constructors, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/screens/archived_tasks.dart';
import 'package:todo/screens/done_tasks.dart';
import 'package:todo/screens/tasks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  late Database database;
  bool bottomSheetIsShowen = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();

  final List<Widget> screens = [
    TasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  @override
  void initState() {
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'New Tasks',
          ),
        ),
        body: screens[index],
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(fabIcon),
            onPressed: () {
              if (bottomSheetIsShowen) {
                Navigator.pop(context);
                bottomSheetIsShowen = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              } else {
                showBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        controller: titleController,
                        validator: (value) {
                          value!.isEmpty ? 'title must not be empty' : null;
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text('Task Title'),
                          prefix: Icon(Icons.title),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        validator: (value) {
                          value!.isEmpty ? 'time must not be empty' : null;
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text('Task Time'),
                          prefix: Icon(Icons.watch),
                          prefixIconColor: Colors.white,
                        ),
                      ),
                    ]),
                    color: Colors.blue[900],
                    height: 200,
                    width: double.infinity,
                  ),
                );

                bottomSheetIsShowen = true;

                setState(() {
                  fabIcon = Icons.add;
                });
              }
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (v) {
            setState(() {
              index = v;
            });
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              label: 'Tasks',
              icon: Icon(Icons.menu),
            ),
            BottomNavigationBarItem(
              label: 'Done',
              icon: Icon(Icons.check_box_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Archived',
              icon: Icon(Icons.archive_outlined),
            ),
          ],
        ),
      ),
    );
  }

  void createDataBase() async {
    database = await openDatabase(
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
        print('on open');
      },
    );
  }

  void insertDataBase() {
    database
        .transaction((txn) async {
          await txn.rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES("frist task", "33", "ew", "f")');
        })
        .then((value) => print('$value inserted successfuly'))
        .catchError((e) => print('$e error'));
  }
}
