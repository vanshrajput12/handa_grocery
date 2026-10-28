import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/UiHelper/profileCard_helper.dart';
import '../auth/login/auth/auth_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= GREEN PROFILE HEADER =================
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [deepGreen, green],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My Profile",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // PROFILE IMAGE
                      Container(
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.45),
                            width: 4,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: green,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // NAME + EMAIL
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: currentUser == null
                            ? null
                            : FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          String name = currentUser?.displayName ?? "User";
                          String email = currentUser?.email ?? "No email";

                          if (snapshot.hasData && snapshot.data!.exists) {
                            final data = snapshot.data!.data();

                            if (data != null) {
                              final firestoreName = data['name']?.toString();
                              final firestoreEmail = data['email']?.toString();

                              if (firestoreName != null &&
                                  firestoreName.isNotEmpty) {
                                name = firestoreName;
                              }

                              if (firestoreEmail != null &&
                                  firestoreEmail.isNotEmpty) {
                                email = firestoreEmail;
                              }
                            }
                          }

                          return Column(
                            children: [
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                email,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // EDIT PROFILE
                      SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Edit profile
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: Text(
                            "Edit Profile",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: green,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ================= SECTIONS =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
              child: Column(
                children: [
                  _sectionTitle("Account"),
                  const SizedBox(height: 10),

                  ProfileCardHelper(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    subtitle: "View your recent orders",
                    onTap: () {
                      // My orders
                    },
                  ),
                  ProfileCardHelper(
                    icon: Icons.location_on_outlined,
                    title: "Delivery Address",
                    subtitle: "Manage your delivery addresses",
                    onTap: () {
                      // Address
                    },
                  ),
                  ProfileCardHelper(
                    icon: Icons.credit_card_outlined,
                    title: "Payment Methods",
                    subtitle: "Manage your payment options",
                    onTap: () {},
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Preferences"),
                  const SizedBox(height: 10),

                  ProfileCardHelper(
                    icon: Icons.notifications_none_rounded,
                    title: "Notifications",
                    subtitle: "Manage notification settings",
                    onTap: () {
                      // Notifications
                    },
                  ),
                  ProfileCardHelper(
                    icon: Icons.language_rounded,
                    title: "Language",
                    subtitle: "English",
                    onTap: () {
                      // Language
                    },
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Support"),
                  const SizedBox(height: 10),

                  ProfileCardHelper(
                    icon: Icons.help_outline_rounded,
                    title: "Help & Support",
                    subtitle: "Get help with your account",
                    onTap: () {
                      // Help
                    },
                  ),

                  const SizedBox(height: 20),

                  // ================= LOGOUT =================
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFEDF1ED)),
                    ),
                    child: ListTile(
                      onTap: () => _showLogoutDialog(context),
                      leading: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.red.shade600,
                        ),
                      ),
                      title: Text(
                        "Logout",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= FOOTER =================
                  Text(
                    "Handa Grocery",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: green,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Online Shopping",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: darkText,
        ),
      ),
    );
  }

  // ================= LOGOUT DIALOG =================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            "Logout?",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
          content: Text(
            "Are you sure you want to logout from Handa Grocery?",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          actions: [
            // CANCEL
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // LOGOUT
            ElevatedButton(
              onPressed: () async {
                try {
                  Navigator.pop(dialogContext);

                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                        (route) => false,
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Logout failed: $e"),
                      backgroundColor: green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Logout",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}