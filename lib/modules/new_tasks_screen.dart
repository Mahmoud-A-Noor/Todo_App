import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/constans.dart';
import 'package:todo_app/components/task_item.dart';
import 'package:todo_app/shared/data_provider.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    return data.newTasks.length > 0
        ? ListView.separated(
            itemBuilder: (ctx, index) => buildTask(data.newTasks[index], data),
            separatorBuilder: (ctx, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
            itemCount: data.newTasks.length)
        : buildEmptyScreen(messages[0]);
  }
}
