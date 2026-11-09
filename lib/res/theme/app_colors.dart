import 'package:flutter/material.dart';

/// Pulled from reacttemplate's Tailwind palette usage — teal/cyan primary,
/// indigo/emerald for gradients and accents, slate for text/surfaces.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF14B8A6); // teal-500
  static const Color primaryDark = Color(0xFF0F766E); // teal-700
  static const Color cyan = Color(0xFF22D3EE); // cyan-400
  static const Color indigo = Color(0xFF6366F1); // indigo-500
  static const Color emerald = Color(0xFF10B981); // emerald-500
  static const Color amberYellow = Color(0xFFFDE047); // yellow-300

  static const Color error = Color(0xFFEF4444); // red-500
  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color success = Color(0xFF10B981); // emerald-500

  static const Color textDark = Color(0xFF1E293B); // slate-800
  static const Color textMuted = Color(0xFF64748B); // slate-500
  static const Color textFaint = Color(0xFF94A3B8); // slate-400

  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC); // slate-50
  static const Color border = Color(0xFFE2E8F0); // slate-200

  static const List<Color> heroGradient = [indigo, cyan, emerald];
  static const List<Color> ctaGradient = [Color(0xFF2DD4BF), cyan, amberYellow];
}
