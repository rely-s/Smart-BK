/// Enum pemetaan peran pengguna (Sesuai skema PostgreSQL user_role)
enum UserRole {
  student,
  bkTeacher,
  principal,
  parent,
  dinas;

  static UserRole fromString(String value) {
    switch (value.toUpperCase()) {
      case 'STUDENT':
        return UserRole.student;
      case 'BK_TEACHER':
        return UserRole.bkTeacher;
      case 'PRINCIPAL':
        return UserRole.principal;
      case 'PARENT':
        return UserRole.parent;
      case 'DINAS':
        return UserRole.dinas;
      default:
        return UserRole.student;
    }
  }

  String toDbValue() {
    switch (this) {
      case UserRole.student:
        return 'STUDENT';
      case UserRole.bkTeacher:
        return 'BK_TEACHER';
      case UserRole.principal:
        return 'PRINCIPAL';
      case UserRole.parent:
        return 'PARENT';
      case UserRole.dinas:
        return 'DINAS';
    }
  }
}

/// Kategori tingkat risiko psikososial non-klinis
enum RiskLevel {
  low,
  moderate,
  high,
  severe;

  static RiskLevel fromString(String value) {
    switch (value.toUpperCase()) {
      case 'LOW':
        return RiskLevel.low;
      case 'MODERATE':
        return RiskLevel.moderate;
      case 'HIGH':
        return RiskLevel.high;
      case 'SEVERE':
        return RiskLevel.severe;
      default:
        return RiskLevel.low;
    }
  }

  String toDbValue() {
    switch (this) {
      case RiskLevel.low:
        return 'LOW';
      case RiskLevel.moderate:
        return 'MODERATE';
      case RiskLevel.high:
        return 'HIGH';
      case RiskLevel.severe:
        return 'SEVERE';
    }
  }

  String get labelIndonesian {
    switch (this) {
      case RiskLevel.low:
        return 'Rendah (Sehat / Adaptif)';
      case RiskLevel.moderate:
        return 'Sedang (Butuh Perhatian)';
      case RiskLevel.high:
        return 'Tinggi (Butuh Konseling)';
      case RiskLevel.severe:
        return 'Kritis (Perlu Tindakan Cepat)';
    }
  }
}

/// Kategori instrumen asesmen psikometri
enum InstrumentCategory {
  anxiety,
  stress,
  depression,
  wellBeing,
  behavioralRisk;

  static InstrumentCategory fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ANXIETY':
        return InstrumentCategory.anxiety;
      case 'STRESS':
        return InstrumentCategory.stress;
      case 'DEPRESSION':
        return InstrumentCategory.depression;
      case 'WELL_BEING':
        return InstrumentCategory.wellBeing;
      case 'BEHAVIORAL_RISK':
        return InstrumentCategory.behavioralRisk;
      default:
        return InstrumentCategory.anxiety;
    }
  }

  String toDbValue() {
    switch (this) {
      case InstrumentCategory.anxiety:
        return 'ANXIETY';
      case InstrumentCategory.stress:
        return 'STRESS';
      case InstrumentCategory.depression:
        return 'DEPRESSION';
      case InstrumentCategory.wellBeing:
        return 'WELL_BEING';
      case InstrumentCategory.behavioralRisk:
        return 'BEHAVIORAL_RISK';
    }
  }
}

/// Jenis insiden aduan perlindungan siswa
enum IncidentType {
  verbalBullying,
  physicalBullying,
  cyberBullying,
  sexualHarassment,
  extortion,
  other;

  static IncidentType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'VERBAL_BULLYING':
        return IncidentType.verbalBullying;
      case 'PHYSICAL_BULLYING':
        return IncidentType.physicalBullying;
      case 'CYBER_BULLYING':
        return IncidentType.cyberBullying;
      case 'SEXUAL_HARASSMENT':
        return IncidentType.sexualHarassment;
      case 'EXTORTION':
        return IncidentType.extortion;
      default:
        return IncidentType.other;
    }
  }

  String toDbValue() {
    switch (this) {
      case IncidentType.verbalBullying:
        return 'VERBAL_BULLYING';
      case IncidentType.physicalBullying:
        return 'PHYSICAL_BULLYING';
      case IncidentType.cyberBullying:
        return 'CYBER_BULLYING';
      case IncidentType.sexualHarassment:
        return 'SEXUAL_HARASSMENT';
      case IncidentType.extortion:
        return 'EXTORTION';
      case IncidentType.other:
        return 'OTHER';
    }
  }

  String get labelIndonesian {
    switch (this) {
      case IncidentType.verbalBullying:
        return 'Perundungan Verbal (Ejekan/Hinaan)';
      case IncidentType.physicalBullying:
        return 'Perundungan Fisik (Kekerasan)';
      case IncidentType.cyberBullying:
        return 'Perundungan Daring (Cyberbullying)';
      case IncidentType.sexualHarassment:
        return 'Pelecehan Seksual';
      case IncidentType.extortion:
        return 'Pemalakan / Pemerasan';
      case IncidentType.other:
        return 'Lainnya';
    }
  }
}

/// Urgensi kasus
enum CaseUrgency {
  low,
  medium,
  high,
  critical;

  static CaseUrgency fromString(String value) {
    switch (value.toUpperCase()) {
      case 'LOW':
        return CaseUrgency.low;
      case 'MEDIUM':
        return CaseUrgency.medium;
      case 'HIGH':
        return CaseUrgency.high;
      case 'CRITICAL':
        return CaseUrgency.critical;
      default:
        return CaseUrgency.medium;
    }
  }

