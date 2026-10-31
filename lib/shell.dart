import 'package:flutter/material.dart';
import 'data.dart';
import 'l10n.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'wishlist_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (_, __) => Scaffold(
          body: IndexedStack(index: i, children: const [HomePage(), CategoriesPage(), WishlistPage(), CartPage(), ProfilePage()]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: i,
            onDestinationSelected: (x) => setState(() => i = x),
            destinations: [
              NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr('Home')),
              NavigationDestination(icon: const Icon(Icons.grid_view), selectedIcon: const Icon(Icons.grid_view_rounded), label: tr('Shop')),
              NavigationDestination(icon: Badge(isLabelVisible: shop.wish.isNotEmpty, label: Text('${shop.wish.length}'), child: const Icon(Icons.favorite_border)), selectedIcon: const Icon(Icons.favorite), label: tr('Wishlist')),
              NavigationDestination(icon: Badge(isLabelVisible: shop.count > 0, label: Text('${shop.count}'), child: const Icon(Icons.shopping_cart_outlined)), selectedIcon: const Icon(Icons.shopping_cart), label: tr('Cart')),
              NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: tr('Profile')),
            ],
          ),
        ),
      );
}
