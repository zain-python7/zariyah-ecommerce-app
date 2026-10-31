import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});
  @override
  State<CouponsPage> createState() => _CouponsState();
}

class _CouponsState extends State<CouponsPage> {
  final c = TextEditingController();
  void _apply(String code) {
    code = code.trim().toUpperCase();
    if (!coupons.containsKey(code)) return snack(context, 'Invalid coupon code');
    shop.setCoupon(code);
    snack(context, '$code applied');
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (_, __) => Scaffold(
          body: ListView(padding: EdgeInsets.zero, children: [
            const Hdr('Coupons', 'Save more on every order', Icons.local_offer, Color(0xFFE65100)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(children: [
                  Expanded(child: TextField(controller: c, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'Enter coupon code', border: OutlineInputBorder()))),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: () => _apply(c.text), child: const Text('Apply')),
                ]),
                const SizedBox(height: 12),
                for (final e in coupons.entries)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.confirmation_number, color: Color(0xFFE65100)),
                      title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(e.value),
                      trailing: shop.coupon == e.key
                          ? TextButton(onPressed: () => shop.setCoupon(''), child: const Text('Remove'))
                          : FilledButton.tonal(onPressed: () => _apply(e.key), child: const Text('Apply')),
                    ),
                  ),
              ]),
            ),
          ]),
        ),
      );
}
