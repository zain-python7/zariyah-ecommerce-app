import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'order_detail_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: shop.orders.isEmpty
            ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.receipt_long, size: 80, color: Colors.grey), SizedBox(height: 10), Text('No orders yet. Time to shop!')]))
            : ListView(padding: const EdgeInsets.all(12), children: [
                for (var i = 0; i < shop.orders.length; i++)
                  Pop(
                    i: i,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailPage(shop.orders[i]))),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Text('Order #${shop.orders[i].id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const Spacer(),
                              Chip(label: Text(stageNames[shop.orders[i].stage])),
                            ]),
                            Text('${shop.orders[i].date.day}/${shop.orders[i].date.month}/${shop.orders[i].date.year}'),
                            const SizedBox(height: 8),
                            Row(children: [for (final id in shop.orders[i].items.keys.take(4)) Padding(padding: const EdgeInsets.only(right: 6), child: ProdThumb(shop.p(id), size: 44))]),
                            const Divider(),
                            Row(children: [
                              Text('${shop.orders[i].items.values.fold(0, (a, b) => a + b)} items'),
                              const Spacer(),
                              Text(money(shop.orders[i].total), style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Icon(Icons.chevron_right),
                            ]),
                          ]),
                        ),
                      ),
                    ),
                  ),
              ]),
      );
}
