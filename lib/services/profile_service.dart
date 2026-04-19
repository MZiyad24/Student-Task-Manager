import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';
import '../repos/UserRepository.dart';

class ProfileService {
  final UserRepository _userRepo = UserRepository();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Stream<auth.User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> getCurrentUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return await _userRepo.getUserById(currentUser.uid);
    }
    return await _userRepo.getUserById("Q0FcJgWpRZM5jHgfs3eO");
    // return null;
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateProfile(User user) async {
    await _userRepo.updateUser(user);
  }
}