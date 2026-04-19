import 'package:flutter/material.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditProfileButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit, size: 18),
      label: const Text("Edit Profile"),
      style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
    );
  }
}