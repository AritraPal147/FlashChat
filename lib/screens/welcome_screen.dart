import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {

  // controller variable that controls animation
  late AnimationController controller;
  // animation variable
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
    );
    // controller.value is a float between 0 and 1 by default

    /// For curved animation
    // animation = CurvedAnimation(
    //     parent: controller,
    //     curve: Curves.easeIn
    // );

    /// For background color changing animation (Tween -> In between animations)
    // Background animated from red color initially to blue color
    // animation = ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);

    controller.forward();
    // Increases controller variable value from 0 to 1 linearly
    // controller.reverse(from: 1.0); will reduce value of controller from 1 to 0.

    /// TO add looping:
    // animation.addStatusListener((status) {
    //   // Checks if animation is completed or not (reached maximum size)
    //   if (status == AnimationStatus.completed) {
    //     // Reverses direction of controller so that animation goes in reverse order
    //     controller.reverse(from: 1.0);
    //   }
    //   // Checks if animation is dismissed or not (reached minimum size)
    //   else if (status == AnimationStatus.dismissed) {
    //     // Makes controller count forward
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      // setState() is used to make Flutter recognise changes in animation due to
      // change in value of controller.value and animation.value.
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    // Disposes the controller when the welcome screen is dismissed.
    // If controller is not disposed then the animation will continue running in the
    // background even after the the welcome screen is dismissed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Colors.red.withOpacity(controller.value) will give a background that
      // slowly becomes opaque, starting from transparency.
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                    tag: 'logo',
                    child: Container(
                      height: 60,
                      child: Image.asset('images/logo.png'),
                    ),
                ),
                const Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    // Go to login screen
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Register',
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
