import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  // Construction for RoundedButton that needs a title, colour and onPressed function
  const RoundedButton({super.key,
    required this.title,
    required this.colour,
    required this.onPressed
  });

  // Variable for color
  final Color colour;
  // Variable for text in button
  final String title;
  // Variable for onPressed function
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        // Adds elevation -> shadow behind button
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}