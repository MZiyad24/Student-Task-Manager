class User {
  String? id;
  String studentId;
  String name;
  String email;
  String? gender;
  String? profilePicture;
  String? academicYear;

  User({
    this.id,
    required this.studentId,
    required this.name,
    required this.email,
    this.gender,
    this.profilePicture,
    this.academicYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'email': email,
      'gender': gender,
      'profilePicture': profilePicture,
      'academicYear': academicYear,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String documentId) {
    return User(
      id: documentId,
      studentId: map['studentId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'],
      profilePicture: map['profilePicture'],
      academicYear: map['academicYear'],
    );
  }
}