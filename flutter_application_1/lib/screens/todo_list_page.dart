import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_page.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _todoController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addTodo() {
    if (_todoController.text.isEmpty) return;
    setState(() {
      _authService.addTodo(_todoController.text);
      _todoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todos = _authService.getTodos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoController,
              decoration: InputDecoration(labelText: 'Enter todo'),
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Select time'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _addTodo,
              child: Text('Add Todo'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todos[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}