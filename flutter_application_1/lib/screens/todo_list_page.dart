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
  Color _selectedColor = Colors.blue;

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
      _authService.addTodo({
        'text': _todoController.text,
        'date': _selectedDate,
        'time': _selectedTime,
        'color': _selectedColor,
        'completed': false,
      });
      _todoController.clear();
    });
  }

  void _toggleTodoCompletion(int index) {
    setState(() {
      final todo = _authService.getTodos()[index];
      todo['completed'] = !todo['completed'];
    });
  }

  void _deleteTodoItem(int index) {
    setState(() {
      _authService.deleteTodoItem(index);
    });
  }

  void _clearAllTodos() {
    setState(() {
      _authService.clearAllTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todos = _authService.getTodos();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
          automaticallyImplyLeading: false, // Remove the back arrow
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  DropdownButton<Color>(
                    value: _selectedColor,
                    onChanged: (Color? newValue) {
                      setState(() {
                        _selectedColor = newValue!;
                      });
                    },
                    items: <Color>[Colors.blue, Colors.red, Colors.green, Colors.yellow]
                        .map<DropdownMenuItem<Color>>((Color value) {
                      return DropdownMenuItem<Color>(
                        value: value,
                        child: Container(
                          width: 24,
                          height: 24,
                          color: value,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Text(
                'Date: ${_selectedDate.toLocal().toString().split(' ')[0]} Time: ${_selectedTime.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: _addTodo,
                child: Text('Add Todo'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      tileColor: todo['color'],
                      title: Text(
                        todo['text'],
                        style: TextStyle(
                          decoration: todo['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        'Date: ${todo['date'].toLocal().toString().split(' ')[0]} Time: ${todo['time'].format(context)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => _toggleTodoCompletion(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTodoItem(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _clearAllTodos,
                child: Text('Clear All'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}