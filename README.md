# SMART BK CARE
> **Sistem Digital Perlindungan, Deteksi Dini, dan Bimbingan Konseling Siswa SMA/SMK Sumatera Barat**

Smart BK Care adalah platform bimbingan konseling komprehensif berbasis mobile yang mentransformasi persepsi ruang BK menjadi santuari digital yang aman, inklusif, dan bebas stigma bagi siswa SMA/SMK di Sumatera Barat.

Aplikasi ini dibangun dengan arsitektur berstandar tinggi yang mengintegrasikan aspek hukum (**UU Perlindungan Data Pribadi No. 27/2022**), standar etik klinis (**Kode Etik ABKIN**), dan nilai kultural lokal Minangkabau (*Adat Basandi Syarak, Syarak Basandi Kitabullah*).

---

## 🌟 Fitur Utama

1. **Layanan Bimbingan Konseling 6-in-1 (Stitch Design System):**
   - **Curhat & Konsultasi (`#10B981` Emerald):** Tele-konseling chat asimetris (E2EE), panggilan suara, dan video bersama Guru BK terakreditasi ABKIN.
   - **Skrining Mandiri (`#0EA5E9` Sky):** Penilaian psikometri mandiri non-klinis (GAD-7, DASS-Stress, Indeks Kesejahteraan Subjektif) dengan *scoring engine* triase otomatis (Low, Moderate, High, Severe).
   - **Laporan Perlindungan Kasus (`#F43F5E` Coral Rose):** *Dual-mode reporting* (100% Anonim vs Terverifikasi) untuk aduan perundungan (*bullying*) dan kekerasan dengan enkripsi payload.
   - **Literasi Jiwa (`#F59E0B` Amber Gold):** Modul psikoedukasi, artikel kesehatan mental remaja, dan penguatan karakter kearifan lokal.
   - **Jadwal Konseling (`#EA580C` Vivid Orange):** Kalender sesi tatap muka dan pengingat konseling berkala.
   - **Komunitas Sebaya (`#14B8A6` Teal Mint):** Forum dukungan positif yang dimoderasi oleh konselor sebaya.

2. **Protokol Keamanan & Kerahasiaan:**
   - **Panic Exit Button:** Tombol pengalihan cepat yang seketika mengamankan tampilan ke modul edukasi netral jika privasi fisik siswa terancam.
   - **Kepatuhan UU PDP:** Penegasan kerahasiaan identitas dan sterilisasi metadata pada mode pelaporan anonim.

3. **Multi-Role RBAC (Role-Based Access Control):**
   - **Siswa:** Akses skrining, pembuatan aduan rahasia, sesi konseling, dan modul literasi.
   - **Guru BK / Konselor:** Dasbor triase darurat, investigasi aduan, manajemen sesi, dan catatan klinis SOAP (*Subjective, Objective, Assessment, Plan*).

---

## 🏗️ Arsitektur & Teknologi

- **Mobile Framework:** [Flutter](https://flutter.dev) (Dart SDK ^3.7.2)
- **State Management:** `flutter_bloc` (^9.1.1)
- **Routing:** `go_router` (^17.0.0)
- **Dependency Injection:** `get_it` (^9.3.0)
- **Visual Design System:** Google Stitch (`DESIGN.md`)
  - Tipografi: **Plus Jakarta Sans**
  - Grid & Elevasi: 8pt Spatial Rhythm, Ambient Soft Shadow (Level 1 & 2)
  - Nuansa Lokal: Watermark siluet kurva atap *Rumah Gadang* (Gonjong)
- **Backend Architecture (Polyglot Persistence):**
  - **PostgreSQL Cluster:** Master data relasional (`users`, `screening_instruments`, `incident_reports`, `counseling_sessions`).
  - **MongoDB:** Encrypted document store untuk riwayat transkrip chat dan catatan SOAP.
  - **Redis Cluster:** Cache sesi, rate limiting, dan antrean triase darurat.
  - **Flutter Secure Storage:** Penyimpanan token lokal berbasis hardware (*Android Keystore / iOS Keychain*).

---

## 📁 Struktur Direktori

```text
smart-bk/
├── mobile/                                   # Source code aplikasi Flutter
│   ├── lib/
│   │   ├── core/                             # Fondasi arsitektur (Constants, Theme, Router, DI, Security)
│   │   └── features/
│   │       ├── auth/                         # Autentikasi & RBAC
│   │       ├── dashboard/                    # Beranda, Header, 6-Service Grid, Bottom Nav 64px
│   │       ├── screening/                    # Kuesioner psikometri & Scoring engine
│   │       ├── report_case/                  # Safe reporting (100% anonim / terverifikasi)
│   │       ├── tele_counseling/              # Chat konseling, SOAP notes, Panic Exit
│   │       ├── education/                    # Literasi jiwa & Adat Basandi Syarak
│   │       ├── notification/                 # Notifikasi peringatan & reminder
│   │       └── profile/                      # Profil pengguna & demo role switcher
│   └── test/                                 # Unit tests & Widget design conformance tests
├── spesifikasi_arsitektur_dan_fitur_sistem_smart_bk_care.md  # Dokumen arsitektur teknis
└── entity_relationship_diagram_dan_skema_basis_data_smart_bk_care.md # ERD & skema PostgreSQL
```

---

## 🚀 Memulai (Getting Started)

### Prasyarat
- Flutter SDK (versi 3.24.0 atau lebih baru)
- Dart SDK (versi 3.5.0 atau lebih baru)

### Langkah Instalasi
```bash
# 1. Masuk ke direktori mobile
cd mobile

# 2. Unduh dependensi
flutter pub get

# 3. Jalankan pengujian otomatis (Unit & Widget Tests)
flutter test

# 4. Jalankan aplikasi di Chrome atau emulator Android
flutter run -d chrome
```

---

## 📜 Lisensi & Kepatuhan
Dikembangkan untuk penguatan layanan bimbingan konseling dan perlindungan siswa di lingkungan Dinas Pendidikan Provinsi Sumatera Barat dengan mematuhi ketentuan **UU PDP No. 27/2022** dan standar profesi **ABKIN**.
