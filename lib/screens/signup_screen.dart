import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String gender = "";
  String academicLevel = "1";
  String message = "";

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final primaryColor = Colors.deepPurple;

  // ---------------- Validation ----------------
  bool isPasswordValid(String password) {
    return password.length >= 8 && password.contains(RegExp(r'[0-9]'));
  }

  bool isValidFCIEmail(String email) {
    return RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$').hasMatch(email);
  }

  // ---------------- SIGNUP ----------------
  Future<void> signup() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final studentId = studentIdController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        studentId.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        message = "❌ Please fill all required fields";
        isLoading = false;
      });
      return;
    }

    if (!isValidFCIEmail(email)) {
      setState(() {
        message = "❌ Invalid FCI email format";
        isLoading = false;
      });
      return;
    }

    if (!email.startsWith(studentId)) {
      setState(() {
        message = "❌ Student ID must match email";
        isLoading = false;
      });
      return;
    }

    if (!isPasswordValid(password)) {
      setState(() {
        message = "❌ Password must be 8+ characters and contain a number";
        isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        message = "❌ Passwords do not match";
        isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "fullName": fullName,
        "email": email,
        "studentId": studentId,
        "gender": gender,
        "academicLevel": academicLevel,
        "createdAt": DateTime.now(),
      });

      setState(() {
        message = "Signup Success ✔";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message ?? "Signup Failed ❌";
      });
    } catch (e) {
      setState(() {
        message = "Something went wrong ❌";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.shade50,
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, size: 60, color: primaryColor),
                  const SizedBox(height: 15),

                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 25),

                  buildField("Full Name", Icons.person, fullNameController),
                  const SizedBox(height: 15),

                  buildField("Email", Icons.email, emailController),
                  const SizedBox(height: 15),

                  buildField("Student ID", Icons.badge, studentIdController),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.wc, color: primaryColor),
                        const SizedBox(width: 10),
                        const Text("Gender:"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                value: "Male",
                                groupValue: gender,
                                onChanged: (val) =>
                                    setState(() => gender = val!),
                              ),
                              const Text("Male"),
                              Radio(
                                value: "Female",
                                groupValue: gender,
                                onChanged: (val) =>
                                    setState(() => gender = val!),
                              ),
                              const Text("Female"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.school, color: primaryColor),
                        const SizedBox(width: 10),
                        const Text("Academic Level:"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: academicLevel,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: ["1", "2", "3", "4"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text("Level $e"),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => academicLevel = val!),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  buildPasswordField(
                    "Password",
                    passwordController,
                    obscurePassword,
                    () => setState(() => obscurePassword = !obscurePassword),
                  ),

                  const SizedBox(height: 15),

                  buildPasswordField(
                    "Confirm Password",
                    confirmPasswordController,
                    obscureConfirmPassword,
                    () => setState(() =>
                        obscureConfirmPassword = !obscureConfirmPassword),
                  ),

                  const SizedBox(height: 25),

                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.purpleAccent,
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(height: 15),

                  Text(
                    message,
                    style: TextStyle(
                      color: message.contains("Success")
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Helpers ----------------
  Widget buildField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock, color: primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: primaryColor,
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}