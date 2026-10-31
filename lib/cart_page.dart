import 'package:flutter/material.dart';
import 'data.dart';
import 'l10n.dart';
import 'widgets.dart';
import 'checkout_page.dart';
import 'coupons_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (c, _) {
          final ids = shop.cart.keys.toList();
          return Scaffold(
            appBar: AppBar(title: Text(tr('Cart'))),
            body: ids.isEmpty
                ? const Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Your cart is empty', style: TextStyle(fontSize: 18)),
                      Text('Add something you love!'),
                    ]),
                  )
                : Column(children: [
                    Expanded(
                      child: ListView(padding: const EdgeInsets.all(12), children: [
                        for (var i = 0; i < ids.length; i++)
                          Pop(
                            i: i,
                            child: Dismissible(
                              key: ValueKey(ids[i]),
                              background: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) => shop.setQty(ids[i], 0),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: ListTile(
                                  leading: ProdThumb(shop.p(ids[i])),
                                  title: Text(shop.p(ids[i]).name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  subtitle: Text(money(shop.p(ids[i]).now * shop.cart[ids[i]]!)),
                                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                    IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => shop.setQty(ids[i], shop.cart[ids[i]]! - 1)),
                                    Text('${shop.cart[ids[i]]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => shop.setQty(ids[i], shop.cart[ids[i]]! + 1)),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Theme.of(c).colorScheme.surfaceContainerHighest, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
                      child: Column(children: [
                        _row(tr('Subtotal'), money(shop.sub)),
                        if (shop.disc > 0) _row('Discount (${shop.coupon})', '-${money(shop.disc)}'),
                        ListTile(
                          dense: true, contentPadding: EdgeInsets.zero, leading: const Icon(Icons.local_offer),
                          title: Text(shop.coupon.isEmpty ? 'Apply coupon' : 'Coupon ${shop.coupon} applied'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const CouponsPage())),
                        ),
                        _row(tr('Shipping'), shop.ship == 0 ? tr('Free') : money(shop.ship)),
                        if (shop.ship > 0) Text('Spend ${money(100 - shop.sub)} more for free shipping', style: const TextStyle(fontSize: 12)),
                        const Divider(),
                        _row(tr('Total'), money(shop.total), bold: true),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                            onPressed: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const CheckoutPage())),
                            child: Text(tr('Checkout')),
                          ),
                        ),
                      ]),
                    ),
                  ]),
          );
        },
      );

  Widget _row(String a, String b, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(a, style: TextStyle(fontWeight: bold ? FontWeight.bold : null, fontSize: bold ? 18 : null)),
          Text(b, style: TextStyle(fontWeight: bold ? FontWeight.bold : null, fontSize: bold ? 18 : null)),
        ]),
      );
}
