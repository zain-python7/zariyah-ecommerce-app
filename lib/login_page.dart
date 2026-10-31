import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'forms.dart';
import 'l10n.dart';
import 'shell.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(), pass = TextEditingController();
  bool hide = true, busy = false;
  String? emailErr, passErr;

  Future<void> _submit() async {
    emailErr = passErr = null;
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    final r = await shop.login(email.text, pass.text);
    if (!mounted) return;
    if (r == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()));
      return;
    }
    setState(() {
      busy = false;
      if (r.$1 == 'email') {
        emailErr = r.$2;
      } else {
        passErr = r.$2;
      }
    });
    form.currentState!.validate();
  }

  void _guest() {
    shop.setUser('Guest');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(24), children: [
            const SizedBox(height: 20),
            Pop(child: Image.asset('assets/images/logo.jpg', height: 130, fit: BoxFit.contain)),
            Pop(i: 1, child: Text(tr('Welcome back'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
            const Pop(i: 2, child: Text('Sign in to continue shopping', textAlign: TextAlign.center)),
            const SizedBox(height: 24),
            Form(
              key: form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [
                Pop(
                  i: 3,
                  child: TextFormField(
                    controller: email, keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => emailErr = null,
                    validator: (v) => emailErr ?? vEmail(v),
                    decoration: deco(tr('Email'), Icons.email),
                  ),
                ),
                const SizedBox(height: 14),
                Pop(
                  i: 4,
                  child: TextFormField(
                    controller: pass, obscureText: hide,
                    onChanged: (_) => passErr = null,
                    validator: (v) => passErr ?? ((v == null || v.isEmpty) ? 'Please enter your password' : null),
                    decoration: deco(tr('Password'), Icons.lock,
                        suffix: IconButton(icon: Icon(hide ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => hide = !hide))),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Pop(
              i: 5,
              child: FilledButton(
                style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: busy ? null : _submit,
                child: busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(tr('Sign in')),
              ),
            ),
            Pop(i: 6, child: TextButton(onPressed: _guest, child: Text(tr('Continue as guest')))),
            Pop(
              i: 7,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(tr("Don't have an account?")),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())), child: Text(tr('Sign up'))),
              ]),
            ),
          ]),
        ),
      );
}
