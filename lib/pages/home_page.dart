import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/UiHelper/homepage_productCard_helper.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/pages/cart_page.dart';
import 'package:handa_grocery/services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productService = ProductService();

  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const amber = Color(0xFFFFB300);
  static const darkText = Color(0xFF25352A);

  final List<String> categories = ["All Grocery", "Rice", "Snacks"];
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: _buildSectionTitle()),
          StreamBuilder<List<CardItemModel>>(
            stream: productService.StreamRice(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(color: green),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No data found")),
                );
              }

              final products = snapshot.data!;

              if (products.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No products found")),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                        HomePageCardItem(cardItemModel: products[index]),
                    childCount: products.length,
                  ),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.74,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // GREEN CURVED HEADER (replaces the yellow app bar)
  Widget _buildHeader() {
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Handa Grocery",
                          style: GoogleFonts.poppins(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Fresh essentials, delivered",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _circleButton(
                    icon: Icons.shopping_cart_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _circleButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      // Your existing notification action
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 54,
                padding: const EdgeInsets.only(left: 18, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search Grocery",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(
                          color: darkText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        color: amber,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          width: 44,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  // CATEGORY CHIPS
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final selected = index == selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => selectedCategory = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? green : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? green : const Color(0xFFE3ECE5),
                  ),
                ),
                child: Text(
                  categories[index],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : darkText,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "You might need",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
          Text(
            "See more",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: green,
            ),
          ),
        ],
      ),
    );
  }
}