import 'package:flutter/material.dart';

class User {
  final String name;
  final String username;
  String profileAvatar;
  String status;
  List<String> hobbies;
  Map<String, String> socialMedia;

  User({
    required this.name, 
    required this.username,
    this.profileAvatar = 'profile1.png',
    this.status = 'Studying',
    List<String>? hobbies,
    Map<String, String>? socialMedia,
  }) : 
    this.hobbies = hobbies ?? [],
    this.socialMedia = socialMedia ?? {
      'instagram': '',
      'twitter': '',
      'linkedin': '',
    };
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal();

  User? _currentUser;
  final Map<String, String> _passwords = {};
  final Map<String, User> _users = {};
  final Map<String, List<Map<String, dynamic>>> _userTodos = {};

  User? get currentUser => _currentUser;
  
  // Profile avatar that is currently in use
  String get profileNow => _currentUser?.profileAvatar ?? 'profile1.png';

  bool signUp(String name, String username, String password) {
    if (_passwords.containsKey(username)) {
      return false; // Username already exists
    }
    
    // Create a new user with default profile settings
    _passwords[username] = password;
    _users[username] = User(
      name: name, 
      username: username,
      profileAvatar: 'profile1.png',
      status: 'Studying',
      hobbies: [], // Start with empty hobbies list as requested
      socialMedia: {
        'instagram': '',
        'twitter': '',
        'linkedin': '',
      }
    );
    
    _userTodos[username] = [];
    _currentUser = _users[username];
    return true;
  }

  bool login(String username, String password) {
    if (_passwords.containsKey(username) && _passwords[username] == password) {
      _currentUser = _users[username];
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
  }
  
  // Profile management methods
  
  void updateProfileAvatar(String avatarFileName) {
    if (_currentUser != null) {
      _currentUser!.profileAvatar = avatarFileName;
      _users[_currentUser!.username]?.profileAvatar = avatarFileName;
    }
  }
  
  void updateStatus(String status) {
    if (_currentUser != null) {
      _currentUser!.status = status;
      _users[_currentUser!.username]?.status = status;
    }
  }
  
  void updateHobbies(List<String> hobbies) {
    if (_currentUser != null) {
      _currentUser!.hobbies = hobbies;
      _users[_currentUser!.username]?.hobbies = hobbies;
    }
  }
  
  void updateSocialMedia(String platform, String handle) {
    if (_currentUser != null) {
      _currentUser!.socialMedia[platform] = handle;
      _users[_currentUser!.username]?.socialMedia[platform] = handle;
    }
  }
  
  // Todo management methods
  
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

  void updateTodo(int index, Map<String, dynamic> todo) {
    if (_currentUser != null && 
        _userTodos[_currentUser!.username] != null &&
        index >= 0 && 
        index < _userTodos[_currentUser!.username]!.length) {
      _userTodos[_currentUser!.username]![index] = todo;
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
  
  // Method to save all profile changes at once
  void saveProfileChanges({
    String? avatarFileName,
    String? status,
    List<String>? hobbies,
    Map<String, String>? socialMedia,
  }) {
    if (_currentUser != null) {
      if (avatarFileName != null) {
        _currentUser!.profileAvatar = avatarFileName;
      }
      
      if (status != null) {
        _currentUser!.status = status;
      }
      
      if (hobbies != null) {
        _currentUser!.hobbies = hobbies;
      }
      
      if (socialMedia != null) {
        _currentUser!.socialMedia = {..._currentUser!.socialMedia, ...socialMedia};
      }
      
      // Update the stored user object
      _users[_currentUser!.username] = _currentUser!;
    }
  }
}