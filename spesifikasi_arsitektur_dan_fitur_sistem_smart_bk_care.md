# RANCANGAN ARSITEKTUR SISTEM, DESAIN TEKNIS, DAN FITUR

## SMART BK CARE (Sistem Digital Perlindungan, Deteksi Dini, dan Bimbingan Konseling Siswa SMA/SMK Sumatera Barat)
### Berbasis Multiplatform Mobile Framework: Flutter (Dart)

---

## 1. Pendahuluan & Konteks Riset (R&D)

### 1.1 Latar Belakang & Urgensi
Siswa jenjang SMA/SMK di Sumatera Barat menghadapi fase transisi krusial adolesen yang rentan terhadap tekanan akademik, konflik teman sebaya, perundungan (*bullying*), kecemasan masa depan/karir, hingga risiko degradasi kesehatan mental. Keterbatasan rasio guru Bimbingan dan Konseling (BK) terhadap jumlah siswa (standar ideal ABKIN/Permendikbud 1:150 kerap belum terpenuhi merata di seluruh kabupaten/kota) menuntut hadirnya intervensi berbasis teknologi.

Aplikasi **Smart BK Care** dirancang sebagai instrumen penelitian dan intervensi berbasis riset (*Research and Development* / R&D model ADDIE/4D) untuk menjembatani perlindungan, asesmen non-klinis preventif, intervensi dini, dan penguatan ekosistem pendidikan (Siswa, Guru BK, Sekolah, Orang Tua, dan Dinas Pendidikan Sumatera Barat).

### 1.2 Batasan Konseptual & Etika Riset
1. **Bukan Instrumen Diagnosis Klinis**: Modul deteksi dini berfungsi murni sebagai *triage non-klinis* dan pemetaan indikator awal kerentanan psikososial, bukan diagnosis patologis psikiatri otomatis.
2. **Kepatuhan Privasi Data**: Mengacu pada UU No. 27 Tahun 2022 tentang Perlindungan Data Pribadi (UU PDP) dan Kode Etik Asosiasi Bimbingan dan Konseling Indonesia (ABKIN). Kerahasiaan catatan konseling (*client confidentiality*) bersifat absolut.

---

## 2. Arsitektur Sistem Berbasis Flutter (System Architecture)

Aplikasi klien dibangun menggunakan **Flutter SDK** dengan arsitektur **Clean Architecture + Feature-First Structure** serta memanfaatkan pola manajemen *state* teruji (**BLoC / Cubit**). Pola ini memisahkan logika bisnis, presentasi, dan akses data secara modular sehingga memudahkan pengujian unit (*unit testing*) dan pengujian widget (*widget testing*) dalam konteks riset R&D.

```
+------------------------------------------------------------------------------------+
|                         CLIENT LAYER (FLUTTER MULTIPLATFORM)                       |
|                                                                                    |
|  [ Presentation Layer ]                                                            |
|    - Screens, Widgets, BLoC / Cubit State Handlers, Route Guards                   |
|                                                                                    |
|  [ Domain Layer (Pure Dart) ]                                                      |
|    - Entities, UseCases (Interactors), Repository Interfaces                       |
|                                                                                    |
|  [ Data Layer ]                                                                    |
|    - Repository Implementations, Data Sources (Remote & Local), DTO Models         |
|    - Local Encrypted Storage (flutter_secure_storage + Hive AES)                   |
|    - Realtime Engines (WebRTC Signaling, WebSocket Client)                         |
+------------------------------------------+-----------------------------------------+
                                           | HTTPS (TLS 1.3) / WSS (WebSockets)
                                           v
+------------------------------------------------------------------------------------+
|                               API GATEWAY & SECURITY                               |
|  - Kong / Envoy API Gateway (Rate Limiting, Reverse Proxy, SSL Termination)        |
|  - Auth0 / Keycloak Identity Provider (OAuth2 / OIDC, JWT Bearer Verification)     |
|  - WAF (Web Application Firewall) & Anti-Tampering Checks                          |
+------------------------------------------+-----------------------------------------+
                                           | Internal REST API / gRPC
                                           v
+------------------------------------------------------------------------------------+
|                               MICROSERVICES CORE                                   |
|  [ Auth & Identity ]  [ Screening Engine ]   [ Tele-Counseling (WebRTC SFU/Mesh) ] |
|  [ Case Reporting  ]  [ Content & LMS    ]   [ Triage & Notification Engine      ] |
|  [ Analytics Engine]  [ Audit Trail Log  ]   [ Parent Bridge Service             ] |
+------------------------------------------+-----------------------------------------+
                                           |
                                           v
+------------------------------------------------------------------------------------+
|                                    DATA LAYER                                      |
|  - Relational Database (PostgreSQL Cluster): Master Siswa, Sekolah, Log Transaksi  |
|  - Encrypted Document Store (MongoDB): Rekam Catatan Konseling & Kronologi Kasus   |
|  - Cache & Session Store (Redis Cluster): Antrean Socket, Token, Realtime Queue    |
|  - Object Storage (MinIO / S3 Encrypted SSE-KMS): Berkas Bukti Aduan & Dokumen BK  |
+------------------------------------------------------------------------------------+
```

