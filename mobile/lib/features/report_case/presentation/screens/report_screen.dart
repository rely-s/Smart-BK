import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/report_bloc.dart';
import '../../domain/entities/incident_report_entity.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form State
  bool _isAnonymous = true;
  IncidentType _selectedType = IncidentType.verbalBullying;
  final CaseUrgency _urgencyLevel = CaseUrgency.medium;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _chronologyController = TextEditingController();
  final TextEditingController _ticketSearchController = TextEditingController();
  final List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _locationController.dispose();
    _chronologyController.dispose();
    _ticketSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Layanan Perlindungan Siswa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Buat Aduan Kasus'),
            Tab(text: 'Lacak Status Tiket'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreateReportTab(context),
          _buildTrackTicketTab(context),
        ],
      ),
    );
  }

  Widget _buildCreateReportTab(BuildContext context) {
    return BlocConsumer<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportSubmittedSuccess) {
          _showReportSuccessDialog(context, state.report);
        } else if (state is ReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.riskHigh),
          );
        }
      },
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPrivacyNoticeBanner(),
              const SizedBox(height: 16),
              _buildAnonymousToggleCard(),
              const SizedBox(height: 16),
              const Text(
                'Kategori Perundungan / Kasus',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildIncidentTypeDropdown(),
              const SizedBox(height: 16),
              const Text(
                'Lokasi Kejadian',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Di belakang kantin sekolah / Grup WhatsApp kelas',
                  prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Uraian Kronologi Peristiwa',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _chronologyController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Uraikan apa yang terjadi, waktu peristiwa, dan siapa saja pihak yang terlibat. Kerahasiaan Anda dijamin aman.',
                ),
              ),
              const SizedBox(height: 16),
              _buildAttachmentSection(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.featureReporting,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.shield_rounded),
                label: const Text('Kirim Pengaduan Aman (Dilindungi Enkripsi)'),
                onPressed: _submitReport,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrivacyNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.featureReportingTint, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.featureReporting.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_rounded, color: AppColors.featureReporting, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Aduan Anda dilindungi oleh Tim Pencegahan dan Penanganan Kekerasan (TPPK) Sekolah & ABKIN. Anda berhak memilih mode 100% anonim.',
              style: TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymousToggleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isAnonymous ? Icons.visibility_off_rounded : Icons.verified_user_rounded,
                      color: _isAnonymous ? AppColors.featureReporting : AppColors.featureCounseling,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isAnonymous ? 'Mode 100% Anonim' : 'Mode Terverifikasi',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _isAnonymous
                      ? 'Nama & NISN tidak akan terlihat oleh siapapun'
                      : 'Identitas hanya diketahui Guru BK sekolah',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
            Switch(
              value: _isAnonymous,
              activeColor: AppColors.featureReporting,
              onChanged: (val) {
                setState(() {
                  _isAnonymous = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentTypeDropdown() {
    return DropdownButtonFormField<IncidentType>(
      value: _selectedType,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.category_outlined, color: AppColors.textMuted),
      ),
      items: IncidentType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.labelIndonesian, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) setState(() => _selectedType = val);
      },
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bukti Lampiran (Tangkapan Layar / Dokumen)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.attach_file_rounded),
          label: const Text('Tambah Bukti (Otomatis Bersihkan Metadata EXIF)'),
          onPressed: () {
            setState(() {
              _attachments.add('bukti_aduan_${DateTime.now().millisecondsSinceEpoch}.jpg');
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lampiran simulasi berhasil ditambahkan.')),
            );
          },
        ),
        if (_attachments.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._attachments.map(
            (file) => Chip(
              label: Text(file, style: const TextStyle(fontSize: 11)),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                setState(() => _attachments.remove(file));
              },
            ),
          ),
        ],
      ],
    );
  }

  void _submitReport() {
    final location = _locationController.text.trim();
    final chronology = _chronologyController.text.trim();

    if (location.isEmpty || chronology.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi lokasi dan uraian kronologi kejadian.'),
          backgroundColor: AppColors.riskHigh,
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    String? reporterId;
    String? reporterName;
    String schoolId = 'a11bbd91-382a-4389-a541-11910cf90001';
    String schoolName = 'SMAN 1 Padang';

    if (authState is Authenticated) {
      if (!_isAnonymous) {
        reporterId = authState.user.id;
        reporterName = authState.user.fullName;
      }
      schoolId = authState.user.schoolId ?? schoolId;
      schoolName = authState.user.schoolName ?? schoolName;
    }

    context.read<ReportBloc>().add(
          SubmitReportEvent(
            reporterUserId: reporterId,
            reporterName: reporterName,
            isAnonymous: _isAnonymous,
            schoolId: schoolId,
            schoolName: schoolName,
            incidentType: _selectedType,
            incidentDate: DateTime.now(),
            location: location,
            chronology: chronology,
            urgencyLevel: _urgencyLevel,
            attachments: _attachments,
          ),
        );
  }

  void _showReportSuccessDialog(BuildContext context, IncidentReportEntity report) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.syarakGreen),
              SizedBox(width: 8),
              Text('Aduan Terkirim', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Laporan berhasil dienkripsi dan diteruskan ke Guru BK. Simpan nomor tiket ini untuk memantau proses tindak lanjut:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Center(
                  child: SelectableText(
                    report.ticketNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                report.isAnonymous
                    ? 'Status: 100% Anonim (Privasi Terjamin)'
                    : 'Status: Terverifikasi atas nama ${report.reporterName}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _locationController.clear();
                _chronologyController.clear();
                _tabController.animateTo(1);
                _ticketSearchController.text = report.ticketNumber;
                context.read<ReportBloc>().add(TrackTicketEvent(report.ticketNumber));
              },
              child: const Text('Lacak Tiket Sekarang'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrackTicketTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ticketSearchController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Nomor Tiket (BK-REP-...)',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(80, 50)),
                onPressed: () {
                  final query = _ticketSearchController.text.trim();
                  if (query.isNotEmpty) {
                    context.read<ReportBloc>().add(TrackTicketEvent(query));
                  }
                },
                child: const Text('Cek'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportTicketFound) {
                  return _buildTicketDetailCard(context, state.report);
                } else if (state is ReportTicketNotFound) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 8),
                        Text(
                          'Nomor tiket "${state.ticketNumber}" tidak ditemukan.',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'Masukkan nomor tiket aduan untuk memeriksa status investigasi.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetailCard(BuildContext context, IncidentReportEntity report) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.ticketNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report.status.labelIndonesian,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'Jenis Aduan: ${report.incidentType.labelIndonesian}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Lokasi: ${report.location}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Guru BK Penanggung Jawab: ${report.assignedCounselorName ?? "Belum Ditugaskan"}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Kronologi Kasus: "${report.chronology}"',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
