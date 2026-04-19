import 'package:flutter/material.dart';
import 'dart:io';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const ProfileHeader({super.key, required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? FileImage(File(imageUrl!)) as ImageProvider
          : null,
          child: imageUrl == null 
              ? const Icon(Icons.person, size: 60, color: Colors.blueAccent) 
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}