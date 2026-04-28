import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this
import '../../models/user.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info.dart';
import 'widgets/logout_button.dart';
import 'widgets/edit_profile_button.dart';
import 'widgets/edit_profile_form.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserProvider>().fetchProfile();
    }
    );
  }

  void _showEditModal(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditProfileForm(
        user: user,
        onSave: (updatedName, updatedGender, updatedLevel, updatedImage) async {
          final success = await context.read<UserProvider>().updateProfile(
            name: updatedName,
            gender: updatedGender,
            academicLevel: updatedLevel,
            image: updatedImage,
          );

          if(!mounted) return;
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    print("the user in profile screen: ${user?.name}");

    if (userProvider.isLoading) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => userProvider.fetchProfile(),
          child: const Text("Retry Connection"),
        ),
      ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.task, color: Colors.blue),
            onPressed: () => Navigator.pushNamed(context, '/tasks'),
          ),
        ],
      ),
      // 4. Use Provider state instead of FutureBuilder
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("User not found."),
                      TextButton(
                        onPressed: () => userProvider.fetchProfile(),
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
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
                        // 5. Handled via your Auth logic 
                        // (Make sure to clear UserProvider too)
                        userProvider.clearUser();
                        Navigator.pushReplacementNamed(context, '/login');
                      }),
                    ],
                  ),
                ),
    );
  }
}