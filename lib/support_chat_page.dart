import 'package:flutter/material.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key});
  @override
  State<SupportChatPage> createState() => _ChatState();
}

class _ChatState extends State<SupportChatPage> {
  final msgs = <(bool, String)>[(false, 'Hi! I am the Zariyah assistant. How can I help you today?')];
  final c = TextEditingController();
  final sc = ScrollController();

  String _reply(String q) {
    final s = q.toLowerCase();
    if (s.contains('order') || s.contains('track')) return 'You can follow your order from Profile > My orders. Tap an order to see its tracking.';
    if (s.contains('return') || s.contains('refund')) return 'Returns are accepted within 30 days. Open your order and tap Need help to start a return.';
    if (s.contains('pay')) return 'We accept card, cash on delivery and wallet.';
    if (s.contains('coupon') || s.contains('discount')) return 'Open your cart and tap Apply coupon to see the available codes.';
    if (s.contains('deliver') || s.contains('ship')) return 'Delivery takes 3 to 5 business days. Shipping is free over \$100.';
    return 'Thanks for your message! For anything else, please email support@zariyah.com and our team will help you.';
  }

  void _down() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (sc.hasClients) sc.animateTo(sc.position.maxScrollExtent + 80, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      });

  void _send() {
    final t = c.text.trim();
    if (t.isEmpty) return;
    setState(() => msgs.add((true, t)));
    c.clear();
    _down();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => msgs.add((false, _reply(t))));
      _down();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Live chat')),
      body: Column(children: [
        Expanded(
          child: ListView(controller: sc, padding: const EdgeInsets.all(12), children: [
            for (final m in msgs)
              Align(
                alignment: m.$1 ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: m.$1 ? cs.primary : cs.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
                  child: Text(m.$2, style: TextStyle(color: m.$1 ? cs.onPrimary : null)),
                ),
              ),
          ]),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(children: [
              Expanded(child: TextField(controller: c, onSubmitted: (_) => _send(), decoration: InputDecoration(hintText: 'Type your message', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))))),
              const SizedBox(width: 8),
              IconButton.filled(onPressed: _send, icon: const Icon(Icons.send)),
            ]),
          ),
        ),
      ]),
    );
  }
}
