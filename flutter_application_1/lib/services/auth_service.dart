import 'package:flutter/material.dart';

class User {
  final String name;
  final String username;

  User({required this.name, required this.username});
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal();

  User? _currentUser;
  final Map<String, String> _users = {};
  final Map<String, List<Map<String, dynamic>>> _userTodos = {};

  User? get currentUser => _currentUser;

  bool signUp(String name, String username, String password) {
    if (_users.containsKey(username)) {
      return false; // Username already exists
    }
    _users[username] = password;
    _userTodos[username] = [];
    _currentUser = User(name: name, username: username);
    return true;
  }

  bool login(String username, String password) {
    if (_users.containsKey(username) && _users[username] == password) {
      _currentUser = User(name: username, username: username); // Mock user data
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
  }

  List<Map<String, dynamic>> getTodos() {
    if (_currentUser != null) {
      return _userTodos[_currentUser!.username] ?? [];
    }
    return [];
  }

  void addTodo(Map<String, dynamic> todo) {
    if (_currentUser != null) {
      _userTodos[_currentUser!.username]?.add(todo);
    }
  }

  void deleteTodoItem(int index) {
    if (_currentUser != null) {
      _userTodos[_currentUser!.username]?.removeAt(index);
    }
  }

  void clearAllTodos() {
    if (_currentUser != null) {
      _userTodos[_currentUser!.username]?.clear();
    }
  }
}