### 2.1 Struktur Proyek Flutter (Feature-First Architecture)

```
lib/
├── core/
│   ├── constants/             # Konfigurasi warna tema Minangkabau, aset, typography
│   ├── network/               # Dio HTTP Client wrapper, interceptors, error handler
│   ├── security/              # Enkripsi lokal, SSL Pinning, jailbreak/root detection
│   ├── theme/                 # Skema Material 3 (AppTheme, ColorScheme)
│   └── utils/                 # Formatters, validator input, helper triase
├── features/
│   ├── auth/                  # Otentikasi & manajemen token JWT
│   ├── screening/             # Modul Deteksi Dini & Instrumen Psikososial
│   │   ├── data/              # Model DTO, Remote DataSource, ScreeningRepositoryImpl
│   │   ├── domain/            # Entities, UseCases (SubmitScreening, GetResultHistory)
│   │   └── presentation/      # BLoC, SkriningScreen, KuisWidget, ResultTriageCard
│   ├── report_case/           # Modul Pelaporan Perlindungan (Anti-Bullying/Kekerasan)
│   ├── tele_counseling/       # Modul Konseling (Chat E2EE, WebRTC Audio/Video)
│   ├── education/             # Modul Materi, Video, Artikel Kesehatan Mental
│   └── dashboard_analytics/   # Dasbor visualisasi data untuk Guru BK & Siswa
└── main.dart                  # Titik masuk aplikasi, bootstrap konfigurasi env
```

### 2.2 Pustaka Kunci Flutter (*Dependencies*)

* **Manajemen State**: `flutter_bloc` & `equatable` (memastikan aliran data searah dan rekonsiliasi state yang deterministik).
* **Jaringan & REST API**: `dio` (mendukung interceptor token refresh otomatis, penanganan timeout, dan *SSL certificate pinning*).
* **Komunikasi Real-time**: `flutter_webrtc` (untuk panggilan video/audio tele-konseling) dan `web_socket_channel` (untuk obrolan interaktif langsung).
* **Keamanan & Penyimpanan Lokal**: `flutter_secure_storage` (menyimpan token JWT dan kunci enkripsi) & `hive` dengan enkripsi AES-256 (menyimpan *cache* kuis dan draf aduan).
* **Visualisasi & Grafik**: `fl_chart` (menampilkan grafik tren hasil skrining dan statistik risiko di perangkat).
* **Autentikasi Biometrik**: `local_auth` (mengamankan pembukaan aplikasi dan catatan rahasia dengan sensor sidik jari/wajah).

---

## 3. Matriks Hak Akses Pengguna (Role-Based Access Control / RBAC)

Sistem membagi hierarki wewenang ke dalam 5 entitas pemangku kepentingan:

