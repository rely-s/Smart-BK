import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Dashboard Screen Smart BK Care (Beranda)
/// Mengimplementasikan 100% spesifikasi antarmuka visual https://smart-bk-care-sumatera-barat.ai.studio:
/// - Header: Menu drawer, Logo gradient dengan ikon volunteer_activism, judul "Smart BK Care" dengan blue dot, subtitle "SUMATERA BARAT", notifikasi bell dengan unread badge.
/// - Sidebar Drawer: Identitas siswa (FR), 6 Layanan BK dengan badge status, Menu Lainnya, dan Role Switcher.
/// - Student Sanctuary Hero Card: Kartu putih bersih dengan border halus, siluet watermark Gonjong Minangkabau, badge hijau berdenyut "Ruang Aman Siswa SMA Negeri 1 Padang", sapaan ramah, dan jaminan kerahasiaan data.
/// - Search Bar: Input pencarian modern dengan icon tune dan daftar rekomendasi cepat interaktif.
/// - Grid Layanan Bimbingan Konseling: 6 kartu layanan 2 kolom dengan palet warna spesifik domain dan micro-copy persis AI Studio.
/// - Banner Inspirasi Pelajar Minang: Kartu gradien biru Jam Gadang dengan dialog "Kisah Fajar: Cerita Itu Kekuatan".
/// - Modal Komunitas Pelajar Sebaya (Circle Pelajar).
class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToCounseling;
  final VoidCallback onNavigateToEducation;
  final VoidCallback onNavigateToScreening;
  final VoidCallback onNavigateToReport;
  final VoidCallback onNavigateToNotification;
  final VoidCallback onNavigateToProfile;

  const DashboardScreen({
    super.key,
    required this.onNavigateToCounseling,
    required this.onNavigateToEducation,
    required this.onNavigateToScreening,
    required this.onNavigateToReport,
    required this.onNavigateToNotification,
    required this.onNavigateToProfile,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;
  String _searchQuery = '';

  // Data rekomendasi pencarian cepat sesuai smart-bk-care-sumatera-barat.ai.studio
  final List<_SearchSuggestion> _allSuggestions = const [
    _SearchSuggestion(
      label: 'Curhat dengan Guru BK',
      icon: Icons.chat_bubble_rounded,
      target: _SearchTarget.counseling,
    ),
    _SearchSuggestion(
      label: 'Cek Kecemasan Ujian',
      icon: Icons.psychology_rounded,
      target: _SearchTarget.screening,
    ),
    _SearchSuggestion(
      label: 'Reservasi Konseling Tatap Muka',
      icon: Icons.event_rounded,
      target: _SearchTarget.counseling,
    ),
    _SearchSuggestion(
      label: 'Lapor Perundungan Anonim',
      icon: Icons.shield_rounded,
      target: _SearchTarget.report,
    ),
    _SearchSuggestion(
      label: 'Modul Mengatasi Stres',
      icon: Icons.menu_book_rounded,
      target: _SearchTarget.education,
    ),
  ];

  // Komunitas circle siswa yang diikuti (default: circle-1 aktif)
  final Set<String> _joinedCircles = {'circle-1'};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
        _isSearchActive = _searchQuery.isNotEmpty || _searchFocusNode.hasFocus;
      });
    });
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchActive = _searchQuery.isNotEmpty || _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSuggestionTap(_SearchTarget target) {
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });

    switch (target) {
      case _SearchTarget.counseling:
        widget.onNavigateToCounseling();
        break;
      case _SearchTarget.screening:
        widget.onNavigateToScreening();
        break;
      case _SearchTarget.report:
        widget.onNavigateToReport();
        break;
      case _SearchTarget.education:
        widget.onNavigateToEducation();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            backgroundColor: const Color(0xFFFAF8FF),
            appBar: _buildCustomHeader(context),
            drawer: _buildSidebarDrawer(context, user),
            body: GestureDetector(
              onTap: () {
                if (_searchFocusNode.hasFocus) {
                  _searchFocusNode.unfocus();
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.isStudent) ...[
                      // 1. Student Sanctuary Hero Card (White Card with Gonjong Watermark)
                      _buildStudentSanctuaryHeroCard(user),
                      const SizedBox(height: 16),

                      // 2. Search Bar dengan Live Suggestions Dropdown
                      _buildSearchBar(),
                      const SizedBox(height: 16),

                      // 3. Layanan Bimbingan Konseling (Two-Column Grid)
                      _buildServicesSection(),
                      const SizedBox(height: 16),

                      // 4. Inspirasi Pelajar Minang Banner (Jam Gadang Watermark)
                      _buildInspirasiMinangBanner(),
                    ] else ...[
                      // Mode Tampilan Khusus Guru BK
                      _buildCounselorHeroCard(user),
                      const SizedBox(height: 16),
                      _buildCounselorOverview(),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Color(0xFFFAF8FF),
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      },
    );
  }

  // ==========================================
  // 1. APP BAR HEADER (PERSIS AI STUDIO)
  // ==========================================
  PreferredSizeWidget _buildCustomHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.98),
      elevation: 0,
      scrolledUnderElevation: 1,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color(0xFFE2E8F0),
          height: 1.0,
        ),
      ),
      title: Row(
        children: [
          // Tombol Buka Menu Sidebar Drawer
          Builder(
            builder: (ctx) => InkWell(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  size: 22,
                  color: Color(0xFF334155),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Logo Gradien Smart BK Care
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003C90), Color(0xFF0F52BA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003C90).withValues(alpha: 0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),

          // Judul Smart BK Care & Subtitle SUMATERA BARAT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Smart BK Care',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF131B2E),
                        letterSpacing: -0.3,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F52BA),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'SUMATERA BARAT',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.9,
                    height: 1.1,
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
        // Tombol Notifikasi Siswa dengan Badge Titik Merah
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: widget.onNavigateToNotification,
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: Color(0xFF64748B),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. SIDEBAR DRAWER (PERSIS AI STUDIO)
  // ==========================================
  Widget _buildSidebarDrawer(BuildContext context, UserEntity user) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header Drawer Gradien dengan Siluet Gonjong
            Container(
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF003C90), Color(0xFF0F52BA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.12,
                      child: CustomPaint(
                        size: const Size(100, 50),
                        painter: _MinangGonjongSilhouettePainter(),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.volunteer_activism_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Smart BK Care',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  Text(
                                    'SUMATERA BARAT',
                                    style: TextStyle(
                                      color: Color(0xFFBFDBFE),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                user.fullName.isNotEmpty
                                    ? user.fullName.split(' ').map((e) => e[0]).take(2).join()
                                    : 'FR',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    user.schoolName ?? 'SMA Negeri 1 Padang',
                                    style: const TextStyle(
                                      color: Color(0xFFBFDBFE),
                                      fontSize: 10.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(color: const Color(0xFF6EE7B7).withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, color: Color(0xFF6EE7B7), size: 6),
                                  SizedBox(width: 4),
                                  Text(
                                    'Aktif',
                                    style: TextStyle(
                                      color: Color(0xFFD1FAE5),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Daftar Menu Layanan BK Sesuai ai_studio.js
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FITUR LAYANAN BK',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          '6 Layanan',
                          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildDrawerItem(
                    icon: Icons.psychology_rounded,
                    iconColor: const Color(0xFF0284C7),
                    bgColor: const Color(0xFFF0F9FF),
                    title: 'Skrining Perasaan',
                    subtitle: 'Deteksi cemas, stres & suasana hati',
                    badge: '3 Topik',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToScreening();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.forum_rounded,
                    iconColor: const Color(0xFF003C90),
                    bgColor: const Color(0xFFEFF6FF),
                    title: 'Ruang Sesi Chat',
                    subtitle: 'Konseling privat & terenkripsi BK',
                    badge: 'Online',
                    isBadgePulse: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToCounseling();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_month_rounded,
                    iconColor: const Color(0xFF0D9488),
                    bgColor: const Color(0xFFF0FDFA),
                    title: 'Reservasi Konseling',
                    subtitle: 'Jadwal tatap muka / daring resmi',
                    badge: 'Dispensasi',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToCounseling();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.shield_rounded,
                    iconColor: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    title: 'Lapor Rahasia',
                    subtitle: 'Pengaduan perundungan 100% aman',
                    badge: 'Anonim',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToReport();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.menu_book_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    bgColor: const Color(0xFFF5F3FF),
                    title: 'Edukasi & Literasi',
                    subtitle: 'Video, modul, artikel & podcast',
                    badge: 'Modul Gratis',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToEducation();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFFFBEB),
                    title: 'Analitik Sumbar',
                    subtitle: 'Data psikososial 19 Kab/Kota',
                    badge: 'Dinas Sumbar',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showInfographicsDialog();
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFF1F5F9), height: 1),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'MENU LAINNYA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  _buildSimpleDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Beranda Utama',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _buildSimpleDrawerItem(
                    icon: Icons.supervisor_account_rounded,
                    title: 'Dashboard Guru BK',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showRoleSwitcherDialog(context);
                    },
                  ),
                  _buildSimpleDrawerItem(
                    icon: Icons.account_circle_rounded,
                    title: 'Profil & Identitas Siswa',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToProfile();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required String badge,
    bool isBadgePulse = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isBadgePulse ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(9999),
                          border: isBadgePulse
                              ? Border.all(color: const Color(0xFFA7F3D0))
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isBadgePulse) ...[
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 3),
                            ],
                            Text(
                              badge,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isBadgePulse
                                    ? const Color(0xFF047857)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF64748B)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. STUDENT SANCTUARY HERO CARD (KARTU PUTIH PERSIS AI STUDIO)
  // ==========================================
  Widget _buildStudentSanctuaryHeroCard(UserEntity user) {
    final firstName = user.fullName.split(' ').first;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Siluet Watermark Gonjong Minangkabau di Sudut Kanan Bawah
          Positioned(
            right: -8,
            bottom: -8,
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                size: const Size(120, 100),
                painter: _MinangGonjongSilhouettePainter(color: const Color(0xFF003C90)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge Pill: Ruang Aman Siswa SMA Negeri 1 Padang (Pulsing Dot Hijau)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0xFFA7F3D0).withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Ruang Aman Siswa ${user.schoolName ?? "SMA Negeri 1 Padang"}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF065F46),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Greeting Headline: Halo, Fajar! 👋
                Text(
                  'Halo, $firstName! 👋',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF131B2E),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle: Ada hal yang mengganjal atau ingin kamu ceritakan...
                const Text(
                  'Ada hal yang mengganjal atau ingin kamu ceritakan hari ini? Guru BK siap mendengarkan tanpa menghakimi.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),

                // Jaminan Keamanan & Kode Etik Konseling
                const Row(
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 14,
                      color: Color(0xFF0F52BA),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Kerahasiaan data dijamin & terlindungi kode etik konseling',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. SEARCH BAR DENGAN LIVE DROPDOWN
  // ==========================================
  Widget _buildSearchBar() {
    final filtered = _allSuggestions.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF131B2E),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Cari info materi, curhat, atau jadwal konseling...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                  onPressed: () => _searchController.clear(),
                  visualDensity: VisualDensity.compact,
                ),
              IconButton(
                icon: const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF94A3B8)),
                onPressed: widget.onNavigateToEducation,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),

        // Dropdown Saran Pencarian Cepat
        if (_isSearchActive && _searchQuery.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Text(
                    'HASIL PENCARIAN CEPAT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                if (filtered.isNotEmpty)
                  ...filtered.map(
                    (s) => InkWell(
                      onTap: () => _handleSuggestionTap(s.target),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            Icon(s.icon, size: 18, color: const Color(0xFF003C90)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                s.label,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'Tidak ada menu terkait. Ketuk tombol konseling untuk bertanya langsung.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // 5. GRID LAYANAN BIMBINGAN KONSELING (6 KARTU 2-KOLOM)
  // ==========================================
  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Seksi: Layanan Bimbingan Konseling + Badge Terlindungi & Rahasia
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Layanan Bimbingan Konseling',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF131B2E),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: Color(0xFF0F52BA),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Terlindungi & Rahasia',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F52BA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Grid 6 Kartu (2 Kolom)
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                title: 'Curhat & Konseling',
                subtitle: 'Chat, voice, video',
                cta: 'Mulai sesi',
                icon: Icons.chat_bubble_rounded,
                iconColor: const Color(0xFF0F52BA),
                bgColor: const Color(0xFFEFF6FF),
                onTap: widget.onNavigateToCounseling,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildServiceCard(
                title: 'Tes Kesehatan Mental',
                subtitle: 'Refleksi mandiri',
                cta: 'Cek kondisi',
                icon: Icons.psychology_rounded,
                iconColor: const Color(0xFF4F46E5),
                bgColor: const Color(0xFFEEF2FF),
                onTap: widget.onNavigateToScreening,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                title: 'Lapor Kasus',
                subtitle: 'Aman & anonim',
                cta: 'Laporkan',
                icon: Icons.shield_rounded,
                iconColor: const Color(0xFFE11D48),
                bgColor: const Color(0xFFFFF1F2),
                onTap: widget.onNavigateToReport,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildServiceCard(
                title: 'Materi Edukasi',
                subtitle: 'Artikel & tips remaja',
                cta: 'Buka modul',
                icon: Icons.menu_book_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
                onTap: widget.onNavigateToEducation,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                title: 'Jadwal Konseling',
                subtitle: 'Reservasi sesi',
                cta: 'Pilih waktu',
                icon: Icons.event_rounded,
                iconColor: const Color(0xFF059669),
                bgColor: const Color(0xFFECFDF5),
                onTap: widget.onNavigateToCounseling,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildServiceCard(
                title: 'Komunitas Siswa',
                subtitle: 'Ruang berbagi sebaya',
                cta: 'Gabung circle',
                icon: Icons.groups_rounded,
                iconColor: const Color(0xFF0891B2),
                bgColor: const Color(0xFFECFEFF),
                onTap: _showCommunityDialog,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String cta,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.02),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF131B2E),
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    cta,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: iconColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 14,
                  color: iconColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 6. BANNER INSPIRASI PELAJAR MINANG (JAM GADANG)
  // ==========================================
  Widget _buildInspirasiMinangBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F52BA), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F52BA).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Siluet Watermark Jam Gadang di Sudut Kanan Bawah
          Positioned(
            right: 4,
            bottom: -6,
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(
                size: const Size(100, 120),
                painter: _JamGadangSilhouettePainter(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag Inspirasi Pelajar Minang
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'INSPIRASI PELAJAR MINANG',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Judul
                const SizedBox(
                  width: 240,
                  child: Text(
                    '“Cerita Itu Kekuatan, Bukan Kelemahan”',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                const SizedBox(
                  width: 240,
                  child: Text(
                    'Konseling membantu kamu menata pikiran dan melangkah pasti menuju masa depan gemilang.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFDBEAFE),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Baris Tombol Aksi & Badge Konselor Berlisensi
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    InkWell(
                      onTap: _showStoryDialog,
                      borderRadius: BorderRadius.circular(9999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Baca Kisah Fajar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003C90),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF003C90)),
                          ],
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 15,
                          color: Color(0xFF34D399),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Konselor Berlisensi',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFDBEAFE),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. DIALOG: KISAH FAJAR (PERSIS AI STUDIO)
  // ==========================================
  void _showStoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'INSPIRASI PELAJAR MINANG',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003C90),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kisah Fajar: “Cerita Itu Kekuatan”',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(ctx).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFF1F5F9), height: 20),
                const Text(
                  '“Dulu, menjelang ujian kenaikan kelas dan pemilihan jurusan kuliah, saya sering begadang semalaman karena takut gagal. Pikiran saya penuh dengan ekspektasi orang tua dan rasa takut tertinggal oleh teman-teman.”',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.5),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: const Text(
                    '“Saya kira datang ke Ruang BK itu hanya untuk siswa yang bermasalah. Ternyata anggapan itu salah besar.”',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003C90),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '“Bersama Ibu Rahmi Yunita di Ruang BK SMAN 1 Padang, saya belajar mengurai kecemasan saya satu per satu. Beliau tidak pernah menghakimi, melainkan membimbing saya menemukan gaya belajar yang tepat dan memetakan minat karir saya secara realistis.”',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.5),
                ),
                const SizedBox(height: 10),
                const Text(
                  '“Kini saya merasa jauh lebih percaya diri menghadapi ujian. Jangan ragu bercerita, karena membuka perasaan bukanlah tanda kelemahan, melainkan awal dari kekuatanmu.”',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      widget.onNavigateToCounseling();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003C90),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_rounded, size: 16),
                        SizedBox(width: 8),
                        Text('Mulai Cerita dengan Guru BK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 8. DIALOG: KOMUNITAS SISWA (CIRCLE PELAJAR)
  // ==========================================
  void _showCommunityDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final circles = [
            _CommunityCircle(
              id: 'circle-1',
              name: 'Pejuang SNBP & Kampus Impian',
              members: '1.420 Siswa',
              desc: 'Ruang sharing tips lolos perguruan tinggi negeri, analisis nilai rapor, dan manajemen ambisi sehat.',
              badge: 'Akademik',
              badgeBg: const Color(0xFFDBEAFE),
              badgeColor: const Color(0xFF003C90),
            ),
            _CommunityCircle(
              id: 'circle-2',
              name: 'Sahabat Upstander Anti-Bullying',
              members: '890 Siswa',
              desc: 'Komunitas pelajar SMA/SMK se-Sumbar yang berkomitmen menciptakan iklim sekolah aman, inklusif, dan bebas perundungan.',
              badge: 'Sosial & Perlindungan',
              badgeBg: const Color(0xFFD1FAE5),
              badgeColor: const Color(0xFF065F46),
            ),
            _CommunityCircle(
              id: 'circle-3',
              name: 'Ruang Bernapas & Manajemen Stres',
              members: '1.150 Siswa',
              desc: 'Saling bertukar cerita ringan, tips istirahat produktif, serta musik dan hobi pereda penat sekolah.',
              badge: 'Kesejahteraan',
              badgeBg: const Color(0xFFFEF3C7),
              badgeColor: const Color(0xFF92400E),
            ),
          ];

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(20),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Komunitas Siswa Minang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Circle Berbagi Sebaya Terpantau BK',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.of(ctx).pop(),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    ...circles.map((c) {
                      final isJoined = _joinedCircles.contains(c.id);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isJoined ? const Color(0xFF0F52BA) : const Color(0xFFE2E8F0),
                            width: isJoined ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: c.badgeBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    c.badge,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color: c.badgeColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  c.members,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.desc,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.4),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  setModalState(() {
                                    if (isJoined) {
                                      _joinedCircles.remove(c.id);
                                    } else {
                                      _joinedCircles.add(c.id);
                                    }
                                  });
                                  setState(() {});
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isJoined ? const Color(0xFFEFF6FF) : Colors.white,
                                  foregroundColor: const Color(0xFF003C90),
                                  side: BorderSide(
                                    color: isJoined ? const Color(0xFF003C90) : const Color(0xFFCBD5E1),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: Text(
                                  isJoined ? '✓ Tergabung dalam Circle' : '+ Gabung Circle',
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 9. DIALOG INFOGRAFIS ARSITEKTUR SUMBAR
  // ==========================================
  void _showInfographicsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Arsitektur Smart BK Care',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFF1F5F9), height: 16),
              const Text(
                'Ekosistem Bimbingan Konseling Digital Provinsi Sumatera Barat mengintegrasikan:',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 10),
              _buildBulletPoint('19 Cabang Dinas Pendidikan Kabupaten/Kota se-Sumbar'),
              _buildBulletPoint('Portal Terenkripsi Guru BK & Konselor Bersertifikat'),
              _buildBulletPoint('Saluran Pelaporan Perundungan 100% Terlindungi ABKIN'),
              _buildBulletPoint('Integrasi Nilai Filosofi Minangkabau "Adat Basandi Syarak"'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003C90),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 10. DIALOG ROLE SWITCHER (SISWA / GURU BK / DINAS)
  // ==========================================
  void _showRoleSwitcherDialog(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final state = authBloc.state;
    if (state is! Authenticated) return;

    final currentRole = state.user.role;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Simulasi Peran Pengguna',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih peran untuk menguji antarmuka pengguna sesuai hak akses:',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              _buildRoleOption(
                ctx,
                authBloc,
                title: 'Siswa SMA Negeri 1 Padang',
                subtitle: 'Akses santuari konseling, skrining, edukasi, lapor aduan anonim',
                icon: Icons.school_rounded,
                role: UserRole.student,
                isSelected: currentRole == UserRole.student,
              ),
              const SizedBox(height: 8),
              _buildRoleOption(
                ctx,
                authBloc,
                title: 'Guru BK / Konselor Sekolah',
                subtitle: 'Manajemen kasus, jadwal tatap muka, asesmen klinis, chat siswa',
                icon: Icons.psychology_rounded,
                role: UserRole.bkTeacher,
                isSelected: currentRole == UserRole.bkTeacher,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleOption(
    BuildContext context,
    AuthBloc authBloc, {
    required String title,
    required String subtitle,
    required IconData icon,
    required UserRole role,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        authBloc.add(SwitchRoleEvent(role));
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF003C90) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF003C90) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF003C90) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF003C90), size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // VIEW MODE: GURU BK
  // ==========================================
  Widget _buildCounselorHeroCard(UserEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003C90), Color(0xFF0F52BA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  'PORTAL GURU BK AKTIF',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                user.schoolName ?? 'SMAN 1 Padang',
                style: const TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Selamat Bertugas, ${user.fullName}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ruang pantau kesehatan mental siswa & penanganan aduan terenkripsi.',
            style: TextStyle(fontSize: 12, color: Color(0xFFDBEAFE)),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Antrean Layanan BK',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF131B2E)),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCounselorStatCard('3', 'Aduan Masuk', 'Perlu asesmen awal', const Color(0xFFFFF1F2), const Color(0xFFE11D48)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCounselorStatCard('5', 'Sesi Konseling', 'Hari ini', const Color(0xFFEFF6FF), const Color(0xFF003C90)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounselorStatCard(String count, String label, String sub, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: textCol.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textCol)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textCol)),
          Text(sub, style: TextStyle(fontSize: 10.5, color: textCol.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

enum _SearchTarget {
  counseling,
  screening,
  report,
  education,
}

class _SearchSuggestion {
  final String label;
  final IconData icon;
  final _SearchTarget target;

  const _SearchSuggestion({
    required this.label,
    required this.icon,
    required this.target,
  });
}

class _CommunityCircle {
  final String id;
  final String name;
  final String members;
  final String desc;
  final String badge;
  final Color badgeBg;
  final Color badgeColor;

  const _CommunityCircle({
    required this.id,
    required this.name,
    required this.members,
    required this.desc,
    required this.badge,
    required this.badgeBg,
    required this.badgeColor,
  });
}

/// CustomPainter untuk Siluet Gonjong Minangkabau (Watermark)
class _MinangGonjongSilhouettePainter extends CustomPainter {
  final Color color;

  _MinangGonjongSilhouettePainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Menggambar siluet kurva lengkung atap Gonjong Minangkabau
    path.moveTo(w * 0.05, h * 0.85);
    path.quadraticBezierTo(w * 0.30, h * 0.75, w * 0.45, h * 0.40);
    path.quadraticBezierTo(w * 0.50, h * 0.15, w * 0.50, h * 0.05);
    path.quadraticBezierTo(w * 0.50, h * 0.15, w * 0.55, h * 0.40);
    path.quadraticBezierTo(w * 0.70, h * 0.75, w * 0.95, h * 0.85);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MinangGonjongSilhouettePainter oldDelegate) => oldDelegate.color != color;
}

/// CustomPainter untuk Siluet Jam Gadang Bukittinggi (Watermark)
class _JamGadangSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Badan menara Jam Gadang dan atap Gonjong
    path.moveTo(w * 0.42, h);
    path.lineTo(w * 0.42, h * 0.55);
    path.lineTo(w * 0.36, h * 0.55);
    path.lineTo(w * 0.36, h * 0.46);
    path.lineTo(w * 0.40, h * 0.46);
    path.lineTo(w * 0.40, h * 0.33);
    path.lineTo(w * 0.34, h * 0.33);
    path.lineTo(w * 0.34, h * 0.25);
    path.lineTo(w * 0.45, h * 0.17);
    path.lineTo(w * 0.48, h * 0.04);
    path.lineTo(w * 0.50, 0);
    path.lineTo(w * 0.52, h * 0.04);
    path.lineTo(w * 0.55, h * 0.17);
    path.lineTo(w * 0.66, h * 0.25);
    path.lineTo(w * 0.66, h * 0.33);
    path.lineTo(w * 0.60, h * 0.33);
    path.lineTo(w * 0.60, h * 0.46);
    path.lineTo(w * 0.64, h * 0.46);
    path.lineTo(w * 0.64, h * 0.55);
    path.lineTo(w * 0.58, h * 0.55);
    path.lineTo(w * 0.58, h);
    path.close();

    canvas.drawPath(path, paint);

    // Titik lingkaran jam pada menara
    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.50, h * 0.32), w * 0.05, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
