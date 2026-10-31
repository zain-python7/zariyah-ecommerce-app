import 'package:flutter/material.dart';
import 'data.dart';
import 'login_page.dart';
import 'shell.dart';
import 'onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await shop.init();
  runApp(const ZariyahApp());
}

class ZariyahApp extends StatelessWidget {
  const ZariyahApp({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shop,
        builder: (_, __) => MaterialApp(
          title: 'Zariyah',
          debugShowCheckedModeBanner: false,
          themeMode: shop.dark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFFC9A66B)),
          darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFFC9A66B), brightness: Brightness.dark),
          home: const Splash(),
          builder: (ctx, child) => Directionality(
            textDirection: (shop.lang == 'ar' || shop.lang == 'ur') ? TextDirection.rtl : TextDirection.ltr,
            child: KeyedSubtree(key: ValueKey(shop.lang), child: child!),
          ),
        ),
      );
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 600), pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: shop.user.isNotEmpty ? const Shell() : (shop.seen ? const LoginPage() : const OnboardingPage()))));
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF6F5F0),
        body: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.scale(scale: 0.9 + 0.1 * v, child: child),
            ),
            child: Image.asset('assets/images/logo.jpg', width: MediaQuery.of(context).size.width * 0.85, fit: BoxFit.contain),
          ),
        ),
      );
}
