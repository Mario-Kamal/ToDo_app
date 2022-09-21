
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/component/component.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>TodoAppCubit()..createDataBase(),
      child: BlocConsumer<TodoAppCubit,ToDoAppStates>(
        listener: (context,states){
          if(states is ToDoInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context,states){
          var cubit = TodoAppCubit.get(context);
          return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.green,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: "Done",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: "Archived",),
            ],
            onTap: (int index) {
              cubit.changeBottomNav(index);
            },
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              if (cubit.isBottomShown) {
                if(formKey.currentState!.validate()){
                  cubit.insertToDataBase(title: titleController.text, time: timeController.text, date: dateController.text);
                  // insertToDataBase(
                  //   title: titleController.text,
                  //   time: timeController.text,
                  //   date: dateController.text,
                  // ).then((value) {
                  //   getData(db).then((value) {
                  //     Navigator.pop(context);
                  //       isBottomShown = false;
                  //       fabIcon = Icons.edit;
                  //       tasks = value;
                  //       print(tasks);
                  //   });
                  //
                  //
                  // });
                }
              } else {
                scaffoldKey.currentState!.showBottomSheet((context) => Container(
                  color: Colors.green[100],
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultTextFormField(context,
                            controller: titleController,
                            isPassword: false,
                            type: TextInputType.text,
                            label: "Task Title",
                            prefix: Icon(Icons.title), validate: (value) {
                              if (value.isEmpty) {
                                return "Please enter your task title";
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(height:20.0),
                        defaultTextFormField(context,
                            controller: timeController,
                            isPassword: false,
                            onTap: (){
                              showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                                timeController.text = value!.format(context).toString();
                              });
                            },
                            type: TextInputType.datetime,
                            label: "Task Time",
                            prefix: Icon(Icons.watch_later_outlined), validate: (value) {
                              if (value.isEmpty) {
                                return "Please enter your task time";
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(height: 20.0,),
                        defaultTextFormField(context,
                            controller: dateController,
                            isPassword: false,
                            onTap: (){
                              showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime.now(), lastDate: DateTime.parse("2023-09-26")).then((value) {
                                dateController.text = DateFormat.yMMMd().format(value as DateTime);
                              });
                            },
                            type: TextInputType.datetime,
                            label: "Task Date",
                            prefix: Icon(Icons.date_range), validate: (value) {
                              if (value.isEmpty) {
                                return "Please enter your task date";
                              } else {
                                return null;
                              }
                            })
                      ],
                    ),
                  ),
                )).closed.then((value) {
                 cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                });
                cubit.changeBottomSheet(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
        );},
      ),
    );
  }
}

// class _MyHomePageState extends State<MyHomePage> {
//   int currentIndex = 0;
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//   GlobalKey<FormState> formKey = GlobalKey();
//   var titleController = TextEditingController();
//   var timeController = TextEditingController();
//   var dateController = TextEditingController();
//   List screens = [
//     TasksScreen(),
//     DoneScreen(),
//     ArchivedScreen(),
//   ];
//   late Database db;
//   bool isBottomShown = false;
//   var fabIcon = Icons.add;
//
//   @override
//   void initState() {
//     super.initState();
//     createDataBase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.green,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.menu),
//             label: "Tasks",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.done),
//             label: "Done",
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.archive_outlined), label: "Archived"),
//         ],
//         onTap: (int index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentIndex,
//       ),
//       body: screens[currentIndex],
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.green,
//         onPressed: () {
//           if (isBottomShown) {
//             if(formKey.currentState!.validate()){
//               insertToDataBase(
//                 title: titleController.text,
//                 time: timeController.text,
//                 date: dateController.text,
//               ).then((value) {
//                 getData(db).then((value) {
//                   Navigator.pop(context);
//                   setState(() {
//                     isBottomShown = false;
//                     fabIcon = Icons.edit;
//                     tasks = value;
//                     print(tasks);
//                   });
//                 });
//
//
//               });
//             }
//           } else {
//             scaffoldKey.currentState!.showBottomSheet((context) => Container(
//                   color: Colors.green[100],
//                   padding: EdgeInsets.all(20.0),
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         defaultTextFormField(context,
//                             controller: titleController,
//                             isPassword: false,
//                             type: TextInputType.text,
//                             label: "Task Title",
//                             prefix: Icon(Icons.title), validate: (value) {
//                           if (value.isEmpty) {
//                             return "Please enter your task title";
//                           } else {
//                             return null;
//                           }
//                         }),
//                         SizedBox(height:20.0),
//                         defaultTextFormField(context,
//                             controller: timeController,
//                             isPassword: false,
//                             onTap: (){
//                           showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
//                             timeController.text = value!.format(context).toString();
//                           });
//                             },
//                             type: TextInputType.datetime,
//                             label: "Task Time",
//                             prefix: Icon(Icons.watch_later_outlined), validate: (value) {
//                               if (value.isEmpty) {
//                                 return "Please enter your task time";
//                               } else {
//                                 return null;
//                               }
//                             }),
//                         SizedBox(height: 20.0,),
//                         defaultTextFormField(context,
//                             controller: dateController,
//                             isPassword: false,
//                             onTap: (){
//                               showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime.now(), lastDate: DateTime.parse("2023-09-26")).then((value) {
//                                 dateController.text = DateFormat.yMMMd().format(value as DateTime);
//                               });
//                             },
//                             type: TextInputType.datetime,
//                             label: "Task Date",
//                             prefix: Icon(Icons.date_range), validate: (value) {
//                               if (value.isEmpty) {
//                                 return "Please enter your task date";
//                               } else {
//                                 return null;
//                               }
//                             })
//                       ],
//                     ),
//                   ),
//                 )).closed.then((value) {
//               isBottomShown = false;
//               setState(() {
//                 fabIcon = Icons.edit;
//               });
//             });
//             isBottomShown = true;
//             setState(() {
//               fabIcon = Icons.add;
//             });
//           }
//         },
//         child: Icon(fabIcon),
//       ),
//     );
//   }
//
//   void createDataBase() async {
//     db = await openDatabase('todo.db', version: 1, onCreate: (db, version) {
//       print("DataBase Created");
//       db
//           .execute(
//               "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
//           .then((value) {
//         print("Table Created");
//       }).catchError((error) {
//         print(error.toString());
//       });
//     }, onOpen: (db) {
//       getData(db).then((value) {
//         setState(() {
//           tasks = value;
//           print(tasks);
//         });
//       });
//       print("DataBase opened");
//     });
//   }
//
//   Future insertToDataBase({
//   @required title,
//   @required time,
//   @required date,
// }) async{
//     return await db.transaction((txn) => txn.rawInsert(
//                 'INSERT INTO tasks(title, date, time,status) VALUES("$title", "$time", "$date", "new")')
//             .then((value) {
//           print(value.toString());
//         }).catchError((error) {
//           print(error.toString());
//         }));
//   }
//   Future<List<Map>> getData(database)async{
//     return await database.rawQuery('SELECT * FROM tasks');
//   }
// }
