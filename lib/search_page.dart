import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'listing_page.dart';
import 'product_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  final c = TextEditingController();
  String q = '';

  void _go(String v) {
    shop.addRecent(v);
    Navigator.push(context, MaterialPageRoute(builder: (_) => ListingPage(title: '"$v"', query: v)));
  }

  @override
  Widget build(BuildContext context) {
    final res = products.where((p) => p.name.toLowerCase().contains(q.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: c, autofocus: true, textInputAction: TextInputAction.search,
          onChanged: (v) => setState(() => q = v), onSubmitted: _go,
          decoration: const InputDecoration(hintText: 'Search products', border: InputBorder.none),
        ),
        actions: [if (q.isNotEmpty) IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() { c.clear(); q = ''; }))],
      ),
      body: q.isEmpty
          ? ListenableBuilder(
              listenable: shop,
              builder: (_, __) => ListView(padding: const EdgeInsets.all(16), children: [
                if (shop.recent.isNotEmpty) ...[
                  Row(children: [
                    const Text('Recent searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    TextButton(onPressed: shop.clearRecent, child: const Text('Clear')),
                  ]),
                  Wrap(spacing: 8, children: [for (final r in shop.recent) ActionChip(avatar: const Icon(Icons.history, size: 16), label: Text(r), onPressed: () => _go(r))]),
                  const SizedBox(height: 16),
                ],
                const Text('Trending', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, children: [
                  for (final t in const ['Sneakers', 'Earbuds', 'Coffee', 'Yoga', 'Lamp', 'Perfume'])
                    ActionChip(avatar: const Icon(Icons.trending_up, size: 16), label: Text(t), onPressed: () => _go(t)),
                ]),
              ]),
            )
          : ListView(children: [
              if (res.isEmpty) const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('No results'))),
              for (final p in res)
                ListTile(
                  leading: ProdThumb(p, size: 48), title: Text(p.name), subtitle: Text('${p.cat} • ${money(p.now)}'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPage(p, 'srch${p.id}'))),
                ),
            ]),
    );
  }
}
