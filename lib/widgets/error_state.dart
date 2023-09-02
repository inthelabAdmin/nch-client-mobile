import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Whoops! Something went wrong.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Text("Please try again.")
    ]));
  }
}
