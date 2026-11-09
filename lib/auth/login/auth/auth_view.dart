import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/auth/login/auth/forgot_password_page/forgot_password.dart';
import 'package:handa_grocery/bottom%20Nav/Bottom_Nav.dart';
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
  // Same palette as the Handa Grocery home page
  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const darkText = Color(0xFF25352A);
  static const background = Color(0xFFF7F9F6);
  static const fieldBorder = Color(0xFFE3ECE5);

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
  // ACTIONS
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

  void _googleSignIn() {
    context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
  }

  // ----------------------------------------------------------
  // INPUT STYLE
  // ----------------------------------------------------------

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: Colors.grey.shade500,
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: green, size: 22),
      suffixIcon: suffix,
      filled: true,
      fillColor: background,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: _border(fieldBorder),
      focusedBorder: _border(green, width: 1.8),
      errorBorder: _border(Colors.red.shade400),
      focusedErrorBorder: _border(Colors.red.shade400, width: 1.8),
      errorStyle: GoogleFonts.poppins(fontSize: 11),
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // SUCCESS (email login and Google sign-in both end here)
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          }

          // ERROR
          else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.red.shade400,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;

          return Stack(
            children: [
              // Soft decorative background (no header card)
              ..._buildBackgroundDecor(),

              SafeArea(
                bottom: false,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _buildTopSection()),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildFormSheet(isLoading),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // BACKGROUND
  // ----------------------------------------------------------

  List<Widget> _buildBackgroundDecor() {
    return [
      Positioned(
        top: -90,
        right: -70,
        child: Container(
          height: 260,
          width: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                green.withValues(alpha: 0.14),
                green.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 190,
        left: -100,
        child: Container(
          height: 260,
          width: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFFFE9B8).withValues(alpha: 0.55),
                const Color(0xFFFFE9B8).withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  // ----------------------------------------------------------
  // TOP: BRAND + LOTTIE
  // ----------------------------------------------------------

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: fieldBorder),
                ),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  color: green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Handa Grocery',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: deepGreen,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'Reliable. Best. Faster.',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Lottie.asset(
            'assets/animations/login.json',
            height: 230,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox(
              height: 230,
              child: Icon(
                Icons.shopping_basket_outlined,
                color: green,
                size: 80,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // FORM SHEET (white, rounded top)
  // ----------------------------------------------------------

  Widget _buildFormSheet(bool isLoading) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: darkText.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 28, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Log in or create an account to start shopping.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // EMAIL
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.poppins(
                color: darkText,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Enter a valid email';
                }
                return null;
              },
              decoration: _inputDecoration(
                hint: 'Email address',
                icon: Icons.mail_outline_rounded,
              ),
            ),

            const SizedBox(height: 16),

            // PASSWORD
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (!isLoading) _submit();
              },
              style: GoogleFonts.poppins(
                color: darkText,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              decoration: _inputDecoration(
                hint: 'Password',
                icon: Icons.lock_outline_rounded,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // FORGOT PASSWORD
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
                  'Forgot password?',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: green,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // MAIN BUTTON
            _buildPrimaryButton(isLoading),

            const SizedBox(height: 22),

            // DIVIDER
            Row(
              children: [
                const Expanded(child: Divider(color: fieldBorder)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    'or',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: fieldBorder)),
              ],
            ),

            const SizedBox(height: 22),

            // GOOGLE BUTTON
            _buildGoogleButton(isLoading),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // BUTTONS
  // ----------------------------------------------------------

  Widget _buildPrimaryButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [Colors.grey.shade400, Colors.grey.shade400]
                : const [deepGreen, green],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: isLoading
              ? null
              : [
            BoxShadow(
              color: green.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: isLoading
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: Colors.white,
            ),
          )
              : Text(
            'Verify & Continue',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: isLoading ? null : _googleSignIn,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: fieldBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple "G" mark. Swap for an official logo asset if you like:
            // Image.asset('assets/images/google_logo.png', height: 22)
            Text(
              'G',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Continue with Google',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}