// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/tasks_cubit.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = TasksCubit.get(context).tasks;
        return ListView.builder(
          itemBuilder: ((context, index) => ListTile(
                leading: CircleAvatar(
                    child: Text(
                      tasks[index]['time'],
                    ),
                    backgroundColor: Colors.blue),
                title: Text(
                  tasks[index]['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  tasks[index]['date'],
                  style: const TextStyle(color: Colors.grey),
                ),
              )),
          itemCount: tasks.length,
        );
      },
    );
  }
}
