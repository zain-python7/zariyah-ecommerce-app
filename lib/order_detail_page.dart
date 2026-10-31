import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'help_page.dart';

class OrderDetailPage extends StatelessWidget {
  final Order o;
  const OrderDetailPage(this.o, {super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const icons = [Icons.receipt_long, Icons.inventory_2, Icons.local_shipping, Icons.home];
    const subs = ['We received your order', 'Your items are packed', 'On the way to you', 'Delivered. Enjoy!'];
    final sub = o.items.entries.fold(0.0, (a, e) => a + shop.p(e.key).now * e.value);
    return Scaffold(
      appBar: AppBar(title: Text('Order #${o.id}')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Order tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        for (var s = 0; s < 4; s++)
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Column(children: [
                CircleAvatar(radius: 16, backgroundColor: s <= o.stage ? cs.primary : Colors.grey.shade300, child: Icon(icons[s], size: 16, color: Colors.white)),
                if (s < 3) Expanded(child: Container(width: 2, color: s < o.stage ? cs.primary : Colors.grey.shade300)),
              ]),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(stageNames[s], style: TextStyle(fontWeight: FontWeight.bold, color: s <= o.stage ? null : Colors.grey)),
                  Text(subs[s], style: const TextStyle(fontSize: 12)),
                ]),
              ),
            ]),
          ),
        const Divider(),
        const Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        for (final e in o.items.entries)
          ListTile(
            contentPadding: EdgeInsets.zero, leading: ProdThumb(shop.p(e.key), size: 48),
            title: Text(shop.p(e.key).name), subtitle: Text('Qty ${e.value}'),
            trailing: Text(money(shop.p(e.key).now * e.value)),
          ),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Items subtotal'), Text(money(sub))]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Shipping & discounts'), Text(money(o.total - sub))]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(money(o.total), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ]),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {
            for (final e in o.items.entries) {
              shop.add(e.key, e.value);
            }
            snack(context, 'Items added to your cart');
          },
          icon: const Icon(Icons.replay),
          label: const Text('Reorder'),
        ),
        TextButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpPage())), icon: const Icon(Icons.help_outline), label: const Text('Need help with this order?')),
      ]),
    );
  }
}
