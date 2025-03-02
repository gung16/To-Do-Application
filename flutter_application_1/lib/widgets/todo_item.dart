import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onToggle;
  final Function(Todo) onDelete;

  const TodoItem({super.key, 
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (bool? value) {
          onToggle(todo);
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        '${'${todo.dateTime.toLocal()}'.split(' ')[0]} ${todo.dateTime.hour}:${todo.dateTime.minute}',
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          onDelete(todo);
        },
      ),
    );
  }
}