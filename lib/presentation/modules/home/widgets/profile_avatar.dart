import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.onPressed});
  final Function(User? user) onPressed;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          var user = snapshot.data;
          Widget child;
          if (user == null) {
            child = const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
              ),
            );
          } else {
            child = CircleAvatar(
              child: CachedNetworkImage(imageUrl: user.photoURL ?? ''),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () => onPressed(user),
              child: child,
            ),
          );
        });
  }
}
