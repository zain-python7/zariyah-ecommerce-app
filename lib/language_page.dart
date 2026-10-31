import 'package:flutter/material.dart';
import 'data.dart';
import 'l10n.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (c, _) => Scaffold(
          appBar: AppBar(title: Text(tr('Language'))),
          body: ListView(children: [
            for (final l in languages)
              ListTile(
                title: Text(l.$2, style: const TextStyle(fontSize: 17)),
                trailing: shop.lang == l.$1 ? Icon(Icons.check_circle, color: Theme.of(c).colorScheme.primary) : const Icon(Icons.circle_outlined, color: Colors.grey),
                onTap: () => shop.setLang(l.$1),
              ),
          ]),
        ),
      );
}
