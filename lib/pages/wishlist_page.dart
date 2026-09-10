import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/UiHelper/Wishlist_productCard_helper.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/services/wishlist_service.dart';

class WishlistPage extends StatelessWidget {
  WishlistPage({super.key});
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF9),
      appBar: AppBar(
        backgroundColor: Colors.teal.shade100,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Wishlist",
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            Text(
              "Your favorite grocery items",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),

      body: StreamBuilder<List<CardItemModel>>(
        stream: _wishlistService.getWishlist(),
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          // error
          if (snapshot.hasError) {
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
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "Please check your internet connection\n"
                      "and try again.",
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

          // empty
          if (products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heart circle
                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 65,
                            color: Colors.teal.shade400,
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
                        color: const Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Save your favorite grocery items here\n"
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
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${products.length} ${products.length == 1 ? "Item" : "Items"}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Tap ❤️ to remove",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 25),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.67,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return WishlistProductCardHelper(product: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
