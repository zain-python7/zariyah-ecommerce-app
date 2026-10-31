import 'package:flutter/material.dart';
import 'data.dart';
import 'orders_page.dart';

class SuccessPage extends StatelessWidget {
  final Order o;
  const SuccessPage(this.o, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder: (_, v, __) => Transform.scale(
                  scale: v,
                  child: const CircleAvatar(radius: 60, backgroundColor: Color(0xFF2E8B57), child: Icon(Icons.check, size: 70, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Order placed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('Order #${o.id} • ${money(o.total)}'),
              const Text('Estimated delivery: 3 to 5 days'),
              const SizedBox(height: 24),
              FilledButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrdersPage())),
                  child: const Text('Track my order')),
              TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('Continue shopping')),
            ]),
          ),
        ),
      );
}
