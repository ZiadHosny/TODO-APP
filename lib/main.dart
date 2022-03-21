// ignore_for_file: use_key_in_widget_constructors, avoid_print, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubit/tasks_cubit.dart';
import 'package:todo/cubit/tasks_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TasksCubit()..createDataBase(),
        child: BlocConsumer<TasksCubit, TasksState>(listener: (context, state) {
          if (state is TasksInsertDataBaseStates) {
            Navigator.pop(context);
          }
        }, builder: (context, state) {
          TasksCubit cubit = TasksCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.title[cubit.index]),
            ),
            body: cubit.screens[cubit.index],
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                child: Icon(cubit.fabIcon),
                onPressed: () {
                  if (cubit.bottomSheetIsShowen) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                    }
                  } else {
                    showBottomSheet(
                      elevation: 20,
                      context: context,
                      builder: (context) => Container(
                        height: 300,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                autofocus: true,
                                controller: titleController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Task Title'),
                                  prefix: Icon(Icons.title),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                onTap: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                  });
                                },
                                keyboardType: TextInputType.datetime,
                                controller: timeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    label: Text('Task Time'),
                                    contentPadding: EdgeInsets.all(10),
                                    prefix: Icon(Icons.watch_later_rounded),
                                    prefixIconColor: Colors.white,
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2023-06-05'))
                                      .then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                keyboardType: TextInputType.datetime,
                                controller: dateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    label: Text('Task Date'),
                                    prefix: Icon(Icons.calendar_today),
                                    prefixIconColor: Colors.white,
                                    border: OutlineInputBorder()),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ).closed.then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (v) {
                cubit.changeIndex(v);
              },
              currentIndex: cubit.index,
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
          );
        }),
      ),
    );
  }
}
