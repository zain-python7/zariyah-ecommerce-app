import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'data.dart';
import 'widgets.dart';
import 'forms.dart';
import 'l10n.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditState();
}

class _EditState extends State<EditProfilePage> {
  final form = GlobalKey<FormState>();
  final n = TextEditingController(text: shop.user == 'Guest' ? '' : shop.user);
  final p = TextEditingController(text: shop.phone), city = TextEditingController(text: shop.city);
  String gender = shop.gender, dob = shop.dob;

  String _fd(String s) {
    final d = DateTime.parse(s);
    return '${d.day}/${d.month}/${d.year}';
  }

  Future<void> _pick(ImageSource s) async {
    final x = await ImagePicker().pickImage(source: s, maxWidth: 500, imageQuality: 75);
    if (x != null) shop.setAvatar(base64Encode(await x.readAsBytes()));
  }

  void _photoSheet() => showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Choose from gallery'), onTap: () { Navigator.pop(ctx); _pick(ImageSource.gallery); }),
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Take a photo'), onTap: () { Navigator.pop(ctx); _pick(ImageSource.camera); }),
            if (shop.avatar.isNotEmpty)
              ListTile(leading: const Icon(Icons.delete, color: Colors.red), title: const Text('Remove photo', style: TextStyle(color: Colors.red)), onTap: () { Navigator.pop(ctx); shop.setAvatar(''); }),
          ]),
        ),
      );

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: dob.isEmpty ? DateTime(now.year - 20) : DateTime.parse(dob),
      firstDate: DateTime(1920), lastDate: now,
    );
    if (d != null) setState(() => dob = d.toIso8601String());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(tr('Edit profile'))),
        body: Form(
          key: form,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Center(
              child: ListenableBuilder(
                listenable: shop,
                builder: (c, _) => Stack(children: [
                  CircleAvatar(radius: 56, backgroundImage: shop.avatarImg, child: shop.avatar.isEmpty ? const Icon(Icons.person, size: 56) : null),
                  Positioned(
                    bottom: 0, right: 0,
                    child: InkWell(
                      onTap: _photoSheet,
                      child: CircleAvatar(radius: 18, backgroundColor: Theme.of(c).colorScheme.primary, child: Icon(Icons.camera_alt, size: 18, color: Theme.of(c).colorScheme.onPrimary)),
                    ),
                  ),
                ]),
              ),
            ),
            Center(child: TextButton(onPressed: _photoSheet, child: const Text('Change or remove photo'))),
            const SizedBox(height: 8),
            TextFormField(controller: n, textCapitalization: TextCapitalization.words, validator: (v) => vRequired(v, 'full name'), decoration: deco(tr('Full name'), Icons.person)),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: shop.email, readOnly: true, enabled: false,
              decoration: deco(tr('Email'), Icons.email).copyWith(helperText: 'Email cannot be changed'),
            ),
            const SizedBox(height: 14),
            TextFormField(controller: p, keyboardType: TextInputType.phone, validator: vPhone, decoration: deco(tr('Phone'), Icons.phone)),
            const SizedBox(height: 16),
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(spacing: 8, children: [
              for (final g in const ['Male', 'Female', 'Other', 'Prefer not to say'])
                ChoiceChip(label: Text(g), selected: gender == g, onSelected: (_) => setState(() => gender = g)),
            ]),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDob,
              child: InputDecorator(
                decoration: deco('Date of birth', Icons.cake),
                child: Text(dob.isEmpty ? 'Select your birthday' : _fd(dob)),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(controller: city, textCapitalization: TextCapitalization.words, decoration: deco('City', Icons.location_city)),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () {
                if (!form.currentState!.validate()) return;
                shop.setProfile(n.text.trim(), shop.email, p.text.trim());
                shop.setDetails(gender, dob, city.text.trim());
                snack(context, 'Profile saved');
                Navigator.pop(context);
              },
              child: Text(tr('Save')),
            ),
          ]),
        ),
      );
}
