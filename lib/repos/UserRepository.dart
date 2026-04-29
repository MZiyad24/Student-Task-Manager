import 'dart:convert';
import 'dart:io';
import '../models/user.dart';
import '../services/api.dart';
import '../services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();


  Future<String?> uploadImage(XFile pickedFile) async {
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('http://localhost:3000/user/upload-profile')
    );

    final bytes = await pickedFile.readAsBytes();

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: pickedFile.name,
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();
    
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(respStr);
      return jsonResponse['url'];
    }
    return null;
  }

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
  XFile? profilePicture,
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

  // 1. Handle Image Upload First
  if (profilePicture != null) {
    final imageUrl = await _uploadProfileImage(profilePicture, token);
    if (imageUrl != null) {
      updateData['profilePicture'] = imageUrl; // The URL from NestJS
    }
  }

  // 2. Send everything to the patch endpoint
  final response = await _apiService.patch('/user/update/me', updateData);

  if (response.statusCode == 200) {
    return;
  } else if (response.statusCode == 401) {
    throw Exception("Session expired. Please log in again.");
  } else {
    throw Exception("Failed to update profile: ${response.statusCode}");
  }
}

// Private helper to handle the Multipart request
Future<String?> _uploadProfileImage(XFile pickedFile, String token) async {
  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/user/upload-profile'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    // Convert XFile to bytes for Web compatibility
    final bytes = await pickedFile.readAsBytes();
    
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: pickedFile.name,
      contentType: MediaType('image', 'jpeg'), // Requires import 'package:http_parser/http_parser.dart'
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['url']; // Returns the localhost URL
    }
    return null;
  } catch (e) {
    print("Image upload error: $e");
    return null;
  }
}


}