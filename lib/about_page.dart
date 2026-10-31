import 'package:flutter/material.dart';
import 'widgets.dart';
import 'l10n.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFC9A66B);
    const values = [
      (Icons.verified, 'Quality products', 'Carefully selected items you can trust.'),
      (Icons.local_shipping, 'Fast delivery', 'Quick, tracked delivery to your door.'),
      (Icons.replay, 'Easy returns', 'Not happy? Return within 30 days.'),
      (Icons.lock, 'Secure shopping', 'Your account and data stay protected.'),
    ];
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        Hdr(tr('About Zariyah'), 'Your trusted online store', Icons.storefront, gold),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Image.asset('assets/images/logo.jpg', height: 110, fit: BoxFit.contain)),
            const SizedBox(height: 16),
            const Text('Our story', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Zariyah (ذریعہ) means "a way" or "a means". We built it to be a simple, dependable way to find what you need, from fashion and tech to home and beauty, and have it delivered with care.', style: TextStyle(height: 1.5)),
            const SizedBox(height: 18),
            const Text('What we stand for', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            for (final v in values)
              Card(child: ListTile(leading: CircleAvatar(backgroundColor: gold.withOpacity(0.2), child: Icon(v.$1, color: gold)), title: Text(v.$2, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(v.$3))),
            const SizedBox(height: 14),
            const Text('Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.email), title: Text('support@zariyah.com')),
            const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.info_outline), title: Text('Version 1.0.0')),
          ]),
        ),
      ]),
    );
  }
}
