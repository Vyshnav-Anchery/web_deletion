import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_deletion/provider.dart';
import 'package:web_deletion/textformfield_custom.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFunctions provider =
        Provider.of<FirebaseFunctions>(context, listen: false);
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Card(
          child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Delete Account",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                          "Please enter Email and Password to delete your account.")),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: 250,
                      child: CustomTextForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          controller: emailController,
                          hintText: "Email")),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: 250,
                      child: CustomTextForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            // Check for minimum length
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters.';
                            }
                            // Check for at least one uppercase letter
                            if (!value.contains(RegExp(r'[A-Z]'))) {
                              return 'Password must contain at least one uppercase.';
                            }
                            // Check for at least one lowercase letter
                            if (!value.contains(RegExp(r'[a-z]'))) {
                              return 'Password must contain at least one lowercase.';
                            }
                            // Check for at least one digit
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return 'Password must contain at least one digit';
                            }
                            // Check for at least one special character (customize the character set)
                            if (!value.contains(
                                RegExp(r'[!@#\$%^&*()_+{}:;<>,.?~]'))) {
                              return 'Password must contain at least one special character';
                            }
                            if (value.contains(' ')) {
                              return 'Password must not contain spaces';
                            }
                            // authenticationController.setPasswordValidated();
                            return null;
                          },
                          controller: passController,
                          hintText: "Password")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          provider.deleteAccount(
                              email: emailController.text.trim(),
                              password: passController.text.trim());
                        }
                      },
                      child: const Text("Delete Account")),
                  const SizedBox(height: 20),
                ],
              )),
        ),
      ),
    );
  }
}
