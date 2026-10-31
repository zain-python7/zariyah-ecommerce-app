import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (c, _) {
          final list = products.where((p) => shop.wish.contains(p.id)).toList();
          return Scaffold(
            appBar: AppBar(title: const Text('Wishlist')),
            body: list.isEmpty
                ? const Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.favorite_border, size: 90, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Nothing saved yet', style: TextStyle(fontSize: 18)),
                      Text('Tap the heart on any product'),
                    ]),
                  )
                : GridView.count(
                    padding: const EdgeInsets.all(16), crossAxisCount: 2,
                    mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.74,
                    children: [for (var i = 0; i < list.length; i++) ProductCard(list[i], 'wish', i)],
                  ),
          );
        },
      );
}
