import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/pages/productDetail_page.dart';
import '../services/wishlist_service.dart';

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

        title: Text(
          "My Wishlist",
          style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w700),
        ),
      ),

      body: StreamBuilder<List<CardItemModel>>(
        stream: _wishlistService.getWishlist(),

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];

          // Empty Wishlist
          if (products.isEmpty) {
            return _emptyWishlist();
          }

          // Wishlist Products
          return GridView.builder(
            padding: const EdgeInsets.all(16),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),

            itemCount: products.length,

            itemBuilder: (context, index) {
              final product = products[index];

              return _wishlistCard(context, product);
            },
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // WISHLIST CARD
  // ---------------------------------------------------------

  Widget _wishlistCard(BuildContext context, CardItemModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------
            // IMAGE
            // ---------------------------------------------------
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,

                    margin: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Image.asset(
                        product.image,
                        fit: BoxFit.contain,

                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: Colors.teal.shade300,
                          );
                        },
                      ),
                    ),
                  ),

                  // Heart
                  Positioned(
                    top: 14,
                    right: 14,

                    child: GestureDetector(
                      onTap: () async {
                        await _wishlistService.removeFromWishlist(product.text);
                      },

                      child: Container(
                        width: 38,
                        height: 38,

                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------------------------------------------
            // PRODUCT INFO
            // ---------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "₹${product.price}",

                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.teal.shade700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color: Colors.red.shade400,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "Wishlisted",
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
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // EMPTY WISHLIST
  // ---------------------------------------------------------

  Widget _emptyWishlist() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.favorite_border_rounded,
                size: 55,
                color: Colors.teal.shade400,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              "Your Wishlist is Empty",
              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Save your favorite grocery items here\nand find them easily later.",
              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
