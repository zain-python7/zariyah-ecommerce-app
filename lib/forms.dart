import 'package:flutter/material.dart';

String? vRequired(String? v, String what) => (v == null || v.trim().isEmpty) ? 'Please enter your $what' : null;

String? vEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Please enter your email';
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? null : 'Enter a valid email address';
}

String? vPass(String? v) {
  if (v == null || v.isEmpty) return 'Please enter a password';
  return v.length < 6 ? 'Password must be at least 6 characters' : null;
}

String? vPhone(String? v) {
  if (v == null || v.trim().isEmpty) return 'Please enter your phone number';
  final d = v.replaceAll(RegExp(r'[^0-9]'), '');
  return (d.length < 7 || d.length > 15) ? 'Enter a valid phone number' : null;
}

InputDecoration deco(String label, IconData icon, {Widget? suffix}) =>
    InputDecoration(labelText: label, prefixIcon: Icon(icon), suffixIcon: suffix, border: const OutlineInputBorder(), errorMaxLines: 2);
