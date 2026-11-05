import 'package:uuid/uuid.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/screening_entity.dart';
import '../../domain/repositories/screening_repository.dart';

class ScreeningRepositoryImpl implements ScreeningRepository {
  static const _uuid = Uuid();

  // In-Memory store for attempts
  final List<ScreeningAttemptEntity> _attempts = [];

  static final List<ScreeningInstrumentEntity> _mockInstruments = [
    ScreeningInstrumentEntity(
      id: 'inst-gad7-001',
      code: 'GAD-7',
      title: 'Skala Deteksi Kecemasan Remaja (GAD-7)',
      category: InstrumentCategory.anxiety,
      description: 'Instrumen evaluasi gejala kecemasan, kegelisahan, dan ketegangan psikologis selama 2 minggu terakhir.',
      questions: [
        ScreeningQuestionEntity(
          id: 'q-gad7-1',
          orderIndex: 1,
          questionText: 'Merasa gugup, cemas, atau gelisah berlebihan.',
          options: _standardLikertOptions('q-gad7-1'),
        ),
        ScreeningQuestionEntity(
          id: 'q-gad7-2',
          orderIndex: 2,
          questionText: 'Tidak mampu menghentikan atau mengontrol rasa khawatir.',
          options: _standardLikertOptions('q-gad7-2'),
        ),
        ScreeningQuestionEntity(
          id: 'q-gad7-3',
          orderIndex: 3,
          questionText: 'Terlalu mengkhawatirkan berbagai macam hal sekaligus.',
          options: _standardLikertOptions('q-gad7-3'),
        ),
        ScreeningQuestionEntity(
          id: 'q-gad7-4',
          orderIndex: 4,
          questionText: 'Mengalami kesulitan untuk bersantai atau merasa tenang.',
          options: _standardLikertOptions('q-gad7-4'),
        ),
        ScreeningQuestionEntity(
          id: 'q-gad7-5',
          orderIndex: 5,
          questionText: 'Sangat gelisah sehingga sulit untuk duduk diam.',
          options: _standardLikertOptions('q-gad7-5'),
        ),
        ScreeningQuestionEntity(
          id: 'q-gad7-6',
          orderIndex: 6,
          questionText: 'Mudah menjadi jengkel, kesal, atau lekas marah.',
          options: _standardLikertOptions('q-gad7-6'),
        ),
        ScreeningQuestionEntity(
          id: 'q-gad7-7',
          orderIndex: 7,
          questionText: 'Merasa takut seolah-olah sesuatu yang buruk akan segera terjadi.',
          options: _standardLikertOptions('q-gad7-7'),
        ),
      ],
    ),
    ScreeningInstrumentEntity(
      id: 'inst-dass-stress-002',
      code: 'DASS-STRESS',
      title: 'Indikator Tekanan Akademik & Stres Siswa',
      category: InstrumentCategory.stress,
      description: 'Pemetaan respon fisik dan psikologis terhadap beban belajar, ujian, dan relasi pertemanan.',
      questions: [
        ScreeningQuestionEntity(
          id: 'q-dass-1',
          orderIndex: 1,
          questionText: 'Saya merasa sulit untuk beristirahat dan menenangkan diri.',
          options: _standardLikertOptions('q-dass-1'),
        ),
        ScreeningQuestionEntity(
          id: 'q-dass-2',
          orderIndex: 2,
          questionText: 'Saya merasa menggunakan banyak energi emosional saat menghadapi masalah sekolah.',
          options: _standardLikertOptions('q-dass-2'),
        ),
        ScreeningQuestionEntity(
          id: 'q-dass-3',
          orderIndex: 3,
          questionText: 'Saya mendapati diri saya mudah tersinggung oleh hal-hal sepele.',
          options: _standardLikertOptions('q-dass-3'),
        ),
        ScreeningQuestionEntity(
          id: 'q-dass-4',
          orderIndex: 4,
          questionText: 'Saya merasa lelah secara mental dan kehilangan antusiasme belajar.',
          options: _standardLikertOptions('q-dass-4'),
        ),
      ],
    ),
    ScreeningInstrumentEntity(
      id: 'inst-wellbeing-003',
      code: 'WELL-BEING',
      title: 'Skala Kesejahteraan & Resiliensi Remaja',
      category: InstrumentCategory.wellBeing,
      description: 'Mengukur optimisme, perasaan dihargai, kebermaknaan diri, dan hubungan positif di lingkungan sekolah.',
      questions: [
        ScreeningQuestionEntity(
          id: 'q-wb-1',
          orderIndex: 1,
          questionText: 'Saya merasa optimis memikirkan rencana masa depan saya.',
          options: _positiveLikertOptions('q-wb-1'),
        ),
        ScreeningQuestionEntity(
          id: 'q-wb-2',
          orderIndex: 2,
          questionText: 'Saya merasa berguna dan dihargai oleh teman sebaya.',
          options: _positiveLikertOptions('q-wb-2'),
        ),
        ScreeningQuestionEntity(
          id: 'q-wb-3',
          orderIndex: 3,
          questionText: 'Saya dapat mengatasi masalah dan tekanan dengan tenang.',
          options: _positiveLikertOptions('q-wb-3'),
        ),
      ],
    ),
  ];

