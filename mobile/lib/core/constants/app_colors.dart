import 'package:flutter/material.dart';

/// Palet warna resmi Smart BK Care berdasarkan Design System Google Stitch (DESIGN.md)
/// Memadukan standar Material 3 Tonal Palette dengan Domain-Specific Feature Palette
/// untuk platform bimbingan konseling dan perlindungan siswa SMA/SMK Sumatera Barat.
class AppColors {
  // --- Core Material 3 Brand Swatches (Stitch Tokens) ---
  static const Color primary = Color(0xFF0F52BA);           // Cobalt Royal Blue (Backbone)
  static const Color primaryDark = Color(0xFF003C90);       // Deep Primary
  static const Color primaryContainer = Color(0xFFDBEAFE);  // Soft Blue Container
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF001945);

  static const Color secondary = Color(0xFF0284C7);         // Energetic Sky Cyan
  static const Color secondaryDark = Color(0xFF006398);
  static const Color secondaryContainer = Color(0xFFE0F2FE);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color tertiary = Color(0xFF10B981);          // Emerald Mint
  static const Color tertiaryDark = Color(0xFF004B31);
  static const Color tertiaryContainer = Color(0xFFD1FAE5);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // --- Surfaces & Tonal Elevation (Stitch Surface Ramps) ---
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceDim = Color(0xFFD2D9F4);
  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Pure White Card Surface
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);

  // Background Canvas
  static const Color backgroundLight = Color(0xFFFAF8FF);   // Clean canvas base per DESIGN.md surface: '#faf8ff'
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFF1F5F9);        // Level 1 border
  static const Color cardBorderMedium = Color(0xFFE2E8F0);  // Level 2 border

  // --- Neutral & Typography Scale ---
  static const Color onSurface = Color(0xFF131B2E);         // Core Typography
  static const Color onSurfaceVariant = Color(0xFF434653);  // Subtitle / Secondary
  static const Color textPrimary = Color(0xFF0F172A);       // High-Contrast Dark Slate
  static const Color textSecondary = Color(0xFF475569);     // Slate 600
  static const Color textMuted = Color(0xFF94A3B8);         // Slate 400
  static const Color outline = Color(0xFF737784);
  static const Color outlineVariant = Color(0xFFC3C6D5);
  static const Color divider = Color(0xFFE2E8F0);           // Border 1px standard

  // --- Domain-Specific Feature Palette (DESIGN.md Specific) ---
  /// Urgent Protection & Anti-Bullying (Secure panic report, whistleblowing crisis)
  static const Color featureReporting = Color(0xFFF43F5E);      // Coral Rose
  static const Color featureReportingTint = Color(0x33F43F5E);  // 20% tint for confidential card border

  /// Mental Health Screening (Self-assessment GAD-7, DASS-21)
  static const Color featureScreening = Color(0xFF0EA5E9);      // Sky Blue

  /// Consultation & Empathy Chat (Direct counselor dialogue, active video)
  static const Color featureCounseling = Color(0xFF10B981);     // Emerald Mint

  /// Literacy & Psychoeducation (Articles, guides, Adat Basandi Syarak)
  static const Color featureEducation = Color(0xFFF59E0B);      // Amber Gold

  /// Counseling Schedule & Appointment (Booking calendars, reminder alerts)
  static const Color featureSchedule = Color(0xFFEA580C);       // Vivid Orange

  /// Student Community & Peer Forum
  static const Color featureCommunity = Color(0xFF14B8A6);      // Teal Mint

  // --- Semantic Alerts & Risk Levels ---
  static const Color danger = Color(0xFFF43F5E);
  static const Color riskLow = Color(0xFF10B981);       // Sehat / Adaptif (Emerald)
  static const Color riskModerate = Color(0xFFF59E0B);  // Perlu Pantau (Amber)
  static const Color riskHigh = Color(0xFFF43F5E);      // Intervensi (Coral Rose)
  static const Color riskSevere = Color(0xFFBA1A1A);    // Kritis Darurat (Deep Red)

  // Backward-compatibility Aliases
  static const Color marawaRed = primary;
  static const Color marawaGold = secondary;
  static const Color marawaBlack = textPrimary;
  static const Color syarakGreen = tertiary;
}
