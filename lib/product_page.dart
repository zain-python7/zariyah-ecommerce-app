import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';

const _swatches = [Color(0xFF212121), Color(0xFF1E6FBF), Color(0xFFC62828), Color(0xFF2E8B57)];
const _revs = [
  ('Aisha K.', 5, 'Absolutely love it! Great quality and fast delivery.'),
  ('Daniel R.', 4, 'Good value for the price. Would buy again.'),
  ('Sara M.', 5, 'Exactly as described. Highly recommended!'),
];

class ProductPage extends StatefulWidget {
  final Product p;
  final String tag;
  const ProductPage(this.p, this.tag, {super.key});
  @override
  State<ProductPage> createState() => _ProductState();
}

class _ProductState extends State<ProductPage> {
  int qty = 1, img = 0, color = 0;
  final pc = PageController();

  @override
  void initState() {
    super.initState();
    shop.view(widget.p.id);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final top = MediaQuery.of(context).padding.top + 8;
    final related = products.where((x) => x.cat == p.cat && x.id != p.id).take(4).toList();
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: 340,
          child: Stack(children: [
            PageView(
              controller: pc, onPageChanged: (i) => setState(() => img = i),
              children: [for (var i = 0; i < 3; i++) i == 0 ? ProductImage(p, widget.tag, 130) : Img(p, i, 100)],
            ),
            Positioned(top: top, left: 12, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)))),
            Positioned(
              top: top, right: 12,
              child: ListenableBuilder(
                listenable: shop,
                builder: (_, __) => CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(icon: Icon(shop.wish.contains(p.id) ? Icons.favorite : Icons.favorite_border, color: Colors.red), onPressed: () => shop.toggleWish(p.id)),
                ),
              ),
            ),
            Positioned(
              bottom: 12, left: 0, right: 0,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < 3; i++)
                  AnimatedContainer(duration: const Duration(milliseconds: 250), margin: const EdgeInsets.all(3), width: img == i ? 22 : 8, height: 8, decoration: BoxDecoration(color: img == i ? Colors.white : Colors.white54, borderRadius: BorderRadius.circular(4))),
              ]),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(p.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))), Chip(label: Text(p.cat))]),
            Row(children: [const Icon(Icons.star, color: Colors.amber, size: 18), Text(' ${p.rating}  (128 reviews)')]),
            const SizedBox(height: 10),
            Row(children: [
              Text(money(p.now), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              if (p.off > 0) ...[
                const SizedBox(width: 8),
                Text(money(p.price), style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)),
                const SizedBox(width: 8),
                Chip(label: Text('-${p.off}%'), backgroundColor: Colors.red.shade100),
              ],
            ]),
            const SizedBox(height: 8),
            Text(p.desc),
            const SizedBox(height: 14),
            Row(children: [
              const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              for (var i = 0; i < _swatches.length; i++)
                GestureDetector(
                  onTap: () => setState(() => color = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10), width: 30, height: 30,
                    decoration: BoxDecoration(color: _swatches[i], shape: BoxShape.circle, border: Border.all(color: color == i ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 3)),
                  ),
                ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton.filledTonal(onPressed: qty > 1 ? () => setState(() => qty--) : null, icon: const Icon(Icons.remove)),
              SizedBox(width: 40, child: Center(child: Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
              IconButton.filledTonal(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
            ]),
            const Wrap(spacing: 8, children: [
              Chip(avatar: Icon(Icons.local_shipping, size: 16), label: Text('Fast delivery')),
              Chip(avatar: Icon(Icons.replay, size: 16), label: Text('Free returns')),
              Chip(avatar: Icon(Icons.lock, size: 16), label: Text('Secure payment')),
            ]),
            const SizedBox(height: 16),
            const Text('Customer reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (final r in _revs)
              Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(r.$1[0])),
                  title: Row(children: [Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w600)), const Spacer(), for (var s = 0; s < 5; s++) Icon(Icons.star, size: 14, color: s < r.$2 ? Colors.amber : Colors.grey.shade300)]),
                  subtitle: Text(r.$3),
                ),
              ),
            if (related.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('You may also like', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 215,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  for (var i = 0; i < related.length; i++) Padding(padding: const EdgeInsets.only(right: 12), child: SizedBox(width: 150, child: ProductCard(related[i], 'rel${p.id}', i))),
                ]),
              ),
            ],
          ]),
        ),
      ]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: () {
              shop.add(p.id, qty);
              snack(context, '${p.name} added to cart');
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('Add to cart • ${money(p.now * qty)}'),
          ),
        ),
      ),
    );
  }
}
