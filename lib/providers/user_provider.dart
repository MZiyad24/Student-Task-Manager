import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../repos/UserRepository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepo = UserRepository();

  User? _user;
  bool _isLoading = false;
  String _errorMessage = "";

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _setLoading(true);
    _errorMessage = "";

    try {
      _user = await _userRepo.getMyProfile();
      print ("Profile fetched: ${_user?.name}");
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _user = null;
    } finally {
      _setLoading(false);
    }
  } 

  Future<bool> updateProfile({
    String? name,
    String? gender,
    String? academicLevel,
    XFile? image,
  }) async {
    int? levelAsInt;
    if (academicLevel != null) {
      levelAsInt = int.tryParse(academicLevel);
    }
    _setLoading(true);
    _errorMessage = "";

    try {
      await _userRepo.updateProfile(
        name: name,
        gender: gender,
        academicLevel: levelAsInt,
        profilePicture: image,
      );
      
      // After a successful update, re-fetch the profile to sync the UI
      await fetchProfile(); 
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _setLoading(false);
      return false;
    }
  }

  // 3. Logout Helper
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // Private helper to reduce code duplication
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}