import 'package:flutter/material.dart';

class IconApp extends StatelessWidget {
  const IconApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(62, 31, 71, 50),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ToDo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 100,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
            ),
            Text('Tasks',
            style: TextStyle(
              fontSize: 40,
                fontStyle: FontStyle.italic,
              color: Colors.black54
            ),
            ),
          ],
        ),
      ),
    );
  }
}
