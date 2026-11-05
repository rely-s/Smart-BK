import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/counseling_bloc.dart';
import '../../domain/entities/counseling_entity.dart';

class CounselingHubScreen extends StatefulWidget {
  final VoidCallback onPanicExitToEducation;

  const CounselingHubScreen({
    super.key,
    required this.onPanicExitToEducation,
  });

  @override
  State<CounselingHubScreen> createState() => _CounselingHubScreenState();
}

class _CounselingHubScreenState extends State<CounselingHubScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserSessions();
  }

  void _loadUserSessions() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<CounselingBloc>().add(
            FetchUserSessionsEvent(
              userId: authState.user.id,
              isCounselor: authState.user.isCounselor,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Konseling Daring Terenkripsi',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<CounselingBloc, CounselingState>(
        listener: (context, state) {
          if (state is PanicExitState) {
            widget.onPanicExitToEducation();
          } else if (state is CounselingErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.riskHigh),
            );
          }
        },
        builder: (context, state) {
          if (state is CounselingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatActiveState) {
            return _buildActiveChatView(context, state);
          }

          if (state is SessionsLoadedState) {
            return _buildSessionsList(context, state.sessions);
          }

          return Center(
            child: ElevatedButton(
              onPressed: _loadUserSessions,
              child: const Text('Muat Sesi Konseling'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
        label: const Text('Jadwal Baru', style: TextStyle(color: Colors.white)),
        onPressed: () => _showRequestSessionDialog(context),
      ),
    );
  }

  Widget _buildSessionsList(BuildContext context, List<CounselingSessionEntity> sessions) {
    if (sessions.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada riwayat sesi konseling aktif.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final session = sessions[idx];
        final authState = context.read<AuthBloc>().state;
        final isCounselor = authState is Authenticated && authState.user.isCounselor;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          session.channel == ChannelType.chat
                              ? Icons.chat_rounded
                              : Icons.video_call_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          session.channel == ChannelType.chat ? 'Sesi Chat E2EE' : 'Panggilan Video',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: session.status == SessionStatus.active
                            ? AppColors.riskLow.withValues(alpha: 0.15)
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        session.status == SessionStatus.active ? 'SEDANG AKTIF' : 'SELESAI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: session.status == SessionStatus.active
                              ? AppColors.riskLow
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  isCounselor
                      ? 'Siswa Bimbingan: ${session.studentName}'
                      : 'Konselor Guru BK: ${session.counselorName}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jadwal: ${_formatDateTime(session.scheduledStart)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.forum_outlined, size: 18),
                        label: const Text('Buka Ruang Konseling'),
                        onPressed: () {
                          final currentUserId =
                              authState is Authenticated ? authState.user.id : '';
                          context.read<CounselingBloc>().add(
                                OpenSessionChatEvent(
                                  sessionId: session.id,
                                  currentUserId: currentUserId,
                                ),
                              );
                        },
                      ),
                    ),
                    if (isCounselor) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Catatan SOAP Rahasia',
                        icon: const Icon(Icons.note_alt_outlined, color: AppColors.tertiary),
                        onPressed: () => _showSoapNoteDialog(context, session),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveChatView(BuildContext context, ChatActiveState state) {
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState is Authenticated ? authState.user.id : '';
    final currentUserName = authState is Authenticated ? authState.user.fullName : 'Pengguna';
    final TextEditingController textController = TextEditingController();

    return Column(
      children: [
        // Panic Exit & E2EE Info Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _loadUserSessions,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sesi Rahasia (E2EE)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      'Enkripsi end-to-end aktif',
                      style: TextStyle(fontSize: 11, color: AppColors.tertiary),
                    ),
                  ],
                ),
              ),
              // Panic Exit Emergency Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.featureReporting,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size.zero,
                ),
                icon: const Icon(Icons.shield_rounded, size: 16),
                label: const Text('TUTUP CEPAT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                onPressed: () {
                  context.read<CounselingBloc>().add(PanicExitTriggeredEvent());
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Messages List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.messages.length,
            itemBuilder: (context, idx) {
              final msg = state.messages[idx];
              final isMine = msg.senderUserId == currentUserId;

              return Align(
                alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  decoration: BoxDecoration(
                    color: isMine ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMine ? 16 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 16),
                    ),
                    border: isMine ? null : Border.all(color: AppColors.divider),
                    boxShadow: isMine
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(alpha: 0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            msg.senderName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isMine ? Colors.white.withValues(alpha: 0.9) : AppColors.primary,
                            ),
                          ),
                          if (!isMine) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.featureCounseling.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Konselor ABKIN',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.featureCounseling,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        msg.content,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: isMine ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            size: 10,
                            color: isMine ? Colors.white70 : AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Terenkripsi End-to-End',
                            style: TextStyle(
                              fontSize: 10,
                              color: isMine ? Colors.white70 : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Input bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white,
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan rahasia...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        context.read<CounselingBloc>().add(
                              SendChatMessageEvent(
                                sessionId: state.sessionId,
                                senderUserId: currentUserId,
                                senderName: currentUserName,
                                text: text,
                              ),
                            );
                        textController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showRequestSessionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajukan Jadwal Konseling Baru',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih metode bimbingan bersama Guru BK sekolah Anda:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Sesi Chat Tertulis (E2EE)'),
                onPressed: () {
                  _executeRequest(ChannelType.chat);
                  Navigator.pop(bottomSheetContext);
                },
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.video_call_outlined),
                label: const Text('Sesi Video Call Terproteksi'),
                onPressed: () {
                  _executeRequest(ChannelType.video);
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _executeRequest(ChannelType channel) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<CounselingBloc>().add(
            RequestNewSessionEvent(
              studentUserId: authState.user.id,
              studentName: authState.user.fullName,
              counselorUserId: 'e28bbd91-382a-4389-a541-11910cf90022',
              counselorName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
              channel: channel,
              scheduledStart: DateTime.now().add(const Duration(hours: 2)),
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal konseling berhasil diajukan.')),
      );
    }
  }

  void _showSoapNoteDialog(BuildContext context, CounselingSessionEntity session) {
    final subjectiveCtrl = TextEditingController(text: 'Siswa mengeluhkan tekanan persiapan ujian.');
    final objectiveCtrl = TextEditingController(text: 'Konseli responsif dan kooperatif.');
    final assessmentCtrl = TextEditingController(text: 'Kecemasan akademik situasional non-klinis.');
    final planCtrl = TextEditingController(text: 'Latihan relaksasi otot dan pendampingan mingguan.');

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Rekam Catatan Kasus (SOAP)', style: TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Subjective (Keluhan Siswa):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                TextField(controller: subjectiveCtrl, maxLines: 2),
                const SizedBox(height: 8),
                const Text('Objective (Observasi Konselor):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                TextField(controller: objectiveCtrl, maxLines: 2),
                const SizedBox(height: 8),
                const Text('Assessment (Analisis Masalah):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                TextField(controller: assessmentCtrl, maxLines: 2),
                const SizedBox(height: 8),
                const Text('Plan (Rencana Intervensi):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                TextField(controller: planCtrl, maxLines: 2),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                final authState = context.read<AuthBloc>().state;
                final counselorId = authState is Authenticated ? authState.user.id : '';
                context.read<CounselingBloc>().add(
                      SaveSoapNoteEvent(
                        sessionId: session.id,
                        counselorUserId: counselorId,
                        subjective: subjectiveCtrl.text,
                        objective: objectiveCtrl.text,
                        assessment: assessmentCtrl.text,
                        intervention: planCtrl.text,
                      ),
                    );
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Catatan SOAP tersimpan terenkripsi.')),
                );
              },
              child: const Text('Simpan SOAP'),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} • ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} WIB';
  }
}