  static List<QuestionOptionEntity> _standardLikertOptions(String qId) {
    return [
      QuestionOptionEntity(id: '$qId-opt-0', label: 'Tidak Pernah', value: 0),
      QuestionOptionEntity(id: '$qId-opt-1', label: 'Beberapa Hari', value: 1),
      QuestionOptionEntity(id: '$qId-opt-2', label: 'Lebih dari Separuh Waktu', value: 2),
      QuestionOptionEntity(id: '$qId-opt-3', label: 'Hampir Setiap Hari', value: 3),
    ];
  }

  static List<QuestionOptionEntity> _positiveLikertOptions(String qId) {
    return [
      QuestionOptionEntity(id: '$qId-opt-0', label: 'Jarang / Tidak Pernah', value: 0),
      QuestionOptionEntity(id: '$qId-opt-1', label: 'Kadang-kadang', value: 1),
      QuestionOptionEntity(id: '$qId-opt-2', label: 'Seringkali', value: 2),
      QuestionOptionEntity(id: '$qId-opt-3', label: 'Selalu / Sangat Yakin', value: 3),
    ];
  }

  @override
  Future<List<ScreeningInstrumentEntity>> getInstruments() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockInstruments;
  }

  @override
  Future<ScreeningInstrumentEntity> getInstrumentById(String id) async {
    return _mockInstruments.firstWhere(
      (inst) => inst.id == id,
      orElse: () => _mockInstruments.first,
    );
  }

  @override
  Future<ScreeningAttemptEntity> submitScreening({
    required String studentUserId,
    required String instrumentId,
    required Map<String, int> answers,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final instrument = await getInstrumentById(instrumentId);

    int totalScore = 0;
    for (final val in answers.values) {
      totalScore += val;
    }

    // Kalkulasi Ambang Batas Risiko Sesuai Rubrik
    RiskLevel risk;
    bool alertTriggered = false;

    if (totalScore <= 5) {
      risk = RiskLevel.low;
    } else if (totalScore <= 10) {
      risk = RiskLevel.moderate;
    } else if (totalScore <= 14) {
      risk = RiskLevel.high;
      alertTriggered = true;
    } else {
      risk = RiskLevel.severe;
      alertTriggered = true;
    }

    final attempt = ScreeningAttemptEntity(
      id: _uuid.v4(),
      studentUserId: studentUserId,
      instrumentId: instrumentId,
      instrumentTitle: instrument.title,
      totalScore: totalScore,
      calculatedRisk: risk,
      alertTriggered: alertTriggered,
      completedAt: DateTime.now(),
      answers: answers,
    );

    _attempts.insert(0, attempt);
    return attempt;
  }

  @override
  Future<List<ScreeningAttemptEntity>> getAttemptsByStudent(String studentUserId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _attempts.where((a) => a.studentUserId == studentUserId).toList();
  }
}

