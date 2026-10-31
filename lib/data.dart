import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Product {
  final int id;
  final String name, cat, desc;
  final double price, rating;
  final int off;
  final IconData icon;
  final Color color;
  const Product(this.id, this.name, this.cat, this.price, this.rating, this.icon, this.color, this.desc, [this.off = 0]);
  double get now => price * (100 - off) / 100;
  /// Photo URL for gallery slot [n] (0 = main photo). Slots 1 and 2 are different crops of the same photo.
  String img(int n) {
    const crops = ['', '&crop=left', '&crop=right'];
    return '${_photos[id]}?auto=format&fit=crop&w=800&h=800&q=80${crops[n % 3]}';
  }
}

// Change any URL here to use your own product photo.
const _photos = {
  1: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
  2: 'https://images.unsplash.com/photo-1551028719-00167b16eac5',
  3: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
  4: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
  5: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46',
  6: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c',
  7: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
  8: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
  9: 'https://images.unsplash.com/photo-1556228720-195a672e8a03',
  10: 'https://images.unsplash.com/photo-1541643600914-78b084683601',
  11: 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f',
  12: 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68',
  13: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
  14: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
  15: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
  16: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f',
  17: 'https://images.unsplash.com/photo-1519238263530-99b5fa2e7c12',
  18: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38',
  19: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f',
  20: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
};

const cats = ['All', 'Fashion', 'Tech', 'Home', 'Beauty', 'Sports', 'Books', 'Accessories', 'Kitchen', 'Kids'];

const products = [
  Product(1, 'Classic Sneakers', 'Fashion', 89, 4.6, Icons.directions_run, Color(0xFFE65100), 'Light, comfy sneakers for everyday wear.', 20),
  Product(2, 'Denim Jacket', 'Fashion', 120, 4.4, Icons.checkroom, Color(0xFF1E6FBF), 'Timeless denim with a modern fit.'),
  Product(3, 'Wireless Earbuds', 'Tech', 59, 4.7, Icons.headphones, Color(0xFF7B1FA2), 'Crisp sound with 24 hour battery life.', 15),
  Product(4, 'Smart Watch', 'Tech', 149, 4.5, Icons.watch, Color(0xFF00838F), 'Track health, sleep and notifications.'),
  Product(5, 'Gaming Mouse', 'Tech', 39, 4.3, Icons.mouse, Color(0xFFC2185B), 'Precise, fast and comfortable.', 10),
  Product(6, 'Table Lamp', 'Home', 35, 4.2, Icons.lightbulb, Color(0xFFF9A825), 'Warm light for cozy evenings.'),
  Product(7, 'Coffee Maker', 'Home', 79, 4.6, Icons.coffee, Color(0xFF6D4C41), 'Fresh coffee in minutes.', 25),
  Product(8, 'Cozy Chair', 'Home', 210, 4.8, Icons.chair, Color(0xFF2E8B57), 'Soft seat that fits any room.'),
  Product(9, 'Face Serum', 'Beauty', 28, 4.5, Icons.water_drop, Color(0xFFEC407A), 'Glow with daily hydration.'),
  Product(10, 'Perfume', 'Beauty', 65, 4.4, Icons.spa, Color(0xFF8E24AA), 'Fresh floral scent that lasts.', 10),
  Product(11, 'Yoga Mat', 'Sports', 25, 4.6, Icons.self_improvement, Color(0xFF43A047), 'Non-slip mat for any workout.'),
  Product(12, 'Football', 'Sports', 30, 4.3, Icons.sports_soccer, Color(0xFF1565C0), 'Durable ball for match day.', 5),
  Product(13, 'Everyday Journal', 'Books', 18, 4.7, Icons.menu_book, Color(0xFF6D4C41), 'A beautiful journal for notes, plans, and ideas.'),
  Product(14, 'Minimalist Watch', 'Accessories', 95, 4.5, Icons.watch, Color(0xFF455A64), 'A clean, versatile watch for every occasion.', 12),
  Product(15, 'Instant Camera', 'Tech', 115, 4.6, Icons.camera_alt, Color(0xFF5C6BC0), 'Capture everyday moments in a classic style.'),
  Product(16, 'Kitchen Organizer', 'Kitchen', 32, 4.3, Icons.kitchen, Color(0xFF00897B), 'Keep your kitchen essentials neat and close.'),
  Product(17, 'Kids Backpack', 'Kids', 27, 4.4, Icons.backpack, Color(0xFFEF6C00), 'A lightweight, colorful backpack for school.'),
  Product(18, 'Decorative Vase', 'Home', 42, 4.6, Icons.local_florist, Color(0xFF8D6E63), 'A modern accent for shelves and side tables.'),
  Product(19, 'Art Supply Set', 'Books', 24, 4.5, Icons.brush, Color(0xFF7E57C2), 'Creative essentials for sketching and drawing.'),
  Product(20, 'Classic Sunglasses', 'Accessories', 39, 4.2, Icons.wb_sunny, Color(0xFF546E7A), 'Everyday sunglasses with a timeless silhouette.', 10),
];

