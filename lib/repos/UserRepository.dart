import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';

class UserRepository {
  final CollectionReference _userCollection = 
      FirebaseFirestore.instance.collection('users');
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // login

  // signup

  // get user
  Future<User?> getUserById(String id) async {
    final doc = await _userCollection.doc(id).get();
    if (doc.exists) {
      return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // 4. UPDATE PROFILE
  Future<void> updateUser(User user) async {
    if (user.id != null) {
      await _userCollection.doc(user.id).update(user.toMap());
    }
  }

  
}