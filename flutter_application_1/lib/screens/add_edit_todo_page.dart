import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AddEditTodoPage extends StatefulWidget {
  final Map<String, dynamic>? todo;
  final int? index;

  const AddEditTodoPage({Key? key, this.todo, this.index}) : super(key: key);

  @override
  _AddEditTodoPageState createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  Color _selectedColor = Colors.green[400] ?? Colors.green;
  String _category = 'Daily Task';
  
  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _todoController.text = widget.todo!['text'];
      _descriptionController.text = widget.todo!['description'] ?? '';
      _startDate = widget.todo!['date'] ?? DateTime.now();
      _endDate = widget.todo!['endDate'] ?? DateTime.now().add(Duration(days: 1));
      _selectedTime = widget.todo!['time'] ?? TimeOfDay.now();
      _selectedColor = widget.todo!['color'] ?? Colors.green[400] ?? Colors.green;
      _category = widget.todo!['category'] ?? 'Daily Task';
    }
  }

  Future<void> _selectDate(BuildContext context, {bool isEndDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isEndDate ? _endDate : _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isEndDate) {
          _endDate = picked;
        } else {
          _startDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveTodo() {
    if (_todoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title for your task')),
      );
      return;
    }
    
    final todo = {
      'text': _todoController.text,
      'description': _descriptionController.text,
      'date': _startDate,
      'endDate': _endDate,
      'time': _selectedTime,
      'color': _selectedColor,
      'category': _category,
      'completed': _isEditing ? widget.todo!['completed'] : false,
    };

    if (_isEditing) {
      _authService.updateTodo(widget.index!, todo);
    } else {
      _authService.addTodo(todo);
    }
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Add Task'),
        backgroundColor: Colors.green[400],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page header with illustration
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Icon(
                    _isEditing ? Icons.edit_note : Icons.add_task,
                    size: 60,
                    color: Colors.green[400],
                  ),
                  SizedBox(height: 10),
                  Text(
                    _isEditing ? 'Edit Your Task' : 'Create New Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[400],
                    ),
                  ),
                ],
              ),
            ),
            
            _buildSectionTitle('Title'),
            SizedBox(height: 8),
            TextField(
              controller: _todoController,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: Icon(Icons.title, color: Colors.green[400]),
              ),
            ),
            SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Start'),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 18, color: Colors.green[400]),
                              SizedBox(width: 8),
                              Text(_startDate.toLocal().toString().split(' ')[0]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Ends'),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context, isEndDate: true),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 18, color: Colors.green[400]),
                              SizedBox(width: 8),
                              Text(_endDate.toLocal().toString().split(' ')[0]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            _buildSectionTitle('Time'),
            SizedBox(height: 8),
            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.green[400]),
                    SizedBox(width: 8),
                    Text(_selectedTime.format(context)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            _buildSectionTitle('Category'),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildCategoryButton('Priority Task', 'Priority Task'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildCategoryButton('Daily Task', 'Daily Task'),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            _buildSectionTitle('Color'),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _colorOption(Colors.red[400] ?? Colors.red),
                _colorOption(Colors.blue[400] ?? Colors.blue),
                _colorOption(Colors.green[400] ?? Colors.green),
                _colorOption(Colors.orange[400] ?? Colors.orange),
                _colorOption(Colors.purple[400] ?? Colors.purple),
              ],
            ),
            SizedBox(height: 20),
            
            _buildSectionTitle('Description'),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter task description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 30),
            
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _saveTodo,
                child: Text(
                  _isEditing ? 'Update Task' : 'Create Task',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCategoryButton(String title, String categoryValue) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _category == categoryValue ? Colors.green[400] : Colors.grey[200],
        foregroundColor: _category == categoryValue ? Colors.white : Colors.black87,
        elevation: _category == categoryValue ? 2 : 0,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        setState(() {
          _category = categoryValue;
        });
      },
      child: Text(
        title, 
        style: TextStyle(fontWeight: _category == categoryValue ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (_selectedColor == color)
              BoxShadow(
                color: color.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 8,
              ),
          ],
        ),
        child: _selectedColor == color
            ? Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }
}