class Order {
  final int id;
  final DateTime date;
  final Map<int, int> items;
  final double total;
  Order(this.id, this.date, this.items, this.total);
  // The stage advances automatically until a real order backend is connected.
  int get stage => min(3, DateTime.now().difference(date).inMinutes);
}

const stageNames = ['Placed', 'Packed', 'Shipped', 'Delivered'];
const coupons = {'SAVE10': '10% off your order', 'WELCOME20': '20% off for new users', 'FREESHIP': 'Free shipping on any order'};
const _usersSql = 'CREATE TABLE users(email TEXT PRIMARY KEY, name TEXT, phone TEXT, pass TEXT)';
const _addrSql = 'CREATE TABLE addr(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, line TEXT, phone TEXT)';
const _scopedSql = [
  'CREATE TABLE cart_by_user(owner TEXT NOT NULL, pid INTEGER NOT NULL, qty INTEGER NOT NULL, PRIMARY KEY(owner,pid))',
  'CREATE TABLE wish_by_user(owner TEXT NOT NULL, pid INTEGER NOT NULL, PRIMARY KEY(owner,pid))',
  'CREATE TABLE orders_by_user(owner TEXT NOT NULL, id INTEGER NOT NULL, date TEXT NOT NULL, total REAL NOT NULL, PRIMARY KEY(owner,id))',
  'CREATE TABLE order_items_by_user(owner TEXT NOT NULL, order_id INTEGER NOT NULL, pid INTEGER NOT NULL, qty INTEGER NOT NULL, PRIMARY KEY(owner,order_id,pid))',
  'CREATE TABLE addr_by_user(id INTEGER PRIMARY KEY AUTOINCREMENT, owner TEXT NOT NULL, name TEXT, line TEXT, phone TEXT)',
];

/// SQLite tables: cart, wish, orders, order_items, settings, addr.
class Shop extends ChangeNotifier {
  final cart = <int, int>{};
  final wish = <int>{};
  final orders = <Order>[];
  final addresses = <Map<String, dynamic>>[];
  final viewed = <int>[];
  var recent = <String>[];
  String user = '', email = '', phone = '', coupon = '';
  String lang = 'en', avatar = '', gender = '', dob = '', city = '';
  bool dark = false, seen = false, notif = true;
  late Database _db;

  Future<void> init() async {
    _db = await openDatabase('${await getDatabasesPath()}/zariyah.db', version: 4, onCreate: (db, v) async {
      await db.execute('CREATE TABLE cart(pid INTEGER PRIMARY KEY, qty INTEGER)');
      await db.execute('CREATE TABLE wish(pid INTEGER PRIMARY KEY)');
      await db.execute('CREATE TABLE orders(id INTEGER PRIMARY KEY, date TEXT, total REAL)');
      await db.execute('CREATE TABLE order_items(order_id INTEGER, pid INTEGER, qty INTEGER)');
      await db.execute('CREATE TABLE settings(k TEXT PRIMARY KEY, v TEXT)');
      await db.execute(_addrSql);
      await db.execute(_usersSql);
      for (final sql in _scopedSql) { await db.execute(sql); }
    }, onUpgrade: (db, o, n) async {
      if (o < 2) await db.execute(_addrSql);
      if (o < 3) await db.execute(_usersSql);
      if (o < 4) {
        for (final sql in _scopedSql) { await db.execute(sql); }
        final settings = await db.query('settings', where: "k = ?", whereArgs: ['email']);
        final legacyOwner = settings.isNotEmpty && (settings.first['v'] as String).isNotEmpty ? (settings.first['v'] as String).trim().toLowerCase() : '__guest__';
        for (final r in await db.query('cart')) { await db.insert('cart_by_user', {'owner': legacyOwner, 'pid': r['pid'], 'qty': r['qty']}, conflictAlgorithm: ConflictAlgorithm.ignore); }
        for (final r in await db.query('wish')) { await db.insert('wish_by_user', {'owner': legacyOwner, 'pid': r['pid']}, conflictAlgorithm: ConflictAlgorithm.ignore); }
        for (final r in await db.query('orders')) { await db.insert('orders_by_user', {'owner': legacyOwner, 'id': r['id'], 'date': r['date'], 'total': r['total']}, conflictAlgorithm: ConflictAlgorithm.ignore); }
        for (final r in await db.query('order_items')) { await db.insert('order_items_by_user', {'owner': legacyOwner, 'order_id': r['order_id'], 'pid': r['pid'], 'qty': r['qty']}, conflictAlgorithm: ConflictAlgorithm.ignore); }
        for (final r in await db.query('addr')) { await db.insert('addr_by_user', {'owner': legacyOwner, 'name': r['name'], 'line': r['line'], 'phone': r['phone']}); }
      }
    });
    final m = {for (final r in await _db.query('settings')) r['k'] as String: r['v'] as String};
    user = m['user'] ?? '';
    email = m['email'] ?? '';
    phone = m['phone'] ?? '';
    dark = m['dark'] == '1';
    seen = m['seen'] == '1';
    notif = m['notif'] != '0';
    lang = m['lang'] ?? 'en';
    avatar = m['avatar'] ?? '';
    gender = m['gender'] ?? '';
    dob = m['dob'] ?? '';
    city = m['city'] ?? '';
    recent = (m['recent'] ?? '').split('|').where((e) => e.isNotEmpty).toList();
    await _loadAccountData();
  }

