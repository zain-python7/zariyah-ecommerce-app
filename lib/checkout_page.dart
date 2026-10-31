import 'package:flutter/material.dart';
import 'data.dart';
import 'forms.dart';
import 'l10n.dart';
import 'success_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutState();
}

class _CheckoutState extends State<CheckoutPage> {
  final name = TextEditingController(text: shop.user == 'Guest' ? '' : shop.user);
  final addr = TextEditingController(), phone = TextEditingController();
  String pay = 'Card';
  final _form = GlobalKey<FormState>();

  InputDecoration _d(String l, IconData i) => InputDecoration(labelText: l, prefixIcon: Icon(i), border: const OutlineInputBorder());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(tr('Checkout'))),
        body: Form(key: _form, autovalidateMode: AutovalidateMode.onUserInteraction, child: ListView(padding: const EdgeInsets.all(16), children: [
          const Text('Delivery address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (shop.addresses.isNotEmpty)
            Wrap(spacing: 8, children: [
              for (final a in shop.addresses)
                ActionChip(
                  avatar: const Icon(Icons.location_on, size: 16), label: Text('${a['name']}'),
                  onPressed: () => setState(() {
                    name.text = a['name'];
                    addr.text = a['line'];
                    phone.text = a['phone'];
                  }),
                ),
            ]),
          const SizedBox(height: 10),
          TextFormField(controller: name, validator: (v) => vRequired(v, 'full name'), decoration: _d('Full name', Icons.person)),
          const SizedBox(height: 10),
          TextFormField(controller: addr, validator: (v) => vRequired(v, 'delivery address'), decoration: _d('Address', Icons.home)),
          const SizedBox(height: 10),
          TextFormField(controller: phone, validator: vPhone, keyboardType: TextInputType.phone, decoration: _d('Phone', Icons.phone)),
          const SizedBox(height: 20),
          const Text('Payment method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(spacing: 8, children: [
            for (final m in const ['Card', 'Cash on delivery', 'Wallet'])
              ChoiceChip(label: Text(m), selected: pay == m, onSelected: (_) => setState(() => pay = m)),
          ]),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Items'), Text('${shop.count}')]),
                if (shop.disc > 0) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Discount (${shop.coupon})'), Text('-${money(shop.disc)}')]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Shipping'), Text(shop.ship == 0 ? 'Free' : money(shop.ship))]),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(money(shop.total), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: () {
              if (!_form.currentState!.validate()) return;
              final o = shop.place();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SuccessPage(o)));
            },
            child: Text(tr('Place order')),
          ),
        ])),
      );
}
