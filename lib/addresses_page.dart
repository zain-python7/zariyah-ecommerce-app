import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'forms.dart';
import 'l10n.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  void _add(BuildContext c) {
    final f = GlobalKey<FormState>();
    final n = TextEditingController(), l = TextEditingController(), p = TextEditingController();
    showModalBottomSheet(
      context: c, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Form(
            key: f,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('New address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              TextFormField(controller: n, validator: (v) => vRequired(v, 'address label'), decoration: deco('Label (Home, Work...)', Icons.label)),
              const SizedBox(height: 12),
              TextFormField(controller: l, validator: (v) => vRequired(v, 'full address'), decoration: deco('Full address', Icons.home)),
              const SizedBox(height: 12),
              TextFormField(controller: p, keyboardType: TextInputType.phone, validator: vPhone, decoration: deco(tr('Phone'), Icons.phone)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (!f.currentState!.validate()) return;
                    shop.addAddress(n.text.trim(), l.text.trim(), p.text.trim());
                    Navigator.pop(ctx);
                  },
                  child: Text(tr('Save')),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (c, _) => Scaffold(
          appBar: AppBar(title: Text(tr('Addresses'))),
          floatingActionButton: FloatingActionButton.extended(onPressed: () => _add(c), icon: const Icon(Icons.add), label: const Text('Add address')),
          body: shop.addresses.isEmpty
              ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.location_off, size: 80, color: Colors.grey), SizedBox(height: 10), Text('No saved addresses')]))
              : ListView(padding: const EdgeInsets.all(12), children: [
                  for (var i = 0; i < shop.addresses.length; i++)
                    Pop(
                      i: i,
                      child: Card(
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.location_on)),
                          title: Text('${shop.addresses[i]['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${shop.addresses[i]['line']}\n${shop.addresses[i]['phone']}'),
                          isThreeLine: true,
                          trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => shop.delAddress(shop.addresses[i]['id'])),
                        ),
                      ),
                    ),
                ]),
        ),
      );
}
