# Smart BK Care - Mobile Client (Flutter)

Aplikasi mobile resmi **Smart BK Care** untuk siswa dan guru BK SMA/SMK Sumatera Barat.

Dibangun dengan arsitektur **Clean Architecture**, manajemen status **BLoC Pattern**, dan sistem desain visual **Google Stitch (`DESIGN.md`)**.

---

## 📱 Fitur Modul Aplikasi
- **Dashboard Beranda:** Header modern, Search bar (48px), Category chips (36px), Student Sanctuary Hero Card ber-watermark atap *Rumah Gadang* (Gonjong), Grid 6-Layanan Konseling, dan tombol darurat krisis anti-perundungan (`#F43F5E`).
- **Ruang Konseling & Curhat:** Chat asimetris E2EE, pencatatan SOAP clinical notes, dan Panic Exit button.
- **Skrining Mandiri Psikometri:** Kuesioner GAD-7, DASS-Stress, dan Well-Being Index dengan kalkulasi triase risiko instan.
- **Lapor Perlindungan Kasus:** Pelaporan aduan perundungan dengan opsi 100% Anonim vs Terverifikasi berstandar UU PDP No. 27/2022.
- **Literasi Jiwa & Nilai:** Psikoedukasi remaja berbasis nilai kearifan lokal Minangkabau (*Adat Basandi Syarak*).
- **Notifikasi & Profil:** Manajemen akun, verifikasi NISN/NUPTK, dan *role-switcher* (RBAC Demo).
- **Navigasi Bawah (64px):** 5 slot menu (Beranda, Konseling, Edukasi, Notifikasi, Profil).

---

## 🛠️ Menjalankan Aplikasi
```bash
# Instal dependensi
flutter pub get

# Jalankan pengujian otomatis (Unit & Widget Design Tests)
flutter test

# Jalankan pada Chrome
flutter run -d chrome

# Jalankan pada Android (Device / Emulator)
flutter run -d android
```
