import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            backgroundColor: const Color(0xFFFAF8FF),
            appBar: AppBar(
              title: const Text(
                'Profil & Akun Siswa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
              child: Column(
                children: [
                  // 1. Profile Hero Card Gradien (Sesuai AI Studio)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF003C90), Color(0xFF0F52BA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF003C90).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                user.fullName.isNotEmpty
                                    ? user.fullName.split(' ').map((e) => e[0]).take(2).join()
                                    : 'FR',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Text(
                                      user.isStudent ? 'SISWA TERVERIFIKASI BK' : 'GURU BK BERSERTIFIKAT',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.isStudent
                                        ? 'NISN: ${user.identityNumber} • ${user.schoolName ?? "SMA Negeri 1 Padang"}'
                                        : 'NUPTK: ${user.identityNumber} • ${user.schoolName ?? "SMA Negeri 1 Padang"}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFDBEAFE),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (user.isStudent)
                                    Text(
                                      user.gradeClass ?? 'Kelas XI IPA 2',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFBFDBFE),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Status Psikososial:',
                                style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 11.5),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6FFBBE),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.circle, size: 6, color: Color(0xFF006544)),
                                    SizedBox(width: 5),
                                    Text(
                                      'Stabil & Terpantau Baik',
                                      style: TextStyle(
                                        color: Color(0xFF002113),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
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
                  ),
                  const SizedBox(height: 14),

                  // 2. Simulasi Multi-Peran Sistem (3 Tombol: Siswa, Guru BK, Dinas)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SIMULASI MULTI-PERAN SISTEM',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              'Pilih Tampilan Layar',
                              style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildRoleButton(
                                context,
                                label: 'Siswa',
                                icon: Icons.school_rounded,
                                isSelected: user.role == UserRole.student,
                                onTap: () {
                                  context.read<AuthBloc>().add(const SwitchRoleEvent(UserRole.student));
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildRoleButton(
                                context,
                                label: 'Guru BK',
                                icon: Icons.psychology_rounded,
                                isSelected: user.role == UserRole.bkTeacher,
                                onTap: () {
                                  context.read<AuthBloc>().add(const SwitchRoleEvent(UserRole.bkTeacher));
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildRoleButton(
                                context,
                                label: 'Dinas Sumbar',
                                icon: Icons.bar_chart_rounded,
                                isSelected: false,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Portal Dinas Pendidikan Provinsi Sumatera Barat'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Quick Stats Cards (3 Sesi Selesai, 4 Refleksi, 2 Modul Simpan)
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickStatCard('3', 'Sesi Selesai', const Color(0xFF003C90)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickStatCard('4', 'Refleksi', const Color(0xFF059669)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickStatCard('2', 'Modul Simpan', const Color(0xFFD97706)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 4. Menu & Security Features List (Persis AI Studio)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuListItem(
                          icon: Icons.architecture_rounded,
                          iconColor: const Color(0xFF003C90),
                          title: 'Infografis Lengkap Smart BK Care',
                          subtitle: 'Arsitektur & Ekosistem SMA/SMK se-Sumbar',
                          onTap: () {
                            _showInfographicsDialog(context);
                          },
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 1),
                        _buildMenuListItem(
                          icon: Icons.shield_rounded,
                          iconColor: const Color(0xFF059669),
                          title: 'Enkripsi Data Pribadi',
                          subtitle: 'Standar Kerahasiaan ABKIN & Dinas',
                          badge: 'Aktif',
                          badgeBg: const Color(0xFFECFDF5),
                          badgeColor: const Color(0xFF047857),
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 1),
                        _buildMenuListItem(
                          icon: Icons.family_restroom_rounded,
                          iconColor: const Color(0xFF006398),
                          title: 'Kontak Darurat Terkoneksi',
                          subtitle: 'Bapak H. Rahmatullah (0812-9988-xxxx)',
                          badge: 'Terkonfirmasi',
                          badgeBg: const Color(0xFFEFF6FF),
                          badgeColor: const Color(0xFF1D4ED8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequestedEvent());
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text(
                        'Keluar dari Akun',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE11D48),
                        side: const BorderSide(color: Color(0xFFFECDD3)),
                        backgroundColor: const Color(0xFFFFF1F2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Color(0xFFFAF8FF),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildRoleButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF003C90) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF003C90) : const Color(0xFF64748B),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF003C90) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeBg,
    Color? badgeColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg ?? const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: badgeColor ?? const Color(0xFF475569),
                  ),
                ),
              )
            else
              const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  void _showInfographicsDialog(BuildContext context) {
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
}
