// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/tasks_cubit.dart';
import 'package:todo/widgets/build_list.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {},
        builder: (context, state) {
          
          return BuildList(tasks: TasksCubit.get(context).newTasks);
        });
  }
}
