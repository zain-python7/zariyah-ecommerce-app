import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'l10n.dart';
import 'language_page.dart';
import 'legal_page.dart';
import 'about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (c, _) {
          void go(Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));
          return Scaffold(
            appBar: AppBar(title: Text(tr('Settings'))),
            body: ListView(children: [
              SwitchListTile(secondary: Icon(shop.dark ? Icons.dark_mode : Icons.light_mode), title: Text(shop.dark ? tr('Dark mode') : tr('Light mode')), value: shop.dark, onChanged: shop.setDark),
              SwitchListTile(secondary: const Icon(Icons.notifications), title: Text(tr('Push notifications')), value: shop.notif, onChanged: shop.setNotif),
              ListTile(leading: const Icon(Icons.language), title: Text(tr('Language')), trailing: Text(langName(shop.lang)), onTap: () => go(const LanguagePage())),
              ListTile(leading: const Icon(Icons.history), title: const Text('Clear search history'), onTap: () { shop.clearRecent(); snack(c, 'Search history cleared'); }),
              const Divider(),
              ListTile(leading: const Icon(Icons.description), title: Text(tr('Terms of Service')), trailing: const Icon(Icons.chevron_right), onTap: () => go(LegalPage(tr('Terms of Service'), termsSections))),
              ListTile(leading: const Icon(Icons.privacy_tip), title: Text(tr('Privacy Policy')), trailing: const Icon(Icons.chevron_right), onTap: () => go(LegalPage(tr('Privacy Policy'), privacySections))),
              ListTile(leading: const Icon(Icons.info), title: Text(tr('About Zariyah')), trailing: const Icon(Icons.chevron_right), onTap: () => go(const AboutPage())),
            ]),
          );
        },
      );
}
