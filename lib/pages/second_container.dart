import 'package:flutter/material.dart';

class SecondContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Container Example'),
      ),
      body: Center(
        child: Container(
          width: 200.0,
          height: 100.0,
          color: Colors.blue,
          child: Center(
            child: Text(
              'Hello, World!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
