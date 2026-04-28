import 'dart:convert';
import 'dart:io';
import '../models/user.dart';
import '../services/api.dart';
import '../services/storage_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<User> getMyProfile() async {
    print ("Getting profile...");
    final token = await _storageService.getToken();
    print ("Token found: $token");
    if (token == null) {
      throw Exception("No authentication token found. Please login.");
    }

    
    final response = await _apiService.get('/user/me');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print ("Profile response data: ${data}");
      return User.fromMap(data);
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else {
      throw Exception("Failed to load profile: ${response.statusCode}");
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? studentId,
    String? gender,
    int? academicLevel,
    File? profilePicture,
  }) async {
    final token = await _storageService.getToken();

    if (token == null) {
      throw Exception("No authentication token found. Please login.");
    }

    Map<String, dynamic> updateData = {};
    if (name != null) updateData['name'] = name;
    if (email != null) updateData['email'] = email;
    if (studentId != null) updateData['studentId'] = studentId;
    if (gender != null) updateData['gender'] = gender;
    if (academicLevel != null) updateData['academicLevel'] = academicLevel;
    if (profilePicture != null) {
      // Handle profile picture upload logic here (e.g., convert to base64 or multipart)
    }
    final response = await _apiService.patch('/user/update/me', updateData);

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else {
      throw Exception("Failed to update profile: ${response.statusCode}");
    }

  }


}