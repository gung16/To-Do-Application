// Untuk mengelola data todo
import '../models/todo.dart';

class TodoService {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String title, DateTime dateTime) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      dateTime: dateTime,
    );
    _todos.add(todo);
  }

  void toggleTodoStatus(Todo todo) {
    final index = _todos.indexOf(todo);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
    }
  }

  void deleteTodo(Todo todo) {
    _todos.remove(todo);
  }
}