| Fitur / Modul | Siswa (Flutter Mobile) | Guru BK / Konselor (Web & Flutter Tab) | Kepala Sekolah / Admin | Orang Tua (Flutter PWA / Mobile) | Dinas Pendidikan Prov. Sumbar (Web Portal) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Registrasi & Profil Mandiri** | Write/Read Sendiri | Read Siswa Binaan | Read Data Sekolah | Read Profil Anak | Read Rekap Agregat |
| **Skrining Mandiri Psikososial** | Take & View Skor | View Rincian Siswa Binaan | Hanya Tren Sekolah | Ringkasan Status Global | View Tren Regional |
| **Pelaporan Kasus Bullying/Kekerasan** | Buat Laporan (Anonim/Identitas) | Kelola, Triage, Investigasi | Status Kasus (Tanpa detail korban jika anonim) | Notifikasi jika melibatkan anak | Notifikasi eskalasi tingkat tinggi |
| **Konseling Online (Chat/Voice/Video)** | Akses dengan Guru BK | Akses & Kelola Room Konseling | Tidak Memiliki Akses (Kerahasiaan) | Tidak Memiliki Akses | Tidak Memiliki Akses |
| **Catatan Kasus Konseling (*Anecdotal Note*)** | Read (Resume Edukatif) | Full Create, Read, Update, Delete | Tidak Memiliki Akses | Ringkasan Rencana Tindak Lanjut | Tidak Memiliki Akses |
| **Dashboard Analitik & Pemetaan Wilayah** | Khusus Progres Diri | Analitik Per Kelas/Angkatan | Analitik Tingkat Sekolah | Khusus Rekomendasi Anak | Peta Makro Se-Sumbar (Heatmap) |

---

## 4. Desain Skema Basis Data (Database Schema)

### 4.1 Entitas Relasional Inti (PostgreSQL DDL Representatif)

