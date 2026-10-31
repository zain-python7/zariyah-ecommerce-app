import 'dart:async';
import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});
  @override
  State<DealsPage> createState() => _DealsState();
}

class _DealsState extends State<DealsPage> {
  Timer? t;
  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = DateTime.now();
    final left = DateTime(n.year, n.month, n.day, 23, 59, 59).difference(n);
    String two(int v) => v.toString().padLeft(2, '0');
    Widget box(String v, String l) => Container(
          margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
            Text(l, style: const TextStyle(fontSize: 10, color: Colors.black54)),
          ]),
        );
    final deals = products.where((p) => p.off > 0).toList();
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        Hdr('Flash Deals', 'Hurry, offers end today!', Icons.flash_on, const Color(0xFFE53935),
            extra: Row(children: [box(two(left.inHours), 'HOURS'), box(two(left.inMinutes % 60), 'MIN'), box(two(left.inSeconds % 60), 'SEC')])),
        GridView.count(
          padding: const EdgeInsets.all(16), crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.74,
          children: [for (var i = 0; i < deals.length; i++) ProductCard(deals[i], 'deal', i)],
        ),
      ]),
    );
  }
}
