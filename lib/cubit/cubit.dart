import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/module/archived/archived_screen.dart';
import 'package:todo/module/done/done_screen.dart';
import 'package:todo/module/tasks/tasks_screen.dart';

class TodoAppCubit extends Cubit<ToDoAppStates>{
  TodoAppCubit() : super(ToDoInitialState());
  static TodoAppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  void changeBottomNav(int index){
    currentIndex =index;
    emit(ToDoBottomNavBarState());
  }
  late Database db;
  List<Map> tasks =[];
  List<Map> done =[];
  List<Map> archived =[];
  void createDataBase()  {
    openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print("DataBase Created");
      db
          .execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
          .then((value) {
        print("Table Created");
      }).catchError((error) {
        print(error.toString());
      });
    }, onOpen: (db) {
      getData(db);
      print("DataBase opened");
    }).then((value) {
      db=value;
      emit(ToDoCreateDatabaseState());
    });
  }

  Future insertToDataBase({
    @required title,
    @required time,
    @required date,
  }) async{
    return await db.transaction((txn) => txn.rawInsert(
        'INSERT INTO tasks(title, date, time,status) VALUES("$title", "$time", "$date", "new")')
        .then((value) {
      print(value.toString());
      emit(ToDoInsertDatabaseState());
      getData(db);
    }).catchError((error) {
      print(error.toString());
    }));
  }
  void updateDataBase({
  required String status,
  required int id,
})async {
    db.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          emit(ToDoUpdateDatabaseState());
    });
  }
  void deleteDataBase({
    required int id,
  })async {
    db.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(ToDoDeleteDatabaseState());
    });
  }
  void getData(database){
    database.rawQuery('SELECT * FROM tasks').then((value) {
      tasks=[];
    done=[];
    archived=[];
      value.forEach((element){
        if(element['status'] == 'new') {
          tasks.add(element);
        }
        else if(element['status'] == 'done') {
          done.add(element);
        }
        else {
          archived.add(element);
        }
      });
      getData(database);
      emit(ToDoGetDatabaseState());
    });
  }
  bool isBottomShown = false;
  var fabIcon = Icons.add;
void changeBottomSheet({
  required bool isShow,
  required IconData icon,
}){
  isBottomShown=isShow;
  fabIcon = icon;
  emit(ToDoChangeBottomSheetState());
}

}