```sql
-- Tabel Pengguna & Hak Akses
CREATE TYPE user_role AS ENUM ('STUDENT', 'BK_TEACHER', 'PRINCIPAL', 'PARENT', 'DINAS');
CREATE TYPE risk_level AS ENUM ('LOW', 'MODERATE', 'HIGH', 'SEVERE');

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_id UUID REFERENCES schools(id),
    nisn VARCHAR(10) UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role user_role NOT NULL,
    phone_number VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Master Instrumen Skrining
CREATE TABLE screening_instruments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) UNIQUE NOT NULL, -- Contoh: DASS-21, GAD-7, SDQ-Adolescent
    name VARCHAR(150) NOT NULL,
    description TEXT,
    scale_type VARCHAR(50),
    norm_rules JSONB NOT NULL -- Parameter batas skor dan kategori risiko
);

-- Hasil Asesmen Skrining Siswa
CREATE TABLE screening_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID REFERENCES users(id) ON DELETE CASCADE,
    instrument_id UUID REFERENCES screening_instruments(id),
    raw_score INT NOT NULL,
    calculated_risk risk_level NOT NULL,
    answers_payload JSONB NOT NULL, -- Jawaban butir soal terenkripsi
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    flagged_for_followup BOOLEAN DEFAULT FALSE
);

-- Modul Pelaporan Perlindungan (Anti-Bullying & Kekerasan)
CREATE TYPE report_status AS ENUM ('SUBMITTED', 'VERIFYING', 'IN_COUNSELING', 'ESCALATED', 'RESOLVED');

CREATE TABLE incident_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_code VARCHAR(20) UNIQUE NOT NULL,
    reporter_id UUID REFERENCES users(id), -- Nullable jika pelapor memilih opsi 100% Anonymous
    is_anonymous BOOLEAN DEFAULT FALSE,
    incident_type VARCHAR(50) NOT NULL, -- Cyberbullying, Fisik, Pelecehan, Verbal
    incident_date DATE NOT NULL,
    location TEXT,
    chronology TEXT NOT NULL, -- Dienkripsi dengan AES-256
    evidence_attachments JSONB, -- URL file bukti di bucket terenkripsi
    status report_status DEFAULT 'SUBMITTED',
    assigned_counselor_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Modul Sesi Konseling Digital
CREATE TABLE counseling_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID REFERENCES users(id) NOT NULL,
    counselor_id UUID REFERENCES users(id) NOT NULL,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    channel_type VARCHAR(20) NOT NULL, -- 'CHAT', 'VOICE', 'VIDEO'
    status VARCHAR(30) DEFAULT 'SCHEDULED', -- SCHEDULED, ONGOING, COMPLETED, CANCELLED
    session_token VARCHAR(255),
    counselor_notes_encrypted TEXT, -- Catatan klinis guru BK (Hanya terbaca oleh guru BK terkait)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

---

## 5. Rincian Modul Fungsional Aplikasi (Implementasi Flutter)

### 5.1 Modul Perlindungan Siswa (Safe Reporting System)
* **Formulir Terpandu (*Stepper Wizard*)**: Dibangun dengan `PageView` interaktif pada Flutter untuk mengarahkan pelapor menguraikan kronologi tanpa intimidasi visual.
* **Dual Mode Reporting**: Siswa dapat memilih mode *Identitas Terverifikasi* atau *Kerahasiaan Penuh (Anonim)*. Pada mode anonim, *interceptor* Flutter secara otomatis menghapus header `Authorization` dan identifier perangkat dari muatan (*payload*).
* **Evidence Vault**: Pemanfaatan `image_picker` dan kompresi berkas di sisi klien (`flutter_image_compress`) dengan pembersihan metadata lokasi/EXIF sebelum diunggah via multi-part upload terenkripsi.

### 5.2 Modul Deteksi Dini & Skrining Mandiri
* **Interactive Assessment Engine**: Antarmuka kuis psikososial adaptif menggunakan animasi mulus (`flutter_animate`) untuk meminimalkan kelelahan pengisian (*survey fatigue*).
* **Integrasi Instrumen Psikometri**:
  * *Tingkat Kecemasan*: Adaptasi GAD-7 (*Generalized Anxiety Disorder 7*).
  * *Tingkat Stres & Depresi*: Adaptasi DASS-21 (*Depression Anxiety Stress Scale*).
  * *Kesejahteraan Psikologis*: Skala Resiliensi & *Well-being* Remaja.
  * *Risiko Perilaku*: Deteksi kebiasaan merusak diri (*self-harm thoughts*, adiksi gawai/game, pergaulan bebas).
* **Triase Otomatis Sisi Klien & Server**:
  * Skor Rendah: Menampilkan kurasi modul *self-help* dan audio mindfulness.
  * Skor Sedang: Tombol pintas (*action button*) untuk menjadwalkan konseling santai.
  * Skor Tinggi: Membuka dialog empati dan otomatis memicu *push notification* peringatan dini ke akun Guru BK terkait.

### 5.3 Modul Konseling Digital (Tele-Counseling via WebRTC)
* **Chat Konseling**: Menggunakan WebSocket dengan enkripsi end-to-end lokal (paket `cryptography` Dart) sebelum dikirimkan ke server.
* **Sesi Video & Voice Call**: Menggunakan plugin `flutter_webrtc` terintegrasi dengan STUN/TURN server untuk koneksi peer-to-peer berkualitas tinggi bahkan pada kondisi jaringan seluler 3G/4G di daerah pelosok Sumatera Barat.
* **Fitur Tombol Darurat (*Panic Exit*)**: Tombol cepat di pojok layar konseling yang seketika menutup sesi dan mengalihkan layar ke modul materi edukasi jika privasi fisik siswa terancam dilihat orang lain di sekitarnya.

### 5.4 Modul Literasi & Edukasi Kesehatan Mental
* Penampil konten video edukasi (`video_player` / `chewie`) dan modul infografis ramah kuota.
* Mengusung nilai kearifan lokal Minangkabau (*Adat Basandi Syarak, Syarak Basandi Kitabullah*) yang dipadukan dengan teknik regulasi emosi modern.

### 5.5 Modul Monitoring, Evaluasi, & Dasbor Analitik
* **Sisi Siswa (Flutter)**: Visualisasi radar chart / line chart perkembangan suasana hati (*mood tracking*) mingguan menggunakan `fl_chart`.
* **Sisi Guru BK & Dinas (Web / Responsive Flutter)**: Filter peta sebaran kasus per Cabang Dinas Wilayah I hingga VIII Sumatera Barat, heatmap risiko psikososial, dan rekapitulasi penanganan aduan tanpa membuka data sensitif siswa.

---

## 6. Protokol Keamanan & Kerahasiaan Data (Data Privacy & Compliance)

```
[ Klien Flutter ]
       │
       ├── SSL Pinning (Dio SecurityContext) ──> Menolak Serangan Man-in-the-Middle
       ├── Local Biometric Auth (local_auth)  ──> Proteksi Akses Fisik Gawai
       ├── Root/Jailbreak Detection           ──> Mencegah Inspeksi Memori
       └── Secure Key Store (Keystore/Keychain)
       │
       ▼ (TLS 1.3 Encryption / HTTPS & WSS)
