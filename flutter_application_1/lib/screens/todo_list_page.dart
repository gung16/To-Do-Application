import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_page.dart';
import 'add_edit_todo_page.dart';
import 'pomodoro_page.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final AuthService _authService = AuthService();
  
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear All Todos'),
          content: Text('Are you sure you want to clear all todos?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _authService.clearAllTodos();
                });
                Navigator.of(context).pop();
              },
              child: Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddEditPage({Map<String, dynamic>? todo, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTodoPage(
          todo: todo,
          index: index,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final todos = _authService.getTodos();
    final User? currentUser = _authService.currentUser;
    final String greeting = currentUser != null ? 'Welcome, ${currentUser.name}' : 'Hi there';

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // Green banner with image and greeting
            Container(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: BoxDecoration(
                color: Colors.green[700],
                image: DecorationImage(
                  image: AssetImage('assets/homepage.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.greenAccent.withOpacity(0.3), // Green overlay
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300], // Default background
                        radius: 22,
                        backgroundImage: AssetImage(_authService.profileNow),
                        child: _authService.profileNow.isEmpty
                            ? Icon(Icons.person, color: Colors.white) // Fallback avatar icon
                            : null,
                      ),
                    ),
                    ],
                  ),
                  SizedBox(height: 80), // Space for the banner content
                ],
              ),
            ),

            // Statistics Cards
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    'Tasks',
                    '${todos.where((t) => !t['completed']).length}',
                    Colors.red[400]!,
                    Icons.assignment,
                  ),
                  _buildStatCard(
                    'Completed',
                    '${todos.where((t) => t['completed']).length}',
                    Colors.blue[400]!,
                    Icons.check_circle,
                  ),
                  _buildStatCard(
                    'Total',
                    '${todos.length}',
                    Colors.purple[400]!,
                    Icons.list,
                  ),
                ],
              ),
            ),

            // Section title
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (todos.isNotEmpty)
                    TextButton(
                      onPressed: _clearAllTodos,
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Task List
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 70,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No tasks yet. Add one below!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Color indicator and checkbox
                                Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: CircleAvatar(
                                    backgroundColor: todo['color'],
                                    radius: 24,
                                    child: IconButton(
                                      icon: Icon(
                                        todo['completed']
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      onPressed: () => _toggleTodoCompletion(index),
                                    ),
                                  ),
                                ),
                                // Task details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        todo['text'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          decoration: todo['completed']
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: todo['completed']
                                              ? Colors.grey
                                              : Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '${todo['date'].toLocal().toString().split(' ')[0]}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            '${todo['time'].format(context)}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Action buttons
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue[400]),
                                      onPressed: () =>
                                          _navigateToAddEditPage(todo: todo, index: index),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red[400]),
                                      onPressed: () => _deleteTodoItem(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[400],
          child: Icon(Icons.add),
          onPressed: () => _navigateToAddEditPage(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          selectedItemColor: Colors.green[400],
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'ToDo List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Pomodoro',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
          if (index == 1) {
            // Instant transition to Pomodoro Page
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PomodoroPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) {
            // Instant transition to Profile Page
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            radius: 22,
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}