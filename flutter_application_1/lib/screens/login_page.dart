import 'package:flutter/material.dart';
import 'todo_list_page.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';
import 'landing_page.dart'; // Add this import

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Top green header part matching the image
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25, // Approximately 25% of screen height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/homepage.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.green.withOpacity(0.7),
                      BlendMode.srcOver,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(left: 24, bottom: 24, right: 24),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Main content scrollable area
              Expanded(
                child: Container(
                  color: Color(0xFFF9F9F9), // Light background like in your image
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[                      
                          // Login fields section
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Login to continue",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _obscurePassword,
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // Forgot password functionality
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xFF50C2C9),
                                    ),
                                    child: Text('Forgot Password?'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 30),
                          
                          // Organize, Track, Achieve section
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.calendar_today, color: Colors.red),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "Organize",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.check_circle, color: Colors.blue),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "Track",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.bar_chart, color: Colors.purple),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "Achieve",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 30),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    
                                    bool success = _authService.login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                                    
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    
                                    if (success) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => TodoListPage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Invalid username or password')),
                                      );
                                    }
                                  },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF8AC185), // Same green as the add button
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Sign up option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Color(0xFF50C2C9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}