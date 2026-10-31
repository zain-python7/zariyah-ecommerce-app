import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotifState();
}

class _NotifState extends State<NotificationsPage> {
  bool read = false;
  final items = <(IconData, Color, String, String, String)>[
    (Icons.local_shipping, const Color(0xFF1E6FBF), 'Order shipped', 'Your order is on the way.', '2h ago'),
    (Icons.local_offer, const Color(0xFFE65100), 'Flash sale started', 'Up to 25% off on selected items.', '5h ago'),
    (Icons.trending_down, const Color(0xFF2E8B57), 'Price drop', 'An item in your wishlist is cheaper now.', 'Yesterday'),
    (Icons.new_releases, const Color(0xFF7B1FA2), 'New arrivals', 'Fresh products just landed.', '2 days ago'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Notifications'), actions: [TextButton(onPressed: () => setState(() => read = true), child: const Text('Mark all read'))]),
        body: items.isEmpty
            ? const Center(child: Text('You are all caught up!'))
            : ListView(children: [
                for (final n in items)
                  Dismissible(
                    key: ObjectKey(n),
                    onDismissed: (_) => setState(() => items.remove(n)),
                    background: Container(color: Colors.red),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: n.$2, child: Icon(n.$1, color: Colors.white)),
                      title: Text(n.$3, style: TextStyle(fontWeight: read ? null : FontWeight.bold)),
                      subtitle: Text(n.$4),
                      trailing: Text(n.$5, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
              ]),
      );
}
