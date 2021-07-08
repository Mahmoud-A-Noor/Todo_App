import 'package:flutter/material.dart';
import 'package:todo_app/shared/data_provider.dart';

Widget buildTask(Map model, DataProvider data) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text("${model['time']}"),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${model['date']}",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                data.update(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                data.update(status: 'archived', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.grey,
              ))
        ],
      ),
    ),
    onDismissed: (direction) {
      data.delete(id: model['id']);
    },
  );
}

Widget buildEmptyScreen(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          softWrap: true,
        )
      ],
    ),
  );
}
