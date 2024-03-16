import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, this.image, this.content, this.action});
  final Widget? image;
  final Widget? content;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          image ?? const SizedBox(),
          content ?? const SizedBox(),
          action ?? const SizedBox(),
        ],
      ),
    );
  }

  factory AppErrorWidget.simple(
      String content, String action, VoidCallback actionCallback) {
    return AppErrorWidget(
      image: null,
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      action: TextButton(
        onPressed: actionCallback,
        child: Text(
          action,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
