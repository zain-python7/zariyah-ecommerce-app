import 'package:flutter/material.dart';
import 'data.dart';
import 'product_page.dart';

class Pop extends StatelessWidget {
  final int i;
  final Widget child;
  const Pop({super.key, this.i = 0, required this.child});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 450 + i * 70),
        curve: Curves.easeOutCubic,
        builder: (_, v, ch) => Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 30 * (1 - v)), child: ch)),
        child: child,
      );
}

BoxDecoration grad(Color c, [double r = 0]) => BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c, c.withOpacity(0.55)]),
      borderRadius: BorderRadius.circular(r),
    );

void snack(BuildContext c, String m) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

/// Product photo from the internet. The colored icon shows while loading or if there is no internet.
class Img extends StatelessWidget {
  final Product p;
  final int n;
  final double icon;
  const Img(this.p, this.n, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, children: [
        Container(decoration: grad(p.color), child: Center(child: Icon(p.icon, size: icon, color: Colors.white))),
        Image.network(
          p.img(n), fit: BoxFit.cover,
          frameBuilder: (c, child, frame, sync) => AnimatedOpacity(opacity: frame == null ? 0 : 1, duration: const Duration(milliseconds: 400), child: child),
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ]);
}

class ProdThumb extends StatelessWidget {
  final Product p;
  final double size;
  const ProdThumb(this.p, {super.key, this.size = 56});
  @override
  Widget build(BuildContext context) =>
      ClipRRect(borderRadius: BorderRadius.circular(14), child: SizedBox(width: size, height: size, child: Img(p, 0, size / 2)));
}

class ProductImage extends StatelessWidget {
  final Product p;
  final String tag;
  final double size;
  const ProductImage(this.p, this.tag, this.size, {super.key});
  @override
  Widget build(BuildContext context) => Hero(tag: tag, child: Img(p, 0, size));
}

class Hdr extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final Color color;
  final Widget? extra;
  const Hdr(this.title, this.sub, this.icon, this.color, {super.key, this.extra});
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(8, MediaQuery.of(context).padding.top + 8, 20, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, color.withOpacity(0.7)]),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        child: Column(children: [
          Row(children: [
            Navigator.canPop(context)
                ? IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))
                : const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.white70)),
              ]),
            ),
            Icon(icon, size: 48, color: Colors.white54),
          ]),
          if (extra != null) Padding(padding: const EdgeInsets.only(top: 12, left: 12), child: extra),
        ]),
      );
}

class ProductCard extends StatelessWidget {
  final Product p;
  final String from;
  final int i;
  const ProductCard(this.p, this.from, this.i, {super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (c, _) {
          final w = shop.wish.contains(p.id);
          return Pop(
            i: i,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(
                  c,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 450),
                    pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: ProductPage(p, '$from${p.id}')),
                  )),
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Stack(children: [
                      Positioned.fill(child: ProductImage(p, '$from${p.id}', 56)),
                      if (p.off > 0)
                        Positioned(
                          top: 10, left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                            child: Text('-${p.off}%', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      Positioned(
                        top: 2, right: 2,
                        child: IconButton(
                          onPressed: () => shop.toggleWish(p.id),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (ch, a) => ScaleTransition(scale: a, child: ch),
                            child: Icon(w ? Icons.favorite : Icons.favorite_border, key: ValueKey(w), color: w ? Colors.red : Colors.white),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Row(children: [
                        Text(money(p.now), style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (p.off > 0) ...[
                          const SizedBox(width: 6),
                          Text(money(p.price), style: const TextStyle(color: Colors.grey, fontSize: 12, decoration: TextDecoration.lineThrough)),
                        ],
                      ]),
                      Row(children: [const Icon(Icons.star, color: Colors.amber, size: 15), Text(' ${p.rating}', style: const TextStyle(fontSize: 12))]),
                    ]),
                  ),
                ]),
              ),
            ),
          );
        },
      );
}
