import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import '../services/wishlist_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final CardItemModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final WishlistService _wishlistService = WishlistService();

  bool isWishlisted = false;
  bool isLoadingWishlist = true;

  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  // ---------------------------------------------------------------------------
  // CHECK IF PRODUCT IS ALREADY IN WISHLIST
  // ---------------------------------------------------------------------------

  Future<void> _checkWishlist() async {
    try {
      final result = await _wishlistService.isWishlisted(widget.product.text);

      if (!mounted) return;

      setState(() {
        isWishlisted = result;
        isLoadingWishlist = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingWishlist = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // ADD / REMOVE WISHLIST
  // ---------------------------------------------------------------------------

  Future<void> _toggleWishlist() async {
    try {
      if (isWishlisted) {
        // REMOVE FROM WISHLIST
        await _wishlistService.removeFromWishlist(widget.product.text);

        if (!mounted) return;

        setState(() {
          isWishlisted = false;
        });

        _showMessage(
          "Removed from wishlist",
          icon: Icons.favorite_border_rounded,
        );
      } else {
        // ADD TO WISHLIST
        await _wishlistService.addToWishlist(widget.product);
        if (!mounted) return;
        setState(() {
          isWishlisted = true;
        });

        _showMessage("Added to wishlist ❤️", icon: Icons.favorite_rounded);
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage("Something went wrong", icon: Icons.error_outline_rounded);
    }
  }


  void _showMessage(String message, {required IconData icon}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.teal.shade100,

      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 370,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(35, 45, 35, 20),
                            child: Hero(
                              tag: product.text,
                              child: Image.asset(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      shape: BoxShape.circle,
                                    ),

                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 70,
                                      color: Colors.teal.shade300,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // back arrow
                        Positioned(
                          top: 15,
                          left: 18,
                          child: _circleButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        // fav icon
                        Positioned(
                          top: 15,
                          right: 18,
                          child: _circleButton(
                            icon: isWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            iconColor: isWishlisted
                                ? Colors.red
                                : Colors.black87,
                            onTap: isLoadingWishlist ? () {} : _toggleWishlist,
                          ),
                        ),
                        // container bottom tag
                        Positioned(
                          left: 22,
                          bottom: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shopping_basket_outlined,
                                  size: 16,
                                  color: Colors.teal.shade700,
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  "Fresh Grocery",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.text,
                          style: GoogleFonts.poppins(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111111),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // -----------------------------------------------------
                        // RATING + STOCK
                        // -----------------------------------------------------
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    "4.8",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green.shade600,
                                    size: 17,
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    "In Stock",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // -----------------------------------------------------
                        // PRICE
                        // -----------------------------------------------------

                            Text(
                              "₹${product.price}",
                              style: GoogleFonts.poppins(
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                                color: Colors.teal.shade700,
                              ),
                            ),


                        const SizedBox(height: 25),

                        // =====================================================
                        // DESCRIPTION CARD
                        // =====================================================
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,

                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.teal.shade700,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Text(
                                    "About this product",

                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Text(
                                product.description,

                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  height: 1.7,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // =====================================================
                        // QUANTITY
                        // =====================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              "Quantity",

                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),

                                border: Border.all(color: Colors.grey.shade200),
                              ),

                              child: Row(
                                children: [
                                  // MINUS
                                  _quantityButton(
                                    icon: Icons.remove_rounded,

                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    },
                                  ),

                                  // NUMBER
                                  SizedBox(
                                    width: 42,

                                    child: Center(
                                      child: Text(
                                        "$quantity",

                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // PLUS
                                  _quantityButton(
                                    icon: Icons.add_rounded,

                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // =====================================================
                        // DELIVERY INFO
                        // =====================================================
                        Container(
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),

                                child: Icon(
                                  Icons.local_shipping_outlined,
                                  color: Colors.teal.shade700,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "Fast Delivery",

                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      "Get your groceries delivered quickly",

                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey.shade700,
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
                ],
              ),
            ),

            // =================================================================
            // BOTTOM ADD TO CART BAR
            // =================================================================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),

                decoration: BoxDecoration(
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    // ---------------------------------------------------------
                    // TOTAL PRICE
                    // ---------------------------------------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text(
                          "Total",

                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        Text(
                          "₹${_totalPrice(product.price)}",

                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 18),

                    // ---------------------------------------------------------
                    // ADD TO CART
                    // ---------------------------------------------------------
                    Expanded(
                      child: SizedBox(
                        height: 55,

                        child: ElevatedButton(
                          onPressed: () {
                            _showMessage(
                              "${product.text} added to cart",
                              icon: Icons.shopping_cart_rounded,
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              const Icon(
                                Icons.shopping_cart_outlined,
                                size: 20,
                              ),

                              const SizedBox(width: 9),

                              Text(
                                "Add to Cart",

                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
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
    );
  }

  // ===========================================================================
  // CIRCLE BUTTON
  // ===========================================================================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      shape: const CircleBorder(),

      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),

        child: SizedBox(
          width: 45,
          height: 45,

          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }

  // ===========================================================================
  // QUANTITY BUTTON
  // ===========================================================================

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),

      child: SizedBox(
        width: 42,
        height: 42,

        child: Icon(icon, size: 19, color: Colors.teal.shade700),
      ),
    );
  }

  // ===========================================================================
  // TOTAL PRICE
  // ===========================================================================

  double _totalPrice(String price) {
    final parsedPrice =
        double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

    return parsedPrice * quantity;
  }
}
