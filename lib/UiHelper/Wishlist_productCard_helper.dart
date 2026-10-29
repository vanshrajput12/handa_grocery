import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/services/wishlist_service.dart';

import '../Widgets.dart';
import '../models/CardItem_model.dart';
import '../pages/productDetail_page.dart';

class WishlistProductCardHelper extends StatefulWidget {
  final CardItemModel product;

  const WishlistProductCardHelper({super.key, required this.product});

  @override
  State<WishlistProductCardHelper> createState() =>
      _WishlistProductCardHelperState();
}

class _WishlistProductCardHelperState extends State<WishlistProductCardHelper> {
  final WishlistService _wishlistService = WishlistService();

  static const green = Color(0xFF248A52);
  static const darkText = Color(0xFF25352A);

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEDF3EE)),
          boxShadow: [
            BoxShadow(
              color: green.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6FAF4),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Hero(
                        tag: product.text,
                        child: ProductImage(path: product.image, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  // REMOVE FROM WISHLIST
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Material(
                      color: Colors.white,
                      elevation: 3,
                      shadowColor: green.withValues(alpha: 0.2),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async {
                          await _removeWishlist(context, product);
                        },
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.favorite_rounded,
                            color: Colors.redAccent,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PRODUCT INFORMATION
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
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${product.price}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: green,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.bookmark_added_outlined,
                        size: 13,
                        color: green,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Saved",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
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

  Future<void> _removeWishlist(
      BuildContext context,
      CardItemModel product,
      ) async {
    try {
      await _wishlistService.removeFromWishlist(product.text);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${product.text} removed from wishlist",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Unable to remove item"),
          backgroundColor: green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
  }
}