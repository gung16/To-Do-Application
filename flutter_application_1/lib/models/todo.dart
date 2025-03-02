// for the todo model
class Todo {
  String id;
  String title;
  DateTime dateTime;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.dateTime,
    this.isDone = false,
  });
}