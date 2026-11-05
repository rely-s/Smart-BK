import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Notifikasi & Peringatan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Tandai Dibaca',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildNotificationItem(
            context,
            icon: Icons.shield_rounded,
            iconColor: AppColors.featureReporting,
            bgColor: const Color(0xFFFFE4E6),
            title: 'Laporan Aduan Diproses',
            subtitle: 'Aduan #BK-REP-202611-8291 sedang dalam tahap asesmen tertutup oleh Tim BK SMAN 1 Padang.',
            time: '10 menit lalu',
            isUnread: true,
          ),
          const SizedBox(height: 10),
          _buildNotificationItem(
            context,
            icon: Icons.psychology_alt_rounded,
            iconColor: AppColors.featureScreening,
            bgColor: const Color(0xFFE0F2FE),
            title: 'Hasil Skrining Berkala Siap',
            subtitle: 'Evaluasi ketenangan emosional GAD-7 Anda menunjukkan kondisi stabil. Pertahankan ritme belajarmu!',
            time: '2 jam lalu',
            isUnread: true,
          ),
          const SizedBox(height: 10),
          _buildNotificationItem(
            context,
            icon: Icons.forum_rounded,
            iconColor: AppColors.featureCounseling,
            bgColor: const Color(0xFFD1FAE5),
            title: 'Pengingat Sesi Konseling',
            subtitle: 'Sesi konseling tatap muka bersama Dra. Rahmi Fadilah dijadwalkan besok pukul 09.30 WIB di Ruang BK Sanctuary.',
            time: 'Kemarin',
            isUnread: false,
          ),
          const SizedBox(height: 10),
          _buildNotificationItem(
            context,
            icon: Icons.auto_stories_rounded,
            iconColor: AppColors.featureEducation,
            bgColor: const Color(0xFFFEF3C7),
            title: 'Materi Literasi Baru Ditambahkan',
            subtitle: 'Simak artikel: "Mengelola Stres Ujian dengan Nilai Adat Basandi Syarak".',
            time: '2 hari lalu',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread ? AppColors.primary.withValues(alpha: 0.25) : const Color(0xFFF1F5F9),
          width: isUnread ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

