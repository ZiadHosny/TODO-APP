part of 'tasks_cubit.dart';

@immutable
abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksChangeBottomNavBarState extends TasksState {}

class TasksCreateDataBaseStates extends TasksState {}

class TasksGetDataBaseStates extends TasksState {}

class TasksInsertDataBaseStates extends TasksState {}

class TasksChangeBottomSheetState extends TasksState {}

class TaskGetDataProgressIndcator extends TasksState {}
