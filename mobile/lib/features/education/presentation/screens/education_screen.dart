import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/enums.dart';
import '../../data/repositories/education_repository.dart';
import '../../domain/entities/education_entity.dart';

class EducationScreen extends StatefulWidget {
  final bool isPanicExitLanding;

  const EducationScreen({
    super.key,
    this.isPanicExitLanding = false,
  });

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final EducationRepository _repository = EducationRepositoryImpl();
  List<EducationalContentEntity> _contents = [];
  bool _isLoading = true;
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    setState(() => _isLoading = true);
    final results = await _repository.getPublishedContents(categoryTag: _selectedTag);
    setState(() {
      _contents = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Literasi & Edukasi Mental',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (widget.isPanicExitLanding) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_rounded, color: AppColors.tertiary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Mode Proteksi Privasi Aktif: Layar dialihkan secara aman ke materi literasi umum.',
                            style: TextStyle(fontSize: 12, color: AppColors.tertiary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                _buildTagFilterChips(),
                const SizedBox(height: 16),
                ..._contents.map((item) => _buildContentCard(context, item)),
              ],
            ),
    );
  }

  Widget _buildTagFilterChips() {
    const tags = ['Semua', 'budaya', 'anti-bullying', 'relaksasi'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((t) {
          final isSelected = (t == 'Semua' && _selectedTag == null) || (_selectedTag == t);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(t.toUpperCase()),
              selected: isSelected,
              selectedColor: AppColors.featureEducation.withValues(alpha: 0.18),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.featureEducation : AppColors.textSecondary,
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedTag = (t == 'Semua') ? null : t;
                });
                _loadContents();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, EducationalContentEntity content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  content.type == ContentType.infographic
                      ? Icons.auto_graph_rounded
                      : Icons.article_rounded,
                  color: AppColors.featureEducation,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  content.type == ContentType.infographic ? 'INFOGRAFIS' : 'ARTIKEL EDUKASI',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.featureEducation,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Oleh: ${content.authorName}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                content.contentBody.trim(),
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
