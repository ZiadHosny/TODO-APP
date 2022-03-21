import 'package:flutter/material.dart';

import '../cubit/tasks_cubit.dart';

class BuildList extends StatelessWidget {
  final List<Map> tasks;
  const BuildList({
    Key? key,
    required this.tasks,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return tasks.length <= 0
        ? Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.view_list, size: 50),
                  Text('No Tasks Added Yet. add some'),
                ]),
          )
        : ListView.builder(
            itemBuilder: ((context, index) => Dismissible(
                  key: Key(tasks[index]['id'].toString()),
                  onDismissed: (_) {
                    TasksCubit.get(context)
                        .deleteFromDataBase(tasks[index]['id']);
                  },
                  child: ListTile(
                    leading: FittedBox(
                      fit: BoxFit.cover,
                      child: CircleAvatar(
                          radius: 30,
                          child: Text(
                            tasks[index]['time'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.blue),
                    ),
                    title: Text(
                      tasks[index]['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tasks[index]['date'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            TasksCubit.get(context).updateDataBase(
                                status: 'done', id: tasks[index]['id']);
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            TasksCubit.get(context).updateDataBase(
                                status: 'archive', id: tasks[index]['id']);
                          },
                          icon: Icon(
                            Icons.archive_rounded,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            itemCount: tasks.length,
          );
  }
}
