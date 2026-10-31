import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'forms.dart';
import 'l10n.dart';
import 'shell.dart';
import 'legal_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController(), phone = TextEditingController();
  final pass = TextEditingController(), confirm = TextEditingController();
  bool hide = true, agree = false, busy = false, triedSubmit = false;
  String? emailErr;

  int get _score {
    final p = pass.text;
    var s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) s++;
    return s;
  }

  Future<void> _submit() async {
    emailErr = null;
    setState(() => triedSubmit = true);
    final ok = form.currentState!.validate();
    if (!ok || !agree) return;
    setState(() => busy = true);
    final err = await shop.signup(name.text.trim(), email.text, phone.text.trim(), pass.text);
    if (!mounted) return;
    if (err == null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Shell()), (r) => false);
      return;
    }
    setState(() {
      busy = false;
      emailErr = err;
    });
    form.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = [Colors.red, Colors.orange, Colors.amber, Colors.green, Colors.green];
    const labels = ['Too weak', 'Weak', 'Fair', 'Good', 'Strong'];
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(24, 0, 24, 24), children: [
          Pop(child: Text(tr('Create account'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          const Pop(i: 1, child: Text('Join Zariyah and start shopping')),
          const SizedBox(height: 20),
          Form(
            key: form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: [
              TextFormField(controller: name, textCapitalization: TextCapitalization.words, validator: (v) => vRequired(v, 'full name'), decoration: deco(tr('Full name'), Icons.person)),
              const SizedBox(height: 14),
              TextFormField(
                controller: email, keyboardType: TextInputType.emailAddress,
                onChanged: (_) => emailErr = null,
                validator: (v) => emailErr ?? vEmail(v),
                decoration: deco(tr('Email'), Icons.email),
              ),
              const SizedBox(height: 14),
              TextFormField(controller: phone, keyboardType: TextInputType.phone, validator: vPhone, decoration: deco(tr('Phone'), Icons.phone)),
              const SizedBox(height: 14),
              TextFormField(
                controller: pass, obscureText: hide, onChanged: (_) => setState(() {}), validator: vPass,
                decoration: deco(tr('Password'), Icons.lock, suffix: IconButton(icon: Icon(hide ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => hide = !hide))),
              ),
              if (pass.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(children: [
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: _score / 4, minHeight: 6, color: colors[_score]))),
                    const SizedBox(width: 10),
                    Text(labels[_score], style: TextStyle(color: colors[_score], fontSize: 12)),
                  ]),
                ),
              const SizedBox(height: 14),
              TextFormField(
                controller: confirm, obscureText: hide,
                validator: (v) => (v == null || v.isEmpty) ? 'Please confirm your password' : (v != pass.text ? 'Passwords do not match' : null),
                decoration: deco('Confirm password', Icons.lock_outline),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Checkbox(value: agree, onChanged: (v) => setState(() => agree = v ?? false)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(children: [
                  const Text('I agree to the '),
                  InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LegalPage(tr('Terms of Service'), termsSections))), child: Text(tr('Terms of Service'), style: TextStyle(color: cs.primary, decoration: TextDecoration.underline))),
                  const Text(' and '),
                  InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LegalPage(tr('Privacy Policy'), privacySections))), child: Text(tr('Privacy Policy'), style: TextStyle(color: cs.primary, decoration: TextDecoration.underline))),
                ]),
              ),
            ),
          ]),
          if (triedSubmit && !agree)
            Padding(padding: const EdgeInsets.only(left: 14), child: Text('You must accept the terms to continue', style: TextStyle(color: cs.error, fontSize: 12))),
          const SizedBox(height: 14),
          FilledButton(
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: busy ? null : _submit,
            child: busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(tr('Create account')),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(tr('Already have an account?')),
            TextButton(onPressed: () => Navigator.pop(context), child: Text(tr('Sign in'))),
          ]),
        ]),
      ),
    );
  }
}
