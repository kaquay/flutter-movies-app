import 'package:flutter/material.dart';

class SingleValueLine extends StatelessWidget {
  const SingleValueLine({super.key, required this.title, required this.value});
  final Widget title;
  final Widget value;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        title,
        value,
      ],
    );
  }

  factory SingleValueLine.text(String title, String value) {
    return SingleValueLine(
      title: Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ),
      value: Expanded(
        flex: 2,
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