[ API Gateway & Backend ]
       │
       ├── Envelope Encryption (AES-256)      ──> Catatan Khusus Konselor Terisolasi
       ├── Zero Data Retention on Signaling   ──> Video/Audio WebRTC Tidak Direkam
       └── Anonymization Pipeline             ──> Metadata Identitas Dipisah dari Laporan
```

1. **SSL Pinning**: Mencegah intersepsi data melalui teknik Man-in-the-Middle (MitM) dengan menyematkan SHA-256 fingerprint sertifikat server ke dalam konfigurasi jaringan Dio di Flutter.
2. **Local Storage Security**: Seluruh token sesi dan preferensi rahasia disimpan menggunakan `flutter_secure_storage` (berbasis Android Keystore dan iOS Keychain).
3. **Pencegahan Tangkapan Layar**: Menggunakan `flutter_windowmanager` di Android dan proteksi layer di iOS untuk memblokir screenshot/screen record pada halaman konseling dan rekam medis skrining.

---

## 7. Roadmap Implementasi Pengembangan Berbasis Flutter (R&D Timeline)

```
Bulan 1 - 2: Research & Validation
├── FGD bersama Asosiasi Bimbingan dan Konseling Indonesia (ABKIN) Sumbar & Psikologi UNP/Andalas
├── Uji Validitas & Reliabilitas Butir Instrumen Skrining Remaja
├── Finalisasi Wireframe & High-Fidelity UI/UX (Figma to Flutter Design Tokens)
└── Penyusunan Modul BLoC State Management & Repository Pattern

Bulan 3 - 4: Core Flutter Development & Backend Integration
├── Implementasi Autentikasi JWT, Biometrik, & SQLite/Hive Local Cache
├── Pembangunan Fitur Skrining Kuis & Triase Risiko Otomatis
├── Integrasi Modul Konseling (WebSocket Chat + Flutter WebRTC Video Calling)
└── Pembangunan Formulir Aduan Perlindungan Siswa & Vault Bukti

Bulan 5: Security Hardening & Alpha/Beta Testing
├── Pengujian Penetrasi (VAPT) & Verifikasi Enkripsi End-to-End
├── Uji Coba Terbatas (Pilot Project) di 3 Sekolah Percontohan (Kota Padang & Kab. Agam)
└── Pengukuran Pengalaman Pengguna menggunakan System Usability Scale (SUS)

Bulan 6: Evaluasi Lapangan & Publikasi Riset
├── Pengumpulan Data Efektivitas Sistem terhadap Kecepatan Penanganan Masalah BK
├── Diseminasi Hasil Penelitian ke Dinas Pendidikan Provinsi Sumatera Barat
└── Penyusunan Laporan Akhir Disertasi/Tesis & Publikasi Jurnal Bereputasi
```