import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final CardItemModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final WishlistService _wishlistService = WishlistService();

  static const green = Color(0xFF248A52);
  static const deepGreen = Color(0xFF14573A);
  static const lightGreen = Color(0xFFEAF6ED);
  static const darkText = Color(0xFF25352A);
  static const amberSoft = Color(0xFFFFF4D6);
  static const amberText = Color(0xFF9A6B00);

  bool isWishlisted = false;
  bool isLoadingWishlist = true;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  Future<void> _checkWishlist() async {
    try {
      final result = await _wishlistService.isWishlisted(widget.product.text);
      if (!mounted) return;
      setState(() {
        isWishlisted = result;
        isLoadingWishlist = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoadingWishlist = false);
    }
  }

  Future<void> _toggleWishlist() async {
    if (isLoadingWishlist) return;

    try {
      if (isWishlisted) {
        await _wishlistService.removeFromWishlist(widget.product.text);
      } else {
        await _wishlistService.addToWishlist(widget.product);
      }

      if (!mounted) return;
      setState(() => isWishlisted = !isWishlisted);

      _showMessage(
        isWishlisted ? 'Added to your wishlist' : 'Removed from your wishlist',
        icon: isWishlisted
            ? Icons.favorite_rounded
            : Icons.favorite_border_rounded,
      );
    } catch (_) {
      if (!mounted) return;
      _showMessage(
        'Could not update wishlist. Please try again.',
        icon: Icons.error_outline_rounded,
      );
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
              child: Text(message, style: GoogleFonts.poppins(fontSize: 12)),
            ),
          ],
        ),
        backgroundColor: green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  double get _unitPrice {
    return double.tryParse(
      widget.product.price.replaceAll(RegExp(r'[^0-9.]'), ''),
    ) ??
        0;
  }

  String _formatPrice(double price) {
    return price == price.roundToDouble()
        ? price.toStringAsFixed(0)
        : price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: Stack(
        children: [
          // GREEN CURVED HEADER BACKGROUND
          Container(
            height: 250,
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
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      _circleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        iconSize: 18,
                        iconColor: darkText,
                        onTap: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Product Details',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _circleButton(
                        icon: isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconSize: 21,
                        iconColor: isWishlisted ? Colors.redAccent : green,
                        onTap: _toggleWishlist,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageCard(product),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.text,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: darkText,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: lightGreen,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: green,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Available',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.shopping_basket_outlined,
                                    color: Colors.grey.shade500,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Daily essentials',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // PRICE
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${_formatPrice(_unitPrice)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 29,
                                      fontWeight: FontWeight.w800,
                                      color: green,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Text(
                                      'per item',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 22),

                              _sectionCard(
                                icon: Icons.info_outline_rounded,
                                title: 'About this product',
                                child: Text(
                                  product.description.isNotEmpty
                                      ? product.description
                                      : 'A convenient grocery essential for '
                                      'your everyday kitchen needs.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    height: 1.8,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              _sectionCard(
                                icon: Icons.verified_user_outlined,
                                title: 'Why shop with Handa Grocery?',
                                child: Column(
                                  children: [
                                    _benefitRow(
                                      Icons.shopping_bag_outlined,
                                      'Everyday essentials',
                                      'Find products for your daily needs.',
                                    ),
                                    const SizedBox(height: 16),
                                    _benefitRow(
                                      Icons.local_shipping_outlined,
                                      'Convenient shopping',
                                      'Order from home with ease.',
                                    ),
                                    const SizedBox(height: 16),
                                    _benefitRow(
                                      Icons.favorite_border_rounded,
                                      'Save your favourites',
                                      'Keep products handy in your wishlist.',
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 22),

                              // QUANTITY
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Select Quantity',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: darkText,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Choose how many you need',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFDDE9DE),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        _quantityButton(
                                          icon: Icons.remove_rounded,
                                          onTap: () {
                                            if (quantity > 1) {
                                              setState(() => quantity--);
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width: 32,
                                          child: Center(
                                            child: Text(
                                              '$quantity',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: darkText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        _quantityButton(
                                          icon: Icons.add_rounded,
                                          onTap: () =>
                                              setState(() => quantity++),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 22),

                              // DELIVERY INFO
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: lightGreen,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFD7EBDD),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 46,
                                      width: 46,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.local_shipping_outlined,
                                        color: green,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 13),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Delivery to your doorstep',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: darkText,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Delivery availability and timing '
                                                'depend on your location.',
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              height: 1.5,
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
                ),
              ],
            ),
          ),
        ],
      ),

      // FIXED BOTTOM CART BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFEDF1ED))),
          boxShadow: [
            BoxShadow(
              color: green.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL PRICE',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${_formatPrice(_unitPrice * quantity)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_unitPrice <= 0) {
                        _showMessage(
                          'This product has an invalid price.',
                          icon: Icons.error_outline_rounded,
                        );
                        return;
                      }

                      CartService().addToCart(product, quantity: quantity);

                      _showMessage(
                        '${product.text} added to cart',
                        icon: Icons.shopping_cart_rounded,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 19),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Add to Cart',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }

  // IMAGE CARD (floats over the green header)
  Widget _buildImageCard(CardItemModel product) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: deepGreen.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: amberSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco_outlined, size: 16, color: amberText),
                    const SizedBox(width: 5),
                    Text(
                      'Fresh Grocery',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: amberText,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.verified_outlined,
                color: green.withValues(alpha: 0.8),
                size: 21,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Hero(
                tag: product.text,
                child: Image.asset(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 65,
                        color: Color(0xFFB6C8B9),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: green, size: 16),
              const SizedBox(width: 6),
              Text(
                'A fresh choice for your daily needs',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color iconColor,
    double iconSize = 20,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          width: 44,
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFEDF1ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: green, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _benefitRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: green, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          height: 40,
          width: 38,
          child: Icon(icon, size: 19, color: green),
        ),
      ),
    );
  }
}