  String get _owner => email.trim().isEmpty ? '__guest__' : email.trim().toLowerCase();

  Future<void> _loadAccountData() async {
    coupon = '';
    cart.clear(); wish.clear(); orders.clear(); addresses.clear();
    for (final r in await _db.query('cart_by_user', where: 'owner = ?', whereArgs: [_owner])) { cart[r['pid'] as int] = r['qty'] as int; }
    for (final r in await _db.query('wish_by_user', where: 'owner = ?', whereArgs: [_owner])) { wish.add(r['pid'] as int); }
    for (final r in await _db.query('addr_by_user', where: 'owner = ?', whereArgs: [_owner], orderBy: 'id DESC')) { addresses.add(Map<String, dynamic>.from(r)); }
    for (final r in await _db.query('orders_by_user', where: 'owner = ?', whereArgs: [_owner], orderBy: 'id DESC')) {
      final items = <int, int>{};
      for (final i in await _db.query('order_items_by_user', where: 'owner = ? AND order_id = ?', whereArgs: [_owner, r['id']])) { items[i['pid'] as int] = i['qty'] as int; }
      orders.add(Order(r['id'] as int, DateTime.parse(r['date'] as String), items, (r['total'] as num).toDouble()));
    }
  }

  Product p(int id) => products.firstWhere((e) => e.id == id);
  int get count => cart.values.fold(0, (a, b) => a + b);
  double get sub => cart.entries.fold(0.0, (a, e) => a + p(e.key).now * e.value);
  double get disc => coupon == 'SAVE10' ? sub * 0.1 : (coupon == 'WELCOME20' ? sub * 0.2 : 0);
  double get ship => cart.isEmpty || coupon == 'FREESHIP' || sub - disc >= 100 ? 0 : 9.99;
  double get total => sub - disc + ship;

  void _saveQty(int id) => _db.insert('cart_by_user', {'owner': _owner, 'pid': id, 'qty': cart[id]}, conflictAlgorithm: ConflictAlgorithm.replace);
  void _set(String k, String v) => _db.insert('settings', {'k': k, 'v': v}, conflictAlgorithm: ConflictAlgorithm.replace);

  void add(int id, [int n = 1]) {
    cart[id] = (cart[id] ?? 0) + n;
    _saveQty(id);
    notifyListeners();
  }

  void setQty(int id, int q) {
    if (q <= 0) {
      cart.remove(id);
      _db.delete('cart_by_user', where: 'owner = ? AND pid = ?', whereArgs: [_owner, id]);
    } else {
      cart[id] = q;
      _saveQty(id);
    }
    notifyListeners();
  }

