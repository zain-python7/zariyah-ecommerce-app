import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'listing_page.dart';

const catIcons = {'Fashion': Icons.checkroom, 'Tech': Icons.devices, 'Home': Icons.chair, 'Beauty': Icons.spa, 'Sports': Icons.sports_soccer, 'Books': Icons.menu_book, 'Accessories': Icons.watch, 'Kitchen': Icons.kitchen, 'Kids': Icons.toys};

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final list = cats.skip(1).toList();
    final colors = <String, Color>{
      'Fashion': const Color(0xFF8E5B75), 'Tech': const Color(0xFF3867A8),
      'Home': const Color(0xFFB47A4B), 'Beauty': const Color(0xFFC65383),
      'Sports': const Color(0xFF3D8A68), 'Books': const Color(0xFF7B654A),
      'Accessories': const Color(0xFF586C86), 'Kitchen': const Color(0xFF278B85),
      'Kids': const Color(0xFFE58A3A),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Explore categories')),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(colors: [Color(0xFF332D29), Color(0xFF76614C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Find your next favourite', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Explore collections picked for your everyday life.', style: TextStyle(color: Colors.white70)),
              ]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 13, crossAxisSpacing: 13, childAspectRatio: 0.95),
            delegate: SliverChildBuilderDelegate((context, i) {
              final category = list[i];
              final color = colors[category] ?? Theme.of(context).colorScheme.primary;
              final count = products.where((p) => p.cat == category).length;
              return Pop(
                i: i,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingPage(title: category, cat: category))),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: color.withOpacity(0.09), borderRadius: BorderRadius.circular(22), border: Border.all(color: color.withOpacity(0.18))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(width: 54, height: 54, decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.65)]), borderRadius: BorderRadius.circular(18)), child: Icon(catIcons[category] ?? Icons.category, color: Colors.white, size: 29)),
                      const Spacer(),
                      Text(category, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text('$count ${count == 1 ? 'item' : 'items'}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(children: [Text('Explore', style: TextStyle(color: color, fontWeight: FontWeight.w700)), const SizedBox(width: 4), Icon(Icons.arrow_forward_rounded, size: 16, color: color)]),
                    ]),
                  ),
                ),
              );
            }, childCount: list.length),
          ),
        ),
      ]),
    );
  }
}
