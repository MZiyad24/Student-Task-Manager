import 'package:flutter/material.dart';
import '../../../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // Required for Web bytes

class EditProfileForm extends StatefulWidget {
  final User user;
  final Function(String name, String gender, String academicLevel, XFile? image) onSave;

  const EditProfileForm({super.key, required this.user, required this.onSave});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _academicYearController;
  String? _selectedGender;
  
  XFile? _pickedFile; // Use XFile instead of File
  Uint8List? _webImage; // To display preview on Web

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _academicYearController = TextEditingController(text: widget.user.academicYear);
    _selectedGender = widget.user.gender;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedFile = image;
        _webImage = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic preview logic
    ImageProvider? profileImage;
    if (_webImage != null) {
      profileImage = MemoryImage(_webImage!);
    } else if (widget.user.profilePicture != null && widget.user.profilePicture!.isNotEmpty) {
      profileImage = NetworkImage(widget.user.profilePicture!);
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView( // Added scroll for smaller screens
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Update Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              CircleAvatar(
                radius: 40,
                backgroundImage: profileImage,
                child: profileImage == null ? const Icon(Icons.person, size: 40) : null,
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery), 
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery")
                  ),
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera), 
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _academicYearController,
                keyboardType: TextInputType.number, // Since backend expects a number
                decoration: const InputDecoration(labelText: "Academic Year (Number)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ["Male", "Female", "Other"].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
                decoration: const InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.onSave(
                        _nameController.text,
                        _selectedGender ?? "",
                        _academicYearController.text,
                        _pickedFile, // Passing the XFile
                      );
                      if(mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text("Save Changes"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}