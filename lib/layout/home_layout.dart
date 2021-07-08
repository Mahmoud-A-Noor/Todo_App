import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/constans.dart';
import 'package:todo_app/components/task_item.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/data_provider.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  bool buttonSheetShown = false;
  IconData fabIcon = Icons.edit;

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //context.read<DataProvider>().createDB();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (buttonSheetShown) {
            if (formKey.currentState!.validate()) {
              data
                  .insertIntoDB(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text)
                  .then((value) {
                Navigator.pop(context);
                data.getDataFromDB(data.DB);
                setState(() {
                  buttonSheetShown = false;
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            setState(() {
              buttonSheetShown = true;
              fabIcon = Icons.add;
            });
            scaffoldKey.currentState!
                .showBottomSheet(
                    (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  onTap: () => null,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return "title shouldn't be null";
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: Icon(Icons.title),
                                    hintText: 'Task Title',
                                    labelText: 'Task Title',
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return "time shouldn't be null";
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: Icon(Icons.watch_later),
                                    hintText: 'Task Time',
                                    labelText: 'Task Time',
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-05-03'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return "date shouldn't be null";
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: Icon(Icons.calendar_today),
                                    hintText: 'Task Date',
                                    labelText: 'Task Date',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20)
                .closed
                .then((value) {
              setState(() {
                buttonSheetShown = false;
                fabIcon = Icons.edit;
              });
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: "Done"),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: "Archived"),
        ],
      ),
      body: data.newTasks.length == 0
          ? screens[currentIndex]
          : buildEmptyScreen(messages[0]),
    );
  }
}
