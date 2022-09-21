import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/component/component.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';

class TasksScreen extends StatelessWidget {
   TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit,ToDoAppStates>(
      listener:(context,states){},
      builder:(context,states){
        var tasks=TodoAppCubit.get(context).tasks;
        return buildTasks(tasks: tasks);
      },

    );
  }
}
