import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'friends_page.dart';
import 'auth_page.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController? _iconController;
  AnimationController? _textController;
  Animation<Offset>? _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.4, 0.0),
      end: Offset(-0.2, 0.0),
    ).animate(CurvedAnimation(
      parent: _iconController!,
      curve: Curves.easeInOut,
    ));

    _iconController!.forward();

    // Start the text animation after a delay of 1 second
    Future.delayed(Duration(seconds: 2), () {
      _textController!.forward();
    });

    _checkAuthState();
  }

  void _checkAuthState() async {
    await Future.delayed(Duration(seconds: 4)); // Simulate a delay for the splash screen
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: user.uid)),
      );
    }
  }

  @override
  void dispose() {
    _iconController!.dispose();
    _textController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _offsetAnimation!,
              child: Image.asset(
                'assets/images/mapper_logo.png', // Use your custom icon
                width: 100,
                height: 100,
              ),
            ),
            FadeTransition(
              opacity: _textController!,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0), // Adjust spacing between icon & text
                child: Text(
                  'Mapper',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
