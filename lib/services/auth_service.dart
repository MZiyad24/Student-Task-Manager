import 'dart:convert';
import '../services/api.dart';
import '../services/storage_service.dart';

class AuthService {
  final String baseUrl = "http://localhost:3000"; 
  final StorageService _storageService = StorageService();
  final ApiService api = ApiService();

  Future<void> registerUser({
    required String name,
    required String email,
    required String studentId,
    required String password,
    required String confirmPassword,
    required String gender,
    required String academicLevel,
  }) async {
    try {
      final response = await api.post('/auth/signup',  
        {
          "name": name,
          "email": email,
          "studentId": studentId,
          "password": password,
          "confirmPassword": confirmPassword,
          "gender": gender,
          "academicLevel": int.parse(academicLevel), 
        }
      );
      
      if (response.statusCode == 201) {
        String? token = jsonDecode(response.body)['idToken'];
        if(token != null) {
          await _storageService.saveToken(token);
        }
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Signup failed");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {     
    try {
      final response = await api.post(
        '/auth/login',
        {
          "email": email,
          "password": password,
        }
      );

      if (response.statusCode == 200) {
        String? token = jsonDecode(response.body)['idToken'];
        if(token != null) {
          await _storageService.saveToken(token);
        }
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Login failed");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }
}