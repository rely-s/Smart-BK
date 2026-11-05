import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/screening_bloc.dart';
import '../../domain/entities/screening_entity.dart';

class ScreeningHubScreen extends StatefulWidget {
  final VoidCallback onNavigateToCounseling;

  const ScreeningHubScreen({
    super.key,
    required this.onNavigateToCounseling,
  });

  @override
  State<ScreeningHubScreen> createState() => _ScreeningHubScreenState();
}

class _ScreeningHubScreenState extends State<ScreeningHubScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScreeningBloc>().add(FetchInstrumentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deteksi Dini Psikososial',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<ScreeningBloc, ScreeningState>(
        listener: (context, state) {
          if (state is ScreeningErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.riskHigh),
            );
          }
        },
        builder: (context, state) {
          if (state is ScreeningLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScreeningActiveState) {
            return _buildQuizEngine(context, state);
          }

          if (state is ScreeningResultState) {
            return _buildResultCard(context, state.attempt);
          }

          if (state is InstrumentsLoadedState) {
            return _buildInstrumentList(context, state.instruments);
          }

          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<ScreeningBloc>().add(FetchInstrumentsEvent()),
              child: const Text('Muat Instrumen Asesmen'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstrumentList(BuildContext context, List<ScreeningInstrumentEntity> instruments) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.tertiary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Asesmen ini bersifat deteksi dini non-klinis untuk membantu pemetaan kondisi emosional Anda, bukan diagnosis medis mutlak.',
                  style: TextStyle(fontSize: 12, color: AppColors.tertiary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Pilih Instrumen Asesmen Mandiri',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...instruments.map((inst) => _buildInstrumentCard(context, inst)),
      ],
    );
  }

  Widget _buildInstrumentCard(BuildContext context, ScreeningInstrumentEntity instrument) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.featureScreening.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    instrument.code,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.featureScreening,
                    ),
                  ),
                ),
                Text(
                  '${instrument.questions.length} Butir Soal',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              instrument.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              instrument.description,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                context.read<ScreeningBloc>().add(SelectInstrumentEvent(instrument));
              },
              child: const Text('Mulai Asesmen Mandiri'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizEngine(BuildContext context, ScreeningActiveState state) {
    final instrument = state.instrument;
    final currentIndex = state.currentQuestionIndex;
    final question = instrument.questions[currentIndex];
    final selectedValue = state.answers[question.id];
    final progress = (currentIndex + 1) / instrument.questions.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Butir ${currentIndex + 1} dari ${instrument.questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  context.read<ScreeningBloc>().add(ResetScreeningEvent());
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            color: AppColors.featureScreening,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                question.questionText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilihlah respon yang paling menggambarkan diri Anda:',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final opt = question.options[idx];
                final isSelected = selectedValue == opt.value;
                return InkWell(
                  onTap: () {
                    context.read<ScreeningBloc>().add(
                          AnswerQuestionEvent(questionId: question.id, value: opt.value),
                        );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.featureScreening.withValues(alpha: 0.08) : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.featureScreening : AppColors.divider,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            opt.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.featureScreening : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: AppColors.featureCounseling, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              if (currentIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<ScreeningBloc>().add(PreviousQuestionEvent());
                    },
                    child: const Text('Sebelumnya'),
                  ),
                ),
              if (currentIndex > 0) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedValue == null
                      ? null
                      : () {
                          if (currentIndex < instrument.questions.length - 1) {
                            context.read<ScreeningBloc>().add(NextQuestionEvent());
                          } else {
                            final authState = context.read<AuthBloc>().state;
                            final studentId = authState is Authenticated
                                ? authState.user.id
                                : 'anon-student';
                            context.read<ScreeningBloc>().add(SubmitAnswersEvent(studentId));
                          }
                        },
                  child: Text(
                    currentIndex < instrument.questions.length - 1
                        ? 'Berikutnya'
                        : 'Selesaikan & Lihat Hasil',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, ScreeningAttemptEntity attempt) {
    Color riskColor;
    String recommendationTitle;
    String recommendationDesc;

    switch (attempt.calculatedRisk) {
      case RiskLevel.low:
        riskColor = AppColors.riskLow;
        recommendationTitle = 'Kondisi Emosional Sehat & Adaptif';
        recommendationDesc =
            'Tingkat kecemasan Anda berada pada batas aman. Terus pertahankan pola istirahat, relaksasi pernapasan, dan interaksi positif bersama teman.';
        break;
      case RiskLevel.moderate:
        riskColor = AppColors.riskModerate;
        recommendationTitle = 'Terdapat Indikator Ketegangan Sedang';
        recommendationDesc =
            'Beban belajar atau dinamika pergaulan mulai mempengaruhi kestabilan emosi Anda. Disarankan mencoba modul relaksasi mandiri atau berbincang santai dengan Guru BK.';
        break;
      case RiskLevel.high:
      case RiskLevel.severe:
        riskColor = AppColors.riskHigh;
        recommendationTitle = 'Perhatian Khusus Diperlukan (Alert Triase)';
        recommendationDesc =
            'Skor asesmen menunjukkan Anda sedang memikul tekanan psikologis yang cukup berat. Konselor Guru BK siap mendampingi Anda melalui sesi konseling daring yang aman dan rahasia.';
        break;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: riskColor.withValues(alpha: 0.15),
                  child: Icon(Icons.assessment_rounded, color: riskColor, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  attempt.instrumentTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attempt.calculatedRisk.labelIndonesian,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Skor Terhitung: ${attempt.totalScore}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const Divider(height: 32),
                Text(
                  recommendationTitle,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  recommendationDesc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
                if (attempt.alertTriggered) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.riskHigh.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.privacy_tip_outlined, color: AppColors.riskHigh, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sistem telah mengirimkan notifikasi pendampingan ke Guru BK sekolah Anda.',
                            style: TextStyle(fontSize: 11, color: AppColors.riskHigh),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (attempt.calculatedRisk != RiskLevel.low)
            ElevatedButton.icon(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Jadwalkan Konseling Guru BK'),
              onPressed: widget.onNavigateToCounseling,
            ),
          const SizedBox(height: 10),
          OutlinedButton(
            child: const Text('Kembali ke Daftar Instrumen'),
            onPressed: () {
              context.read<ScreeningBloc>().add(ResetScreeningEvent());
            },
          ),
        ],
      ),
    );
  }
}
