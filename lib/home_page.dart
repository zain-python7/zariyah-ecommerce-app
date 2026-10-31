import 'dart:async';
import 'package:flutter/material.dart';
import 'data.dart';
import 'l10n.dart';
import 'widgets.dart';
import 'search_page.dart';
import 'notifications_page.dart';
import 'categories_page.dart';
import 'deals_page.dart';
import 'orders_page.dart';
import 'coupons_page.dart';
import 'listing_page.dart';

const _banners = [
  ('Summer Sale', 'Up to 25% off', Color(0xFFC9A66B), Icons.local_offer),
  ('New in Tech', 'Latest gadgets', Color(0xFF00838F), Icons.devices),
  ('Free Shipping', 'On orders over \$100', Color(0xFFE65100), Icons.local_shipping),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  String cat = 'All';
  final pc = PageController(viewportFraction: 0.92);
  int page = 0;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 4), (_) {
      if (pc.hasClients) pc.animateToPage((page + 1) % _banners.length, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  void _go(Widget w) => Navigator.push(context, MaterialPageRoute(builder: (_) => w));

  Widget _sec(String title, [VoidCallback? more]) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Row(children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (more != null) TextButton(onPressed: more, child: Text(tr('See all'))),
        ]),
      );

  Widget _row(List<Product> l, String from) => SizedBox(
        height: 215,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (var i = 0; i < l.length; i++) Padding(padding: const EdgeInsets.only(right: 12), child: SizedBox(width: 150, child: ProductCard(l[i], from, i))),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final list = products.where((p) => cat == 'All' || p.cat == cat).toList();
    return ListenableBuilder(
      listenable: shop,
      builder: (c, _) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${tr('Hello')}, ${shop.user}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(tr('Find something you love')),
                ]),
              ),
              IconButton.filledTonal(onPressed: () => _go(const NotificationsPage()), icon: const Icon(Icons.notifications_none)),
            ]),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => _go(const SearchPage()),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Theme.of(c).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(30)),
                child: Row(children: [const Icon(Icons.search), const SizedBox(width: 10), Text(tr('Search products'))]),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 150,
              child: PageView(controller: pc, onPageChanged: (i) => page = i, children: [
                for (final b in _banners)
                  Container(
                    margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.all(20), decoration: grad(b.$3, 24),
                    child: Row(children: [
                      Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(b.$1, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(b.$2, style: const TextStyle(color: Colors.white70)),
                        ]),
                      ),
                      Icon(b.$4, size: 70, color: Colors.white38),
                    ]),
                  ),
              ]),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              for (final q in <(String, IconData, Color, Widget)>[
                ('Categories', Icons.grid_view, const Color(0xFF1E6FBF), const CategoriesPage()),
                ('Deals', Icons.flash_on, const Color(0xFFE53935), const DealsPage()),
                ('Orders', Icons.receipt_long, const Color(0xFF2E8B57), const OrdersPage()),
                ('Coupons', Icons.local_offer, const Color(0xFFE65100), const CouponsPage()),
              ])
                InkWell(
                  onTap: () => _go(q.$4),
                  child: Column(children: [
                    CircleAvatar(radius: 26, backgroundColor: q.$3.withOpacity(0.15), child: Icon(q.$2, color: q.$3)),
                    const SizedBox(height: 4),
                    Text(tr(q.$1), style: const TextStyle(fontSize: 12)),
                  ]),
                ),
            ]),
            _sec(tr('Flash deals'), () => _go(const DealsPage())),
            _row(products.where((p) => p.off > 0).toList(), 'fd'),
            _sec(tr('Shop by category')),
            SizedBox(
              height: 44,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final k in cats) Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(k), selected: cat == k, onSelected: (_) => setState(() => cat = k))),
              ]),
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.74,
              children: [for (var i = 0; i < list.length; i++) ProductCard(list[i], 'home', i)],
            ),
            if (shop.viewed.isNotEmpty) ...[
              _sec(tr('Recently viewed')),
              _row([for (final id in shop.viewed) shop.p(id)], 'rv'),
            ],
            _sec(tr('Top rated'), () => _go(const ListingPage(title: 'Top rated'))),
            _row((products.toList()..sort((a, b) => b.rating.compareTo(a.rating))).take(5).toList(), 'tr'),
          ]),
        ),
      ),
    );
  }
}
