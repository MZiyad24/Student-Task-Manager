class User {
  int? id;
  String studentId;
  String name;
  String email;
  String password;
  String? gender;
  String? profilePicture;
  String? academicYear;

  User({
    this.id,
    required this.studentId,
    required this.name,
    required this.email,
    required this.password,
    this.gender,
    this.profilePicture,
    this.academicYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'profilePicture': profilePicture,
      'academicYear': academicYear,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      studentId: map['studentId'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      gender: map['gender'],
      profilePicture: map['profilePicture'],
      academicYear: map['academicYear'],
    );
  }
}