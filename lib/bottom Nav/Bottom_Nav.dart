import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:handa_grocery/pages/home_page.dart';
import 'package:handa_grocery/pages/order_detail.dart';
import 'package:handa_grocery/pages/profile_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  final List<Widget> pages = const [HomePage(), OrderDetail(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.teal.shade100,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: currentIndex,
        indicatorColor: Colors.white,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            selectedColor: Colors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.shopping_cart,
            selectedColor: Colors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.person,
            selectedColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
