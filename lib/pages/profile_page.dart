import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/UiHelper/profile_card_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,

      appBar: AppBar(
        backgroundColor: Colors.teal.shade100,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            children: [
              // ================= PROFILE HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      height: 85,
                      width: 85,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal.shade50,
                        border: Border.all(
                          color: Colors.teal.shade200,
                          width: 3,
                        ),
                      ),

                      child: Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: Colors.teal.shade700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      "Vansh Rajput",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Email
                    Text(
                      "vansh@example.com",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Edit Profile Button
                    SizedBox(
                      height: 42,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Edit profile
                        },

                        icon: const Icon(Icons.edit_outlined, size: 18),

                        label: Text(
                          "Edit Profile",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal.shade700,
                          side: BorderSide(color: Colors.teal.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= ACCOUNT =================
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

              // ================= PREFERENCES =================
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

              // ================= SUPPORT =================
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

              ProfileCardHelper(
                icon: Icons.info_outline_rounded,
                title: "About Handa Grocery",
                subtitle: "App information",
                onTap: () {
                  // About
                },
              ),

              const SizedBox(height: 20),

              // ================= LOGOUT =================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: ListTile(
                  onTap: () {
                    _showLogoutDialog(context);
                  },

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

              Text(
                "Handa Grocery",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
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
          color: Colors.black87,
        ),
      ),
    );
  }

  // ================= PROFILE OPTION =================

  // ================= LOGOUT DIALOG =================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          title: Text(
            "Logout?",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          ),

          content: Text(
            "Are you sure you want to logout from Handa Grocery?",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
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
