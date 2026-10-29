import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/services/order_service.dart';
import 'package:handa_grocery/services/wishlist_service.dart';
import '../auth/login/auth/auth_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);
  static const amber = Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER + FLOATING STATS =================
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [deepGreen, green],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -45,
                          right: -35,
                          child: _decorCircle(150),
                        ),
                        Positioned(
                          bottom: -55,
                          left: -45,
                          child: _decorCircle(130),
                        ),
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 14, 20, 56),
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

                                // AVATAR WITH EDIT BADGE
                                SizedBox(
                                  height: 96,
                                  width: 96,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 92,
                                        width: 92,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.45),
                                            width: 4,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person_rounded,
                                          size: 50,
                                          color: green,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: amber,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // NAME + EMAIL
                                StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: currentUser == null
                                      ? null
                                      : FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    String name =
                                        currentUser?.displayName ?? "User";
                                    String email =
                                        currentUser?.email ?? "No email";

                                    if (snapshot.hasData &&
                                        snapshot.data!.exists) {
                                      final data = snapshot.data!.data();

                                      if (data != null) {
                                        final firestoreName =
                                        data['name']?.toString();
                                        final firestoreEmail =
                                        data['email']?.toString();

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

                                const SizedBox(height: 14),

                                // EDIT PROFILE
                                SizedBox(
                                  height: 40,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // Edit profile
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 17,
                                    ),
                                    label: Text(
                                      "Edit Profile",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                      Colors.white.withValues(alpha: 0.14),
                                      side: BorderSide(
                                        color:
                                        Colors.white.withValues(alpha: 0.6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
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

                // FLOATING STATS CARD
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: -38,
                  child: _statsCard(),
                ),
              ],
            ),

            const SizedBox(height: 62),

            // ================= MENU =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                children: [
                  _menuGroup(
                    title: "Account",
                    tiles: [
                      _menuTile(
                        icon: Icons.shopping_bag_outlined,
                        title: "My Orders",
                        subtitle: "View your recent orders",
                        onTap: () {
                          // My orders
                        },
                      ),
                      _menuTile(
                        icon: Icons.location_on_outlined,
                        title: "Delivery Address",
                        subtitle: "Manage your delivery addresses",
                        onTap: () {
                          // Address
                        },
                      ),
                      _menuTile(
                        icon: Icons.credit_card_outlined,
                        title: "Payment Methods",
                        subtitle: "Manage your payment options",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  _menuGroup(
                    title: "Preferences",
                    tiles: [
                      _menuTile(
                        icon: Icons.notifications_none_rounded,
                        title: "Notifications",
                        subtitle: "Manage notification settings",
                        onTap: () {
                          // Notifications
                        },
                      ),
                      _menuTile(
                        icon: Icons.language_rounded,
                        title: "Language",
                        subtitle: "App language",
                        trailingText: "English",
                        onTap: () {
                          // Language
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  _menuGroup(
                    title: "Support",
                    tiles: [
                      _menuTile(
                        icon: Icons.help_outline_rounded,
                        title: "Help & Support",
                        subtitle: "Get help with your account",
                        onTap: () {
                          // Help
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ================= LOGOUT =================
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3DCDC)),
                    ),
                    child: ListTile(
                      onTap: () => _showLogoutDialog(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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

                  const SizedBox(height: 28),

                  // ================= FOOTER =================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.eco_outlined, size: 15, color: green),
                        const SizedBox(width: 6),
                        Text(
                          "Handa Grocery • Online Shopping",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: green,
                          ),
                        ),
                      ],
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

  // ================= DECORATIVE CIRCLE =================
  Widget _decorCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.07),
      ),
    );
  }

  // ================= STATS CARD =================
  Widget _statsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: deepGreen.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: OrderService().getUserOrders(),
              builder: (context, snapshot) {
                final count = snapshot.data?.docs.length ?? 0;
                return _statItem(
                  icon: Icons.shopping_bag_outlined,
                  value: "$count",
                  label: "Orders",
                );
              },
            ),
          ),
          Container(height: 38, width: 1, color: const Color(0xFFE6EEE8)),
          Expanded(
            child: StreamBuilder<List<CardItemModel>>(
              stream: WishlistService().getWishlist(),
              builder: (context, snapshot) {
                final count = snapshot.data?.length ?? 0;
                return _statItem(
                  icon: Icons.favorite_border_rounded,
                  value: "$count",
                  label: "Wishlist",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: green, size: 20),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: darkText,
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= MENU GROUP (one card, divided rows) =================
  Widget _menuGroup({required String title, required List<Widget> tiles}) {
    final List<Widget> rows = [];

    for (int i = 0; i < tiles.length; i++) {
      rows.add(tiles[i]);
      if (i != tiles.length - 1) {
        rows.add(
          const Padding(
            padding: EdgeInsets.only(left: 72, right: 16),
            child: Divider(height: 1, color: Color(0xFFEDF1ED)),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFEDF3EE)),
            boxShadow: [
              BoxShadow(
                color: green.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(children: rows),
          ),
        ),
      ],
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? trailingText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: green, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: green,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey.shade500,
              ),
            ],
          ),
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