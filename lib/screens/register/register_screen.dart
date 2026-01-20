import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// Title
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Sign up to get started",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 32),

                /// Full name
                TextFormField(
                  controller: nameCtrl,
                  decoration: _inputDecoration("Full name", Icons.person),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your name" : null,
                ),

                const SizedBox(height: 16),

                /// Email
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Email", Icons.email),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter email" : null,
                ),

                const SizedBox(height: 16),

                /// Password
                TextFormField(
                  controller: passwordCtrl,
                  obscureText: hidePassword,
                  decoration: _inputDecoration(
                    "Password",
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) =>
                      value!.length < 6 ? "Min 6 characters" : null,
                ),

                const SizedBox(height: 16),

                /// Confirm password
                TextFormField(
                  controller: confirmPasswordCtrl,
                  obscureText: hideConfirmPassword,
                  decoration: _inputDecoration(
                    "Confirm password",
                    Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) =>
                      value != passwordCtrl.text
                          ? "Password does not match"
                          : null,
                ),

                const SizedBox(height: 32),

                /// Register button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: handle register logic
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        }
                      },
                    child: const Text(
                      "Create",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Back to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Back to Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