  void toggleWish(int id) {
    if (wish.remove(id)) {
      _db.delete('wish_by_user', where: 'owner = ? AND pid = ?', whereArgs: [_owner, id]);
    } else {
      wish.add(id);
      _db.insert('wish_by_user', {'owner': _owner, 'pid': id}, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    notifyListeners();
  }

  Order place() {
    final id = DateTime.now().millisecondsSinceEpoch;
    final o = Order(id, DateTime.now(), Map.of(cart), total);
    orders.insert(0, o);
    _db.transaction((t) async {
      await t.insert('orders_by_user', {'owner': _owner, 'id': id, 'date': o.date.toIso8601String(), 'total': o.total});
      for (final e in o.items.entries) {
        await t.insert('order_items_by_user', {'owner': _owner, 'order_id': id, 'pid': e.key, 'qty': e.value});
      }
      await t.delete('cart_by_user', where: 'owner = ?', whereArgs: [_owner]);
    });
    cart.clear();
    coupon = '';
    notifyListeners();
    return o;
  }

  Future<void> setUser(String u) async {
    user = u;
    if (u.isEmpty) { email = ''; phone = ''; }
    else if (u == 'Guest') { email = ''; phone = ''; }
    _set('user', u); _set('email', email); _set('phone', phone);
    await _loadAccountData();
    notifyListeners();
  }

  void setProfile(String n, String e, String p) {
    user = n;
    email = e.trim().toLowerCase();
    phone = p;
    _db.update('users', {'name': n, 'phone': p}, where: 'email = ?', whereArgs: [e.trim().toLowerCase()]);
    _set('user', n);
    _set('email', email);
    _set('phone', p);
    notifyListeners();
  }

  void setDark(bool d) {
    dark = d;
    _set('dark', d ? '1' : '0');
    notifyListeners();
  }

  void setNotif(bool v) {
    notif = v;
    _set('notif', v ? '1' : '0');
    notifyListeners();
  }

  void setSeen() {
    seen = true;
    _set('seen', '1');
  }

  void setCoupon(String c) {
    coupon = c;
    notifyListeners();
  }

  void view(int id) {
    viewed.remove(id);
    viewed.insert(0, id);
    if (viewed.length > 8) viewed.removeLast();
  }

  void addRecent(String q) {
    q = q.trim();
    if (q.isEmpty) return;
    recent.remove(q);
    recent.insert(0, q);
    if (recent.length > 6) recent.removeLast();
    _set('recent', recent.join('|'));
    notifyListeners();
  }

  void clearRecent() {
    recent.clear();
    _set('recent', '');
    notifyListeners();
  }

  String _hash(String p) => sha256.convert(utf8.encode('zariyah:$p')).toString();

  Future<void> _activateAccount(String n, String e, String p) async {
    user = n; email = e.trim().toLowerCase(); phone = p;
    _set('user', user); _set('email', email); _set('phone', phone);
    await _loadAccountData();
    notifyListeners();
  }

  /// Creates an account. Returns an error message, or null on success.
  Future<String?> signup(String name, String mail, String ph, String pass) async {
    mail = mail.trim().toLowerCase();
    final ex = await _db.query('users', where: 'email = ?', whereArgs: [mail]);
    if (ex.isNotEmpty) return 'An account with this email already exists';
    await _db.insert('users', {'email': mail, 'name': name, 'phone': ph, 'pass': _hash(pass)});
    await _activateAccount(name, mail, ph);
    return null;
  }

  /// Returns (field, message) when it fails; field is 'email' or 'pass'.
  Future<(String, String)?> login(String mail, String pass) async {
    mail = mail.trim().toLowerCase();
    final r = await _db.query('users', where: 'email = ?', whereArgs: [mail]);
    if (r.isEmpty) return ('email', 'No account found with this email');
    if (r.first['pass'] != _hash(pass)) return ('pass', 'Incorrect password');
    await _activateAccount(r.first['name'] as String, mail, (r.first['phone'] ?? '') as String);
    return null;
  }

  void setLang(String l) {
    lang = l;
    _set('lang', l);
    notifyListeners();
  }

  void setAvatar(String b64) {
    avatar = b64;
    _set('avatar', b64);
    notifyListeners();
  }

  void setDetails(String g, String d, String c) {
    gender = g;
    dob = d;
    city = c;
    _set('gender', g);
    _set('dob', d);
    _set('city', c);
    notifyListeners();
  }

  ImageProvider? get avatarImg => avatar.isEmpty ? null : MemoryImage(base64Decode(avatar));

  Future<void> addAddress(String n, String l, String p) async {
    final id = await _db.insert('addr_by_user', {'owner': _owner, 'name': n, 'line': l, 'phone': p});
    addresses.add({'id': id, 'owner': _owner, 'name': n, 'line': l, 'phone': p});
    notifyListeners();
  }

  void delAddress(int id) {
    addresses.removeWhere((a) => a['id'] == id);
    _db.delete('addr_by_user', where: 'id = ? AND owner = ?', whereArgs: [id, _owner]);
    notifyListeners();
  }
}

final shop = Shop();
String money(double v) => '\$${v.toStringAsFixed(2)}';
