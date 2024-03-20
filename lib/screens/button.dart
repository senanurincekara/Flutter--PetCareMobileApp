import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue[50],
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Color.fromARGB(255, 15, 14, 14),
                fontSize: 16, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
