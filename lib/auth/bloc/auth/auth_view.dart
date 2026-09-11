import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/pages/home_page.dart';
import '../../../authrepo.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// PAGE — responsible only for creating/providing the Bloc.
/// This is what you navigate to: Navigator.push(... AuthPage() ...)
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

/// VIEW — responsible only for UI. Reads the Bloc that's already provided
/// above it. Never creates the Bloc itself — keeps UI and setup separate.
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignupRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Login',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 28,
                            color: Colors.black,fontWeight: FontWeight.bold)),
                     SizedBox(height: 2,),
                     Text(
                        "Reliable. Best. Faster.",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.teal, fontWeight: FontWeight(500)),
                      ),
                    SizedBox(height: 50,),

                   Center(child: Image.asset("assets/icons/software-update.png", height: 300,width: 300,)),
                    
                    const SizedBox(height: 16),

                    const SizedBox(height: 32),
                    TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: "Qwerty@gmail.com",

                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade500,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade500,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                      ),
                      // decoration: InputDecoration(
                      //   labelText: 'Password',
                      //   prefixIcon: const Icon(Icons.lock_outline),
                      //   border: const OutlineInputBorder(),
                      //   suffixIcon: IconButton(
                      //     icon: Icon(_obscurePassword
                      //         ? Icons.visibility_outlined
                      //         : Icons.visibility_off_outlined),
                      //     onPressed: () =>
                      //         setState(() => _obscurePassword = !_obscurePassword),
                      //   ),
                      // ),
                      validator: (v) =>
                      (v == null || v.length < 6) ? 'At least 6 characters' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepOrange,
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}