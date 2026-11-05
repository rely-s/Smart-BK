import 'package:equatable/equatable.dart';
import 'package:smart_bk_care/core/constants/enums.dart';

class EducationalContentEntity extends Equatable {
  final String id;
  final String title;
  final ContentType type;
  final String contentBody;
  final String? mediaUrl;
  final List<String> tags;
  final DateTime publishedAt;
  final String authorName;

  const EducationalContentEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.contentBody,
    this.mediaUrl,
    required this.tags,
    required this.publishedAt,
    required this.authorName,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        contentBody,
        mediaUrl,
        tags,
        publishedAt,
        authorName,
      ];
}
