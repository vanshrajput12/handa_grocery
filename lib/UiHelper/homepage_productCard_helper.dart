import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/pages/productDetail_page.dart';
import '../models/CardItem_model.dart';

class HomePageCardItem extends StatelessWidget {
  final CardItemModel cardItemModel;

  const HomePageCardItem({super.key, required this.cardItemModel});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF248A52);
    const lightGreen = Color(0xFFE8F5EC);

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
          border: Border.all(color: const Color(0xFFEDF3EE), width: 1),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF6FAF4),
                    child: Image.asset(
                      cardItemModel.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 38,
                            color: Color(0xFF9EADA0),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Product Information
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
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF25352A),
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Product Description
                    Text(
                      cardItemModel.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFF89958B),
                      ),
                    ),

                    const Spacer(),

                    // Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '₹${cardItemModel.price}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: primaryGreen,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        // Green Add Button
                        Material(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Add to cart logic
                            },
                            child: const SizedBox(
                              height: 36,
                              width: 36,
                              child: Icon(
                                Icons.add_rounded,
                                color: primaryGreen,
                                size: 23,
                              ),
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
