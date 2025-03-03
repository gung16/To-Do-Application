import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight,
          child: Stack(
            children: [
              // Background image with curved bottom
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.65, // Slightly reduced height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/mainimage.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              // Content
              Positioned(
                top: screenHeight * 0.65, // Align with image bottom
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20), // Reduced spacing
                      
                      // Main heading
                      Text(
                        'Need to keep track of everything?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28, // Slightly smaller font
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      
                      SizedBox(height: 12), // Reduced spacing
                      
                      // Subheading
                      Text(
                        'The Gungs Todo app is the best way to keep track of everything you need to do.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14, // Slightly smaller font
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      
                      SizedBox(height: 24), // Reduced spacing
                      
                      // Get Started button
                      SizedBox(
                        width: double.infinity,
                        height: 50, // Slightly smaller button
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20), // Reduced spacing
                      
                      // Don't have an account text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF50C2C9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom clipper for the curved bottom of the image
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40); // Reduced curve height
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    
    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondEndPoint = Offset(size.width, size.height - 40); // Reduced curve height
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    
    path.lineTo(size.width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}