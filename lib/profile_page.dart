import 'package:flutter/material.dart';
import 'data.dart';
import 'l10n.dart';
import 'login_page.dart';
import 'orders_page.dart';
import 'addresses_page.dart';
import 'coupons_page.dart';
import 'notifications_page.dart';
import 'help_page.dart';
import 'settings_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (c, _) {
          void go(Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));
          Widget tile(IconData i, Color col, String t, Widget w, [String? s]) => ListTile(
                leading: CircleAvatar(backgroundColor: col.withOpacity(0.15), child: Icon(i, color: col)),
                title: Text(tr(t)), subtitle: s == null ? null : Text(s), trailing: const Icon(Icons.chevron_right), onTap: () => go(w),
              );
          Widget stat(String v, String l) => Expanded(child: Column(children: [Text(v, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text(tr(l), style: const TextStyle(color: Colors.white70))]));
          return Scaffold(
            body: ListView(padding: EdgeInsets.zero, children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(c).padding.top + 24, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFC9A66B), Color(0xFF8A6A35)]),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Column(children: [
                  CircleAvatar(radius: 44, backgroundColor: Colors.white, backgroundImage: shop.avatarImg, child: shop.avatar.isEmpty ? const Icon(Icons.person, size: 50, color: Color(0xFFC9A66B)) : null),
                  const SizedBox(height: 10),
                  Text(shop.user, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  if (shop.email.isNotEmpty) Text(shop.email, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 14),
                  Row(children: [stat('${shop.orders.length}', 'Orders'), stat('${shop.wish.length}', 'Wishlist'), stat('${shop.addresses.length}', 'Addresses')]),
                ]),
              ),
              const SizedBox(height: 8),
              tile(Icons.person, const Color(0xFFC9A66B), 'Edit profile', const EditProfilePage()),
              tile(Icons.receipt_long, const Color(0xFF1E6FBF), 'My orders', const OrdersPage(), '${shop.orders.length} orders'),
              tile(Icons.location_on, const Color(0xFF2E8B57), 'Addresses', const AddressesPage()),
              tile(Icons.local_offer, const Color(0xFFE65100), 'Coupons', const CouponsPage()),
              tile(Icons.notifications, const Color(0xFFC2185B), 'Notifications', const NotificationsPage()),
              tile(Icons.support_agent, const Color(0xFF00838F), 'Help center', const HelpPage()),
              tile(Icons.settings, Colors.grey, 'Settings', const SettingsPage()),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.red.withOpacity(0.15), child: const Icon(Icons.logout, color: Colors.red)),
                title: Text(tr('Log out')),
                onTap: () {
                  shop.setUser('');
                  Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false);
                },
              ),
              const SizedBox(height: 20),
            ]),
          );
        },
      );
}
