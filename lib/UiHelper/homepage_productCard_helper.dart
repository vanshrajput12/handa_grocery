import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/pages/productDetail_page.dart';
import '../models/CardItem_model.dart';

class HomePageCardItem extends StatelessWidget {
  final CardItemModel cardItemModel;

  const HomePageCardItem({super.key, required this.cardItemModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: cardItemModel),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- IMAGE ----------------
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),

                    child: Image.asset(
                      cardItemModel.image,
                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ---------------- PRODUCT INFO ----------------
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      cardItemModel.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Description
                    Text(
                      cardItemModel.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const Spacer(),

                    // Price + Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price
                        Text(
                          "₹${cardItemModel.price}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.teal.shade700,
                          ),
                        ),

                        // Add Button
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // Add to cart logic
                            },
                            icon: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
