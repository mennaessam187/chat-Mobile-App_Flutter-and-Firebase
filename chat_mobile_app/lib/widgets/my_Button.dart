import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  Color? color;
  String? title;
  Function()? onPressed;
  MyButton({required this.color, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(15),
        elevation: 0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 380,
          child: Text(
            title!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
