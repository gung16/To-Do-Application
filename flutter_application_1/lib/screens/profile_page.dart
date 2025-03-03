import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'landing_page.dart';
import 'todo_list_page.dart';
import 'pomodoro_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final List<String> _options = ['Studying', 'Working', 'Other'];
  String _selectedOption = 'Studying';
  
  final List<String> _hobbies = ['Reading', 'Gaming', 'Cooking', 'Sports', 'Music', 'Art', 'Travel'];
  List<String> _selectedHobbies = [];
  String _selectedAvatar = 'profile1.png';
  Map<String, String> _socialMedia = {
    'instagram': '',
    'twitter': '',
    'linkedin': '',
  };

  @override
  void initState() {
    super.initState();
    // Initialize from current user data
    if (_authService.currentUser != null) {
      _selectedOption = _authService.currentUser!.status;
      _selectedHobbies = List.from(_authService.currentUser!.hobbies);
      _selectedAvatar = _authService.currentUser!.profileAvatar;
      _socialMedia = Map.from(_authService.currentUser!.socialMedia);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Banner with illustration (similar to TodoListPage and PomodoroPage)
              Container(
                padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  image: DecorationImage(
                    image: AssetImage('assets/homepage.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.blueAccent.withOpacity(0.3),
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
                          'Your Profile',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          radius: 22,
                          backgroundImage: AssetImage('assets/$_selectedAvatar'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Customize your experience',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 20),
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
                      'Status',
                      _selectedOption,
                      Colors.teal[400]!,
                      Icons.work,
                    ),
                    _buildStatCard(
                      'Hobbies',
                      '${_selectedHobbies.length}',
                      Colors.purple[400]!,
                      Icons.favorite,
                    ),
                    _buildStatCard(
                      'Activity',
                      'Active',
                      Colors.green[400]!,
                      Icons.check_circle,
                    ),
                  ],
                ),
              ),
              
              // Avatar selection
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // User info with large avatar
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage('assets/$_selectedAvatar'),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'User Name',
                                style: TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                '@${user?.username ?? 'username'}',
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Colors.grey[600]
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _selectedOption,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Avatar selection
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.face, color: Colors.blue),
                                SizedBox(width: 10),
                                Text(
                                  'Choose your avatar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 80,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildAvatarOption('profile1.png'),
                                  _buildAvatarOption('profile2.png'),
                                  _buildAvatarOption('profile3.png'),
                                  _buildAvatarOption('profile4.png'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Current status
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.trending_up, color: Colors.green),
                                SizedBox(width: 10),
                                Text(
                                  'Current Status',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedOption,
                                isExpanded: true,
                                underline: SizedBox(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedOption = newValue!;
                                  });
                                },
                                items: _options.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Hobbies
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  'Your Interests',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _hobbies.map((hobby) {
                                final isSelected = _selectedHobbies.contains(hobby);
                                return FilterChip(
                                  label: Text(hobby),
                                  selected: isSelected,
                                  selectedColor: Colors.blue.withOpacity(0.2),
                                  checkmarkColor: Colors.blue,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedHobbies.add(hobby);
                                      } else {
                                        _selectedHobbies.remove(hobby);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Social Media
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.share, color: Colors.purple),
                                SizedBox(width: 10),
                                Text(
                                  'Social Media',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            _buildSocialMediaButton('Instagram', Icons.camera_alt, Colors.pink),
                            SizedBox(height: 10),
                            _buildSocialMediaButton('Twitter', Icons.chat, Colors.blue),
                            SizedBox(height: 10),
                            _buildSocialMediaButton('LinkedIn', Icons.business, Colors.blue[900]!),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Save and Logout buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Save profile changes using the new AuthService methods
                            _authService.saveProfileChanges(
                              avatarFileName: _selectedAvatar,
                              status: _selectedOption,
                              hobbies: _selectedHobbies,
                              socialMedia: _socialMedia,
                            );
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Profile updated successfully!'))
                            );
                          },
                          icon: Icon(Icons.save),
                          label: Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _authService.logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LandingPage()),
                              (route) => false,
                            );
                          },
                          icon: Icon(Icons.logout),
                          label: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 2,
          selectedItemColor: Colors.red[400],
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
            // Instant transition to TodoListPage
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => TodoListPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 1) {
            // Instant transition to PomodoroPage
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PomodoroPage(),
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
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            radius: 22,
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          SizedBox(height: 4),
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
  
  Widget _buildAvatarOption(String assetName) {
    bool isSelected = _selectedAvatar == assetName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar = assetName;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/$assetName'),
        ),
      ),
    );
  }
  
  Widget _buildSocialMediaButton(String platform, IconData icon, Color color) {
    return OutlinedButton.icon(
      onPressed: () {
        // Show dialog to add social media handle
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String handle = _socialMedia[platform.toLowerCase()] ?? '';
            return AlertDialog(
              title: Text('Add $platform'),
              content: TextField(
                onChanged: (value) {
                  handle = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your $platform username',
                  prefixIcon: Icon(icon, color: color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: TextEditingController(text: handle),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _socialMedia[platform.toLowerCase()] = handle;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(icon, color: color),
      label: Text(
        _socialMedia[platform.toLowerCase()]?.isNotEmpty == true 
            ? '@${_socialMedia[platform.toLowerCase()]}'
            : 'Add $platform',
        style: TextStyle(color: color),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}