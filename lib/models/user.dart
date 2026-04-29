class User {
  final String uid;
  final String name;
  final String studentId;
  final String email;
  final String academicYear;
  final String gender;
  final String? profilePicture;

  User({
    required this.uid,
    required this.name,
    required this.studentId,
    required this.email,
    required this.academicYear,
    required this.gender,
    this.profilePicture,
  });

  factory User.fromMap(Map<String, dynamic> map) {
  return User(
    uid: map['uid'] ?? '',
    name: map['name'] ?? 'No Name', 
    studentId: map['studentId']?.toString() ?? '', // Safety first
    email: map['email'] ?? '',
    academicYear: map['academicYear']?.toString() ?? '', 
    gender: map['gender'] ?? '',
    profilePicture: map['profilePicture'],
  );
}
}