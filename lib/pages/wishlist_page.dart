import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/UiHelper/Wishlist_productCard_helper.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/services/wishlist_service.dart';

class WishlistPage extends StatelessWidget {
  WishlistPage({super.key});

  final WishlistService _wishlistService = WishlistService();

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: StreamBuilder<List<CardItemModel>>(
              stream: _wishlistService.getWishlist(),
              builder: (context, snapshot) {
                final products = snapshot.data ?? [];

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: green),
                  );
                }

                if (snapshot.hasError) return _errorView();

                if (products.isEmpty) return _emptyView();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 5),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: lightGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.favorite_rounded,
                                  size: 16,
                                  color: green,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${products.length} ${products.length == 1 ? "Item" : "Items"}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Tap the heart to remove",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 25),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.67,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return WishlistProductCardHelper(
                            product: products[index],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // GREEN CURVED HEADER
  Widget _buildHeader(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [deepGreen, green],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Row(
            children: [
              if (canPop) ...[
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      height: 44,
                      width: 44,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: darkText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Wishlist",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Your favourite grocery items",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 65,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 18),
            Text(
              "Unable to load wishlist",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              "Please check your internet connection\nand try again.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 125,
              height: 125,
              decoration: const BoxDecoration(
                color: lightGreen,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    size: 65,
                    color: green,
                  ),
                  Positioned(
                    right: 27,
                    top: 25,
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: Colors.red.shade300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Your Wishlist is Empty",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Save your favourite grocery items here\n"
                  "and easily find them whenever you need.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.6,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}