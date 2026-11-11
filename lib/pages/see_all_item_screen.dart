import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/UiHelper/homepage_productCard_helper.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/services/product_service.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  static const deepGreen = Color(0xFF14573A);
  static const green = Color(0xFF248A52);
  static const darkText = Color(0xFF25352A);

  final _productService = ProductService();
  late final Stream<List<CardItemModel>> _stream;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _stream = _productService.streamAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: StreamBuilder<List<CardItemModel>>(
        stream: _stream,
        builder: (context, snapshot) {
          final all = snapshot.data ?? [];
          final products = _query.isEmpty
              ? all
              : all
              .where((p) =>
              p.text.toLowerCase().contains(_query.toLowerCase()))
              .toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(all.length)),
              if (snapshot.connectionState == ConnectionState.waiting)
                _message(loading: true)
              else if (snapshot.hasError)
                _message(text: "Error: ${snapshot.error}", isError: true)
              else if (products.isEmpty)
                  _message(
                    text: _query.isEmpty
                        ? "No products available yet"
                        : "No products match \"$_query\"",
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                  ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(int count) {
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
          child: Column(
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        height: 44,
                        width: 44,
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All Products",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "$count items available",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 18),
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
                        onChanged: (v) => setState(() => _query = v.trim()),
                        decoration: InputDecoration(
                          hintText: "Search all products",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _message(
      {String? text, bool loading = false, bool isError = false}) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: loading
              ? const CircularProgressIndicator(color: green)
              : Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isError ? Colors.red : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}