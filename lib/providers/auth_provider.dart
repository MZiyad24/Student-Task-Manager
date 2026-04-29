import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = "";

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> signup({
    required String fullName,
    required String email,
    required String studentId,
    required String password,
    required String confirmPassword,
    required String gender,
    required String academicLevel,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();
    try {

      await _authService.registerUser(
        name: fullName,
        email: email,
        studentId: studentId,
        password: password,
        confirmPassword: confirmPassword,
        gender: gender,
        academicLevel: academicLevel,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception:", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();
    try {
      await _authService.loginUser(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception:", "");
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}