import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/cubit/cubit.dart';

Widget defaultTextFormField(
  context, {
  onChanged,
  suffixIcon,
  suffixPressed,
  isPassword,
  onTap,
  @required controller,
  @required type,
  @required label,
  @required prefix,
  @required validate,
}) =>
    TextFormField(
      textAlign: TextAlign.start,
      onChanged: onChanged,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      validator: validate,
      onTap: onTap,
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 15),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixPressed,
              )
            : null,
        prefixIcon: prefix,
        labelText: "$label",
        floatingLabelStyle: const TextStyle(color: Colors.green),
        isDense: true,
        contentPadding: const EdgeInsets.all(20.0),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 3.0),
          gapPadding: 20.0,
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 3.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      onDismissed: (direction) {
        TodoAppCubit.get(context).deleteDataBase(id: model['id']);
      },
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.green[300],
              child: Text(
                "${model['date']}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("${model['time']}",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[300])),
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            IconButton(
                onPressed: () {
                  TodoAppCubit.get(context)
                      .updateDataBase(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            SizedBox(
              width: 10.0,
            ),
            IconButton(
                onPressed: () {
                  TodoAppCubit.get(context)
                      .updateDataBase(status: 'archived', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );

Widget buildTasks({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      fallback: (context) => Center(child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
        Icon(Icons.menu,size: 30.0,),
        SizedBox(height:10.0),
        Text("Please add some tasks",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
      ],)),
      builder: (context) => ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Divider(
                height: 5,
                thickness: 2.0,
              ),
          itemCount: tasks.length),
    );
