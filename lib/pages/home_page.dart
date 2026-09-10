import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handa_grocery/UiHelper/homePage_CardItem.dart';
import 'package:handa_grocery/models/CardItem_model.dart';
import 'package:handa_grocery/services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productService = ProductService();
  // late final CardItemModel cardItemModel;
  List<String> PList = ["All Grocery", "Rice", "Snacks"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Handa Grocery",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight(700),
              ),
            ),
            Text(
              "Online Shopping",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight(600),
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 24),
        actions: [Icon(Icons.notifications)],
      ),
      backgroundColor: Colors.teal.shade100,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 12),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search Grocery",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 1.2),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            StreamBuilder<List<CardItemModel>>(
              stream: productService.StreamRice(),
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                // Error
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

                // No data
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text("No data found")),
                  );
                }

                final List<CardItemModel> riceProducts = snapshot.data!;

                // Empty list
                if (riceProducts.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text("No rice products found")),
                  );
                }

                // Product Grid
                return SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final rice = riceProducts[index];
                      return HomePageCardItem(cardItemModel: rice);
                    }, childCount: riceProducts.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
