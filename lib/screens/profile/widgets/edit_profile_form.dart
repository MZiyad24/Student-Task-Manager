import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../services/image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileForm extends StatefulWidget {
  final User user;
  final Function(User) onSave;

  const EditProfileForm({super.key, required this.user, required this.onSave});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _academicYearController;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _academicYearController = TextEditingController(text: widget.user.academicYear);
    _selectedGender = widget.user.gender;
  }

  String? _tempImagePath;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Use your service to save it permanently in the app's folder
      final permanentPath = await ImageService.saveImagePermanently(pickedFile.path);
      setState(() {
        _tempImagePath = permanentPath;
      });
      print("New image saved at: $permanentPath");
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Update Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: _tempImagePath != null 
                  ? FileImage(File(_tempImagePath!)) 
                  : (widget.user.profilePicture != null ? FileImage(File(widget.user.profilePicture!)) : null),
              child: _tempImagePath == null && widget.user.profilePicture == null 
                  ? const Icon(Icons.camera_alt) : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () => _pickImage(ImageSource.gallery), child: const Text("Gallery")),
                TextButton(onPressed: () => _pickImage(ImageSource.camera), child: const Text("Camera")),
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Name is required" : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _academicYearController,
              decoration: const InputDecoration(labelText: "Academic Year (e.g. Senior 2)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: ["Male", "Female", "Other"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) => setState(() => _selectedGender = val),
              decoration: const InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedUser = User(
                    id: widget.user.id,
                    studentId: widget.user.studentId,
                    email: widget.user.email,
                    name: _nameController.text,
                    academicYear: _academicYearController.text,
                    gender: _selectedGender,
                    profilePicture: _tempImagePath ?? widget.user.profilePicture,
                  );
                  widget.onSave(updatedUser);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Changes"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}