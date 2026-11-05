import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Dashboard Screen Smart BK Care (Beranda)
/// Mengimplementasikan 100% spesifikasi dokumen DESIGN.md:
/// - Tipografi Plus Jakarta Sans
/// - Palet warna domain (Emerald #10B981, Sky #0EA5E9, Coral Rose #F43F5E, Amber #F59E0B, Orange #EA580C, Teal #14B8A6)
/// - Two-Column Feature Service Grid dengan 16px gap
/// - Kartu Lapor Kasus dengan border khusus kerahasiaan #F43F5E33
/// - Search Bar 48px berlatar #F8FAFC & border #E2E8F0
/// - Chips & Category Filters (height 36px, radius rounded-full)
/// - Student Sanctuary Hero Card (rounded-xl 24px) dengan motif watermark Minangkabau Gonjong
/// - Crisis / Alert Button (Lapor Perundungan) berlatar #F43F5E
class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToCounseling;
  final VoidCallback onNavigateToEducation;
  final VoidCallback onNavigateToScreening;
  final VoidCallback onNavigateToReport;

  const DashboardScreen({
    super.key,
    required this.onNavigateToCounseling,
    required this.onNavigateToEducation,
    required this.onNavigateToScreening,
    required this.onNavigateToReport,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Semua Layanan',
    'Curhat & Chat',
    'Skrining Mental',
    'Anti-Bullying',
    'Literasi Jiwa',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: _buildCustomHeader(context, user),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Search Bar per DESIGN.md (Height 48px, #F8FAFC, border #E2E8F0)
                  _buildSearchBar(context),
                  const SizedBox(height: 12),

                  // 2. Chips & Category Filters per DESIGN.md (Height 36px, rounded-full)
                  _buildCategoryChips(),
                  const SizedBox(height: 16),

                  if (user.isStudent) ...[
                    // 3. Student Profile Hero Card (rounded-xl 24px) dengan Minangkabau Watermark
                    _buildStudentHeroCard(context, user),
                    const SizedBox(height: 20),

                    // 4. Two-Column Feature Action Grid (6 Kartu Layanan Domain-Specific)
                    _buildFeatureActionGrid(context),
                    const SizedBox(height: 20),

                    // 5. Crisis / Alert Banner (Lapor Perundungan #F43F5E)
                    _buildCrisisAlertCard(context),
                  ] else ...[
                    // Portal Khusus Guru BK / Konselor
                    _buildCounselorHeroCard(context, user),
                    const SizedBox(height: 20),
                    _buildCounselorOverview(context),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      },
    );
  }

  /// App Bar Header Modern
  PreferredSizeWidget _buildCustomHeader(BuildContext context, dynamic user) {
    final firstName = user.fullName.split(' ').first;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              firstName.isNotEmpty ? firstName[0].toUpperCase() : 'S',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halo, $firstName! 👋',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.isStudent
                      ? '${user.schoolName ?? "SMAN 1 Padang"} • ${user.gradeClass ?? "XI-F2"}'
                      : '${user.schoolName ?? "SMAN 1 Padang"} • Guru BK',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Role Switcher Chip (Demo RBAC)
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => _showRoleSwitcherDialog(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: user.isStudent ? AppColors.primaryContainer.withValues(alpha: 0.5) : const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: user.isStudent ? AppColors.primary.withValues(alpha: 0.2) : AppColors.tertiary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    user.isStudent ? Icons.school_rounded : Icons.psychology_rounded,
                    size: 14,
                    color: user.isStudent ? AppColors.primary : AppColors.tertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.isStudent ? 'Siswa' : 'Guru BK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: user.isStudent ? AppColors.primary : AppColors.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Notification Icon Button (40x40px, Level 1 per DESIGN.md)
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_outlined, size: 20, color: AppColors.primary),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.featureReporting, // Coral Rose
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Input Fields & Search Bars per DESIGN.md
  /// Tinggi 48px, background #F8FAFC, border 1px #E2E8F0, icon #64748B, placeholder #94A3B8
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Row(
        children: [
          SizedBox(width: 14),
          Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Cari topik konseling, artikel, atau panduan...',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  /// Chips & Category Filters per DESIGN.md (Height 36px, radius rounded-full)
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return InkWell(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(9999), // rounded-full
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Student Profile Hero Card (Corner Radius Large: rounded-xl 24px)
  /// Dilengkapi siluet kurva atap Rumah Gadang (Gonjong) sebagai watermark lokal 8%
  Widget _buildStudentHeroCard(BuildContext context, dynamic user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,       // Cobalt Royal Blue #0F52BA
            AppColors.secondary,     // Sky Cyan #0284C7
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24), // rounded-xl per DESIGN.md (24px)
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Abstracted Minangkabau Gonjong Watermark Silhouette
            Positioned.fill(
              child: CustomPaint(
                painter: _MinangGonjongWatermarkPainter(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Badge ("Aman & Rahasia" dengan dot hijau menyala)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(9999), // rounded-full
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6FFBBE), // Light Emerald
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Aman & Rahasia',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'SISWA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Ruang Bimbingan & Konseling Digital',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tempat aman untuk bercerita tanpa stigma. Dilindungi UU PDP No. 27/2022 & Kode Etik ABKIN.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildHeroStatPill(Icons.verified_user_rounded, '100% Bebas Stigma'),
                      _buildHeroStatPill(Icons.groups_rounded, '3 Guru BK Online'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStatPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Two-Column Feature Action Grid (Dashboard Service Grid per DESIGN.md Section 2)
  /// Menggunakan 6 token warna domain:
  /// 1. Consultation & Chat (#10B981 Emerald)
  /// 2. Mental Health Screening (#0EA5E9 Sky)
  /// 3. Urgent Protection & Anti-Bullying (#F43F5E Coral Rose)
  /// 4. Literacy & Psychoeducation (#F59E0B Amber Gold)
  /// 5. Counseling Schedule (#EA580C Vivid Orange)
  /// 6. Student Community (#14B8A6 Teal Mint)
  Widget _buildFeatureActionGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Layanan Bimbingan Konseling',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '6 Layanan',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 1: Curhat & Skrining
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Curhat & Konsultasi',
                subtitle: 'Chat, voice, atau video bersama Guru BK',
                badge: 'Online',
                icon: Icons.forum_rounded,
                featureColor: AppColors.featureCounseling, // Emerald #10B981
                containerBg: const Color(0xFFD1FAE5),
                onTap: widget.onNavigateToCounseling,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Skrining Mandiri',
                subtitle: 'Deteksi kecemasan & stres non-klinis (GAD-7)',
                badge: '3 Tes Siap',
                icon: Icons.psychology_alt_rounded,
                featureColor: AppColors.featureScreening, // Sky #0EA5E9
                containerBg: const Color(0xFFE0F2FE),
                onTap: widget.onNavigateToScreening,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Row 2: Lapor Kasus & Literasi Jiwa
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Laporkan Kasus',
                subtitle: 'Aduan aman, 100% anonim & anti-perundungan',
                badge: 'UU PDP',
                icon: Icons.shield_rounded,
                featureColor: AppColors.featureReporting, // Coral Rose #F43F5E
                containerBg: const Color(0xFFFFE4E6),
                isConfidentialCard: true, // Distinct 20% tint border per DESIGN.md
                onTap: widget.onNavigateToReport,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Literasi Jiwa',
                subtitle: 'Artikel, podcast & nilai Adat Basandi Syarak',
                badge: '12 Modul',
                icon: Icons.auto_stories_rounded,
                featureColor: AppColors.featureEducation, // Amber Gold #F59E0B
                containerBg: const Color(0xFFFEF3C7),
                onTap: widget.onNavigateToEducation,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Row 3: Jadwal Konseling & Komunitas Sebaya
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Jadwal Konseling',
                subtitle: 'Booking sesi temu & pengingat konseling',
                badge: 'Kalender',
                icon: Icons.event_available_rounded,
                featureColor: AppColors.featureSchedule, // Vivid Orange #EA580C
                containerBg: const Color(0xFFFFEDD5),
                onTap: () {
                  _showComingSoonModal(context, 'Jadwal Konseling', 'Pemesanan jadwal sesi tatap muka langsung di Ruang BK SMAN 1 Padang.');
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Komunitas Sebaya',
                subtitle: 'Forum diskusi & saling dukung sesama siswa',
                badge: 'Sebaya',
                icon: Icons.diversity_3_rounded,
                featureColor: AppColors.featureCommunity, // Teal Mint #14B8A6
                containerBg: const Color(0xFFCCFBF1),
                onTap: () {
                  _showComingSoonModal(context, 'Komunitas Siswa Sebaya', 'Forum diskusi moderasi positif oleh konselor sebaya.');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    required Color featureColor,
    required Color containerBg,
    required VoidCallback onTap,
    bool isConfidentialCard = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 130),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Per DESIGN.md: Kartu Lapor Kasus menggunakan border 1px 20% tint (#F43F5E33)
          border: Border.all(
            color: isConfidentialCard ? AppColors.featureReportingTint : const Color(0xFFF1F5F9),
            width: isConfidentialCard ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isConfidentialCard
                  ? AppColors.featureReporting.withValues(alpha: 0.05)
                  : const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: containerBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: featureColor, size: 20),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: containerBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: featureColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Crisis / Alert Button & Card (Lapor Perundungan per DESIGN.md Section 1)
  /// Background #F43F5E, white text, paired with a shield icon
  Widget _buildCrisisAlertCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2), // Rose soft background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECDD3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.featureReporting.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.featureReporting, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pusat Perlindungan Darurat & Anti-Bullying',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: Color(0xFF9F1239),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Mengalami intimidasi, perundungan, atau ancaman keselamatan fisik & psikologis? Tim BK siap memberikan intervensi segera.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF881337),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          // Primary Crisis Button: 48px height, #F43F5E, white text, shield icon
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.featureReporting, // Coral Rose #F43F5E
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.shield_rounded, size: 18),
              label: const Text('Lapor Perundungan / Krisis Sekarang'),
              onPressed: widget.onNavigateToReport,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorHeroCard(BuildContext context, dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF003C90), // Deep Primary
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PORTAL GURU BK AKTIF',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'NUPTK: ${user.identityNumber}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Konselor Terakreditasi ABKIN • ${user.schoolName ?? "SMAN 1 Padang"}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Penanganan Siswa Binaan',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Kasus Aktif', '2', AppColors.primary, Icons.warning_amber_rounded),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard('Skrining Masuk', '14', AppColors.secondary, Icons.analytics_rounded),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard('Konseling Hari Ini', '1', AppColors.tertiary, Icons.event_available_rounded),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showComingSoonModal(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Mengerti'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRoleSwitcherDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ganti Peran Pengguna (Demo R&D)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pilih akun untuk menguji simulasi hak akses role-based access control (RBAC).',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.school, color: Colors.white, size: 20),
                  ),
                  title: const Text('Siswa: Fajri Pratama (SMAN 1 Padang)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('Akses skrining, buat aduan kasus, chat konseling', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    context.read<AuthBloc>().add(const SwitchRoleEvent(UserRole.student));
                    Navigator.pop(bottomSheetContext);
                  },
                ),
                const SizedBox(height: 6),
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Icon(Icons.psychology, color: Colors.white, size: 20),
                  ),
                  title: const Text('Guru BK: Dra. Rahmi Fadilah, Kons.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('Akses investigasi aduan, ruang konseling & SOAP notes', style: TextStyle(fontSize: 11)),
                  onTap: () {
                    context.read<AuthBloc>().add(const SwitchRoleEvent(UserRole.bkTeacher));
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// CustomPainter untuk menggambar siluet kurva atap Rumah Gadang (Gonjong)
/// Menghadirkan resonansi kultural Minangkabau secara halus (watermark 8% opacity)
class _MinangGonjongWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.7);

    // Gonjong kiri
    path.quadraticBezierTo(size.width * 0.12, size.height * 0.45, size.width * 0.22, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.28, size.height * 0.40, size.width * 0.36, size.height * 0.50);

    // Gonjong tengah kiri
    path.quadraticBezierTo(size.width * 0.42, size.height * 0.30, size.width * 0.48, size.height * 0.08);
    path.quadraticBezierTo(size.width * 0.54, size.height * 0.30, size.width * 0.60, size.height * 0.50);

    // Gonjong kanan
    path.quadraticBezierTo(size.width * 0.68, size.height * 0.40, size.width * 0.76, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.86, size.height * 0.45, size.width, size.height * 0.7);

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
