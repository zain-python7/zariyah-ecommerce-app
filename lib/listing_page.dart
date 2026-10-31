import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';

const _sorts = ['Popular', 'Price: Low', 'Price: High', 'Top rated'];

class ListingPage extends StatefulWidget {
  final String title, cat, query;
  final bool deals;
  const ListingPage({super.key, required this.title, this.cat = 'All', this.query = '', this.deals = false});
  @override
  State<ListingPage> createState() => _ListingState();
}

class _ListingState extends State<ListingPage> {
  String sort = 'Popular';
  RangeValues price = const RangeValues(0, 250);
  late bool dealsOnly = widget.deals;

  void _filter() => showModalBottomSheet(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, ss) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Price: ${money(price.start)} - ${money(price.end)}'),
              RangeSlider(
                values: price, min: 0, max: 250, divisions: 25,
                labels: RangeLabels(money(price.start), money(price.end)),
                onChanged: (v) {
                  setState(() => price = v);
                  ss(() {});
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero, title: const Text('Deals only'), value: dealsOnly,
                onChanged: (v) {
                  setState(() => dealsOnly = v);
                  ss(() {});
                },
              ),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Show results'))),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final q = widget.query.toLowerCase();
    final list = products
        .where((p) =>
            (widget.cat == 'All' || p.cat == widget.cat) &&
            (q.isEmpty || p.name.toLowerCase().contains(q) || p.cat.toLowerCase().contains(q)) &&
            p.now >= price.start && p.now <= price.end && (!dealsOnly || p.off > 0))
        .toList();
    if (sort == 'Price: Low') list.sort((a, b) => a.now.compareTo(b.now));
    if (sort == 'Price: High') list.sort((a, b) => b.now.compareTo(a.now));
    if (sort == 'Top rated') list.sort((a, b) => b.rating.compareTo(a.rating));
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [IconButton(icon: const Icon(Icons.tune), onPressed: _filter)]),
      body: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(children: [
            for (final s in _sorts)
              Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(s), selected: sort == s, onSelected: (_) => setState(() => sort = s))),
          ]),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Align(alignment: Alignment.centerLeft, child: Text('${list.length} products'))),
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text('No products match your filters'))
              : GridView.count(
                  padding: const EdgeInsets.all(16), crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.74,
                  children: [for (var i = 0; i < list.length; i++) ProductCard(list[i], 'list', i)],
                ),
        ),
      ]),
    );
  }
}
