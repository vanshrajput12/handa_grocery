import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../auth_bloc.dart';
import '../auth_event.dart';
import '../auth_state.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND RESET LINK
  // ============================================================

  void _sendResetLink() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Send event to the SAME AuthBloc
    context.read<AuthBloc>().add(AuthForgotPasswordRequested(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Lottie.asset(
                  "assets/animations/forgotPassword.json",
                  height: 300,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    color: Colors.yellow.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your registered email address and we will send you a password reset link.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight(600),
                ),
              ),

              const SizedBox(height: 35),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight(600),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle:const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white,),
                  filled: true,
                  fillColor: Colors.grey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(34),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(34),
                    borderSide:  BorderSide(
                      color: Colors.yellow.shade700,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // SEND RESET BUTTON
              // ==================================================
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: isLoading ? null : _sendResetLink,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'Send Reset Link',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
              Padding(
                padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_outlined, size: 20, color: Colors.black,),
                      SizedBox(width: 5),
                       Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Colors.yellow.shade700,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
