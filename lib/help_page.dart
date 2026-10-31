import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets.dart';
import 'support_chat_page.dart';

const _faq = [
  ('How long does delivery take?', 'Most orders arrive in 3 to 5 business days.'),
  ('How do I return an item?', 'Open your order, tap Need help, and request a return within 30 days.'),
  ('Which payment methods do you accept?', 'Card, cash on delivery and wallet.'),
  ('How do I use a coupon?', 'Open your cart, tap Apply coupon, and choose a code.'),
  ('Is shipping free?', 'Yes, on orders over \$100 or with the FREESHIP coupon.'),
];

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: [
          const Hdr('Help Center', 'We are here for you', Icons.support_agent, Color(0xFF00838F)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Frequently asked', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              for (final f in _faq) Card(child: ExpansionTile(title: Text(f.$1), childrenPadding: const EdgeInsets.all(16), expandedAlignment: Alignment.centerLeft, children: [Text(f.$2)])),
              const SizedBox(height: 16),
              const Text('Contact us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Card(child: ListTile(leading: const Icon(Icons.chat), title: const Text('Live chat'), subtitle: const Text('Ask our assistant'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportChatPage())))),
              Card(child: ListTile(leading: const Icon(Icons.email), title: const Text('support@zariyah.com'), trailing: const Icon(Icons.copy, size: 18), onTap: () { Clipboard.setData(const ClipboardData(text: 'support@zariyah.com')); snack(context, 'Email address copied'); })),
              Card(child: ListTile(leading: const Icon(Icons.phone), title: const Text('+1 800 123 4567'), trailing: const Icon(Icons.copy, size: 18), onTap: () { Clipboard.setData(const ClipboardData(text: '+1 800 123 4567')); snack(context, 'Phone number copied'); })),
            ]),
          ),
        ]),
      );
}
