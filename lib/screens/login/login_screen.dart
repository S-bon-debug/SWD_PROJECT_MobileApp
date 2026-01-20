import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.hub,
                    size: 72,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'IOT SMART\nENVIRONMENTAL\nMONITOR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Welcome back, please login to your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  _inputField(
                    label: 'EMAIL',
                    icon: Icons.person,
                    hint: 'user@iot-admin.com',
                  ),

                  const SizedBox(height: 20),

                  _inputField(
                    label: 'PASSWORD',
                    icon: Icons.lock,
                    hint: '********',
                    isPassword: true,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/dashboard');
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('REGISTER'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.black,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}
