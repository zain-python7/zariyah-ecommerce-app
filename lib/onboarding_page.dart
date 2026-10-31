import 'package:flutter/material.dart';
import 'data.dart';
import 'login_page.dart';

const _slides = [
  (Icons.shopping_bag, 'Discover products', 'Thousands of items from top brands, all in one place.'),
  (Icons.local_shipping, 'Fast delivery', 'Track every order from checkout to your door.'),
  (Icons.local_offer, 'Great deals', 'Coupons and flash sales every single day.'),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnState();
}

class _OnState extends State<OnboardingPage> {
  final pc = PageController();
  int i = 0;
  void _done() {
    shop.setSeen();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _done, child: const Text('Skip'))),
          Expanded(
            child: PageView(
              controller: pc, onPageChanged: (x) => setState(() => i = x),
              children: [
                for (final s in _slides)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      CircleAvatar(radius: 90, backgroundColor: cs.primaryContainer, child: Icon(s.$1, size: 90, color: cs.primary)),
                      const SizedBox(height: 32),
                      Text(s.$2, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(s.$3, textAlign: TextAlign.center),
                    ]),
                  ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var k = 0; k < 3; k++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4), width: i == k ? 24 : 8, height: 8,
                decoration: BoxDecoration(color: i == k ? cs.primary : Colors.grey.shade400, borderRadius: BorderRadius.circular(4)),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: () => i == 2 ? _done() : pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                child: Text(i == 2 ? 'Get started' : 'Next'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
