import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key, required this.headerTitle, this.subtitle})
      : super(key: key);
  final String headerTitle;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 10.0),
      child: Center(
        heightFactor: 1.0,
        child: Column(
          children: [
            Text(
              headerTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
