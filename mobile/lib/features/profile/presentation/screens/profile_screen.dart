import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
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
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              title: const Text(
                'Profil Siswa & Akun',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user.isStudent
                                    ? 'NISN: ${user.identityNumber}'
                                    : 'NUPTK: ${user.identityNumber}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  user.isStudent ? 'Siswa Aktif Terverifikasi' : 'Guru BK Bersertifikat',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // School & Security Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Satuan Pendidikan', user.schoolName ?? 'SMAN 1 Padang'),
                        const Divider(height: 20, color: Color(0xFFF1F5F9)),
                        _buildInfoRow('Kelas / Rombel', user.gradeClass ?? 'XI-F2 (Fase F)'),
                        const Divider(height: 20, color: Color(0xFFF1F5F9)),
                        _buildInfoRow('Privasi Data', 'Dilindungi UU PDP No. 27/2022'),
                        const Divider(height: 20, color: Color(0xFFF1F5F9)),
                        _buildInfoRow('Protokol Keamanan', 'Terenkripsi AES-256 GCM'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Role Switcher Demo Action
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Simulasi Peran Pengguna (RBAC Demo)',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Uji coba antarmuka antara akun Siswa dan Guru BK untuk evaluasi fitur.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(const SwitchRoleEvent(UserRole.student));
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: user.isStudent ? AppColors.primaryContainer : Colors.transparent,
                                  side: BorderSide(
                                    color: user.isStudent ? AppColors.primary : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  'Peran Siswa',
                                  style: TextStyle(
                                    color: user.isStudent ? AppColors.primary : AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(const SwitchRoleEvent(UserRole.bkTeacher));
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: user.role == UserRole.bkTeacher ? const Color(0xFFD1FAE5) : Colors.transparent,
                                  side: BorderSide(
                                    color: user.role == UserRole.bkTeacher ? AppColors.tertiary : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  'Peran Guru BK',
                                  style: TextStyle(
                                    color: user.role == UserRole.bkTeacher ? AppColors.tertiary : AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

