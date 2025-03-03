import 'package:flutter/material.dart';
import 'dart:async';
import 'profile_page.dart';
import 'todo_list_page.dart';

class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  final int workDuration = 25 * 60; // 25 minutes in seconds
  final int shortBreakDuration = 5 * 60; // 5 minutes in seconds
  final int longBreakDuration = 15 * 60; // 15 minutes in seconds
  
  int currentDuration = 25 * 60;
  int remainingTime = 25 * 60;
  Timer? timer;
  bool isRunning = false;
  int pomodoroCount = 0;
  String currentMode = "Work";
  
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    setState(() {
      isRunning = true;
      
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          _handleTimerCompletion();
        }
      });
    });
  }
  
  void _pauseTimer() {
    setState(() {
      isRunning = false;
      timer?.cancel();
    });
  }
  
  void _resetTimer() {
    setState(() {
      isRunning = false;
      timer?.cancel();
      remainingTime = currentDuration;
    });
  }
  
  void _handleTimerCompletion() {
    timer?.cancel();
    
    // Play notification sound or vibrate here
    
    if (currentMode == "Work") {
      pomodoroCount++;
      
      if (pomodoroCount % 4 == 0) {
        // After 4 pomodoros, take a LBreak
        _switchMode("LBreak");
      } else {
        // Otherwise take a SBreak
        _switchMode("SBreak");
      }
    } else {
      // After any break, go back to work
      _switchMode("Work");
    }
  }
  
  void _switchMode(String mode) {
    setState(() {
      currentMode = mode;
      isRunning = false;
      
      if (mode == "Work") {
        currentDuration = workDuration;
      } else if (mode == "SBreak") {
        currentDuration = shortBreakDuration;
      } else {
        currentDuration = longBreakDuration;
      }
      
      remainingTime = currentDuration;
    });
  }
  
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Colors.amber,
              ),
              SizedBox(width: 10),
              Text('Pomodoro Technique'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Work for 25 minutes\n'
                '2. Take a 5-minute break (SBreak) \n'
                '3. After 4 work sessions, take a longer 15-minute break (LBreak)',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Got it'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double progress = remainingTime / currentDuration;
    final mainColor = Colors.purple[400]!;
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            // Header with title and info button
            Container(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: mainColor,
                image: DecorationImage(
                  image: AssetImage('assets/homepage.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.purple[400]!.withOpacity(0.3), // Apply teal overlay
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
                        'Focus Time',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _showInfoDialog,
                            icon: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            radius: 22,
                            child: Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Stay productive with the Pomodoro technique',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            
            // Session statistics
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    'Mode',
                    currentMode,
                    _getColorForMode(),
                    Icons.timer,
                  ),
                  _buildStatCard(
                    'Sessions',
                    '$pomodoroCount',
                    Colors.purple[400]!,
                    Icons.repeat,
                  ),
                  _buildStatCard(
                    'Status',
                    isRunning ? 'Running' : 'Paused',
                    isRunning ? Colors.green[400]! : Colors.orange[400]!,
                    isRunning ? Icons.play_arrow : Icons.pause,
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(_getColorForMode()),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              _formatTime(remainingTime),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getColorForMode().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                currentMode,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getColorForMode(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildControlButton(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          isRunning ? _pauseTimer : _startTimer,
                          mainColor,
                        ),
                        SizedBox(width: 20),
                        _buildControlButton(
                          Icons.refresh,
                          _resetTimer,
                          Colors.blue[400]!,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildModeButton("Work", _getColorForMode("Work")),
                        _buildModeButton("SBreak", _getColorForMode("SBreak")),
                        _buildModeButton("LBreak", _getColorForMode("LBreak")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 1,
          selectedItemColor: mainColor,
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
          if (index == 0) {
            // Instant transition to Todo List Page
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => TodoListPage(),
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
  
  Widget _buildControlButton(IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: CircleBorder(),
        padding: EdgeInsets.all(24),
        elevation: 4,
      ),
      child: Icon(
        icon,
        size: 36,
        color: Colors.white,
      ),
    );
  }
  
  Widget _buildModeButton(String mode, Color color) {
    bool isSelected = currentMode == mode;
    
    return OutlinedButton(
      onPressed: () => _switchMode(mode),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        side: BorderSide(
          color: isSelected ? color : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        mode,
        style: TextStyle(
          color: isSelected ? color : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Color _getColorForMode([String? mode]) {
    String modeToUse = mode ?? currentMode;
    
    switch (modeToUse) {
      case "Work":
        return Colors.red[400] ?? Colors.red;
      case "SBreak":
        return Colors.teal[400] ?? Colors.teal;
      case "LBreak":
        return Colors.purple[400] ?? Colors.purple;
      default:
        return Colors.red[400] ?? Colors.red;
    }
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
              fontSize: 16,
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