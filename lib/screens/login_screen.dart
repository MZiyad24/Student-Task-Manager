import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. IMPORTANT IMPORT
import 'signup_screen.dart'; 
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // 2. Added for validation
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = "";
  bool isLoading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      message = "";
    });

    try {
    // Capture the result of the login
    bool success = await context.read<AuthProvider>().login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // ONLY navigate if success is actually true
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/profile'); 
    } else {
      // This handles the case where the provider caught the error 
      // and returned false instead of throwing.
      setState(() {
        message = context.read<AuthProvider>().errorMessage;
      });
    }
    } catch (e) {
      setState(() {
        message = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: primaryColor.shade50,
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              // 6. WRAP IN FORM
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 60, color: primaryColor),
                    const SizedBox(height: 15),
                    Text("Welcome Back", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 25),

                    // 7. CHANGED TO TextFormField for validation
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      validator: (value) => value!.isEmpty ? "Enter your email" : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      validator: (value) => value!.isEmpty ? "Enter your password" : null,
                    ),
                    const SizedBox(height: 25),

                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor, // Simpler than gradient for debugging
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),

                    if (message.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Text(message, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                    ],

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen())),
                      child: const Text("Don't have an account? Sign up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}