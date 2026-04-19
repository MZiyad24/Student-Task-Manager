import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/profile_service.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info.dart'; // Make sure this matches your filename
import 'widgets/logout_button.dart';
import 'widgets/edit_profile_button.dart';
import 'widgets/edit_profile_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _profileService.getCurrentUserProfile();
  }

  void _showEditModal(User user) {
  // 1. Capture the messenger while the context is still valid
  final messenger = ScaffoldMessenger.of(context);

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditProfileForm(
        user: user,
        onSave: (updatedUser) async {
          // 2. Perform the async database work
          await _profileService.updateProfile(updatedUser);

          // 3. Refresh the UI
          setState(() {
            _userFuture = _profileService.getCurrentUserProfile();
          });

          // 4. Use the captured messenger to show the SnackBar
          // This works even if the modal is closed!
          messenger.showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );
        },
      ),
    );
  }

  // --- THIS IS THE MISSING METHOD CAUSING YOUR ERROR ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text("User not found."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileHeader(name: user.name, imageUrl: user.profilePicture),
                EditProfileButton(onPressed: () => _showEditModal(user)),
                const SizedBox(height: 20),
                ProfileInfo(
                  label: "Student ID",
                  value: user.studentId,
                  icon: Icons.badge_outlined,
                ),
                ProfileInfo(
                  label: "Academic Year",
                  value: user.academicYear ?? "Not Specified",
                  icon: Icons.school_outlined,
                ),
                ProfileInfo(
                  label: "Gender",
                  value: user.gender ?? "Not Specified",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 40),
                LogoutButton(onLogout: () async {
                  await _profileService.signOut();
                  if (mounted) Navigator.pushReplacementNamed(context, '/login');
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}