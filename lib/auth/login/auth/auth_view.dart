import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/auth/login/auth/forgot_password_page/forgot_password.dart';
import 'package:handa_grocery/bottom%20Nav/Bottom_Nav.dart';
import 'package:handa_grocery/pages/home_page.dart';
import 'package:lottie/lottie.dart';

import '../../../authrepo.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// Applies the Bloc properties to the LOGIN SCREEN through this AUTH PAGE.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const AuthView(),
    );
  }
}

// UI Part of LOGIN Screen
class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // SUBMIT
  // ----------------------------------------------------------

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      AuthLoginOrSignupRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // ------------------------------------------------
            // SUCCESS
            // ------------------------------------------------

            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                ),
              );
            }

            // ------------------------------------------------
            // ERROR
            // ------------------------------------------------

            else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          // --------------------------------------------------
          // UI
          // --------------------------------------------------

          builder: (context, state) {
            final bool isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // LOGIN TITLE
                      Text(
                        'LOGIN',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.yellow.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // SUBTITLE
                      Text(
                        "Reliable. Best. Faster.",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // LOTTIE ANIMATION
                      Center(
                        child: Lottie.asset(
                          "assets/animations/Relax on the beach.json",
                          height: 300,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ------------------------------------------------
                      // EMAIL
                      // ------------------------------------------------

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }

                          if (!value.contains('@') ||
                              !value.contains('.')) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Qwerty@gmail.com",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade500,

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: BorderSide(
                              color: Colors.yellow.shade700,
                              width: 2,
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ------------------------------------------------
                      // PASSWORD
                      // ------------------------------------------------

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade500,

                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: BorderSide(
                              color: Colors.yellow.shade700,
                              width: 2,
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(34),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ------------------------------------------------
                      // FORGOT PASSWORD
                      // ------------------------------------------------

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            final authBloc = context.read<AuthBloc>();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: authBloc,
                                  child: const ForgotPassword(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.yellow.shade700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ------------------------------------------------
                      // BUTTON
                      // ------------------------------------------------

                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                              : Text(
                            'Verify & Continue',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}