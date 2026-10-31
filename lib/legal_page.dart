import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final List<(String, String)> sections;
  const LegalPage(this.title, this.sections, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const Text('Last updated: October 2026', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          for (var i = 0; i < sections.length; i++) ...[
            Text('${i + 1}. ${sections[i].$1}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(sections[i].$2, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 18),
          ],
        ]),
      );
}

const termsSections = <(String, String)>[
  ('Acceptance of terms', 'By creating an account or placing an order on Zariyah, you agree to these Terms of Service. If you do not agree, please do not use the app.'),
  ('Your account', 'You are responsible for keeping your password safe and for all activity under your account. Please give accurate information and keep it up to date.'),
  ('Orders and payments', 'An order is confirmed when you receive an order number. Prices and availability can change without notice. We may cancel an order if an item is unavailable or a pricing error occurred, and we will refund any amount paid.'),
  ('Shipping and delivery', 'Delivery times shown are estimates. Shipping is free on eligible orders or with a valid coupon. You are responsible for providing a correct delivery address and phone number.'),
  ('Returns and refunds', 'You may request a return within 30 days of delivery for unused items in original condition. Refunds go back to the original payment method after the returned item is checked.'),
  ('Coupons and offers', 'Coupons have conditions and cannot be combined unless stated. We may withdraw an offer at any time.'),
  ('Acceptable use', 'Do not misuse the app, attempt to access other accounts, or use it for unlawful purposes.'),
  ('Intellectual property', 'The Zariyah name, logo, design and content belong to Zariyah or its partners and may not be copied without permission.'),
  ('Limitation of liability', 'To the extent allowed by law, Zariyah is not liable for indirect or consequential losses arising from the use of the app.'),
  ('Changes to these terms', 'We may update these terms from time to time. Continued use of the app after a change means you accept the updated terms.'),
  ('Contact us', 'Questions about these terms? Email support@zariyah.com.'),
];

const privacySections = <(String, String)>[
  ('Information we collect', 'We collect the details you give us: your name, email, phone number, delivery addresses, profile photo, date of birth and gender (optional), and your orders, wishlist and cart.'),
  ('How we use your information', 'We use it to create your account, process and deliver orders, show your order history, personalize the app, and respond to support requests.'),
  ('Where your data is stored', 'Your account details, cart, wishlist, orders, addresses and settings are stored on your device in a local database. Your password is saved only as a scrambled (hashed) value, never as plain text.'),
  ('Sharing your information', 'We do not sell your personal information. We share only what is needed with delivery and payment partners to complete your order, or when the law requires it.'),
  ('Product photos and the internet', 'Product images are loaded from the internet, so your device connects to an image server when you browse products.'),
  ('Your choices', 'You can edit your profile, change or remove your photo, delete saved addresses, clear your search history, and log out at any time from the app.'),
  ('Children', 'Zariyah is not intended for children under 13, and we do not knowingly collect their information.'),
  ('Changes to this policy', 'We may update this policy and will show the new date at the top of this page.'),
  ('Contact us', 'For privacy questions, email support@zariyah.com.'),
];