  String toDbValue() {
    switch (this) {
      case CaseUrgency.low:
        return 'LOW';
      case CaseUrgency.medium:
        return 'MEDIUM';
      case CaseUrgency.high:
        return 'HIGH';
      case CaseUrgency.critical:
        return 'CRITICAL';
    }
  }
}

/// Status alur penanganan tiket aduan
enum CaseStatus {
  submitted,
  verified,
  investigation,
  inCounseling,
  escalatedDinas,
  resolved,
  dismissed;

  static CaseStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'SUBMITTED':
        return CaseStatus.submitted;
      case 'VERIFIED':
        return CaseStatus.verified;
      case 'INVESTIGATION':
        return CaseStatus.investigation;
      case 'IN_COUNSELING':
        return CaseStatus.inCounseling;
      case 'ESCALATED_DINAS':
        return CaseStatus.escalatedDinas;
      case 'RESOLVED':
        return CaseStatus.resolved;
      case 'DISMISSED':
        return CaseStatus.dismissed;
      default:
        return CaseStatus.submitted;
    }
  }

  String toDbValue() {
    switch (this) {
      case CaseStatus.submitted:
        return 'SUBMITTED';
      case CaseStatus.verified:
        return 'VERIFIED';
      case CaseStatus.investigation:
        return 'INVESTIGATION';
      case CaseStatus.inCounseling:
        return 'IN_COUNSELING';
      case CaseStatus.escalatedDinas:
        return 'ESCALATED_DINAS';
      case CaseStatus.resolved:
        return 'RESOLVED';
      case CaseStatus.dismissed:
        return 'DISMISSED';
    }
  }

  String get labelIndonesian {
    switch (this) {
      case CaseStatus.submitted:
        return 'Laporan Diterima';
      case CaseStatus.verified:
        return 'Diverifikasi Guru BK';
      case CaseStatus.investigation:
        return 'Proses Investigasi';
      case CaseStatus.inCounseling:
        return 'Dalam Penanganan Konseling';
      case CaseStatus.escalatedDinas:
        return 'Dieskalasi ke Dinas';
      case CaseStatus.resolved:
        return 'Kasus Selesai';
      case CaseStatus.dismissed:
        return 'Ditutup / Tidak Terbukti';
    }
  }
}

/// Kanal sesi konseling
enum ChannelType {
  chat,
  voice,
  video,
  inPerson;

  static ChannelType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CHAT':
        return ChannelType.chat;
      case 'VOICE':
        return ChannelType.voice;
      case 'VIDEO':
        return ChannelType.video;
      case 'IN_PERSON':
        return ChannelType.inPerson;
      default:
        return ChannelType.chat;
    }
  }

  String toDbValue() {
    switch (this) {
      case ChannelType.chat:
        return 'CHAT';
      case ChannelType.voice:
        return 'VOICE';
      case ChannelType.video:
        return 'VIDEO';
      case ChannelType.inPerson:
        return 'IN_PERSON';
    }
  }
}

/// Status sesi konseling
enum SessionStatus {
  pending,
  confirmed,
  active,
  completed,
  cancelled,
  noShow;

  static SessionStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return SessionStatus.pending;
      case 'CONFIRMED':
        return SessionStatus.confirmed;
      case 'ACTIVE':
        return SessionStatus.active;
      case 'COMPLETED':
        return SessionStatus.completed;
      case 'CANCELLED':
        return SessionStatus.cancelled;
      case 'NO_SHOW':
        return SessionStatus.noShow;
      default:
        return SessionStatus.pending;
    }
  }

  String toDbValue() {
    switch (this) {
      case SessionStatus.pending:
        return 'PENDING';
      case SessionStatus.confirmed:
        return 'CONFIRMED';
      case SessionStatus.active:
        return 'ACTIVE';
      case SessionStatus.completed:
        return 'COMPLETED';
      case SessionStatus.cancelled:
        return 'CANCELLED';
      case SessionStatus.noShow:
        return 'NO_SHOW';
    }
  }
}


/// Tipe materi edukasi
enum ContentType {
  article,
  infographic,
  video,
  podcastAudio,
  modulePdf;

  static ContentType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ARTICLE':
        return ContentType.article;
      case 'INFOGRAPHIC':
        return ContentType.infographic;
      case 'VIDEO':
        return ContentType.video;
      case 'PODCAST_AUDIO':
        return ContentType.podcastAudio;
      case 'MODULE_PDF':
        return ContentType.modulePdf;
      default:
        return ContentType.article;
    }
  }

  String toDbValue() {
    switch (this) {
      case ContentType.article:
        return 'ARTICLE';
      case ContentType.infographic:
        return 'INFOGRAPHIC';
      case ContentType.video:
        return 'VIDEO';
      case ContentType.podcastAudio:
        return 'PODCAST_AUDIO';
      case ContentType.modulePdf:
        return 'MODULE_PDF';
    }
  }
}

/// Tipe notifikasi sistem
enum NotificationType {
  screeningAlert,
  caseUpdate,
  sessionReminder,
  systemInfo;

  static NotificationType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'SCREENING_ALERT':
        return NotificationType.screeningAlert;
      case 'CASE_UPDATE':
        return NotificationType.caseUpdate;
      case 'SESSION_REMINDER':
        return NotificationType.sessionReminder;
      case 'SYSTEM_INFO':
        return NotificationType.systemInfo;
      default:
        return NotificationType.systemInfo;
    }
  }

  String toDbValue() {
    switch (this) {
      case NotificationType.screeningAlert:
        return 'SCREENING_ALERT';
      case NotificationType.caseUpdate:
        return 'CASE_UPDATE';
      case NotificationType.sessionReminder:
        return 'SESSION_REMINDER';
      case NotificationType.systemInfo:
        return 'SYSTEM_INFO';
    }
  }
}
