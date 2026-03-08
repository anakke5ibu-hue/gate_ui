============================================================
       GATE UI - SISTEM PARKIR TELKOM UNIVERSITY 2026
============================================================

Repository ini adalah UI Dashboard untuk sistem gate parkir 
otomatis menggunakan Face Recognition (YOLOv11 + ArcFace).
Didesain untuk menangani simulasi akses 50.000 mahasiswa.

------------------------------------------------------------
1. PERSIAPAN (PREREQUISITES)
------------------------------------------------------------
Sebelum mulai ngoding, pastikan laptop kamu sudah ada:
- Flutter SDK (Versi terbaru)
- Visual Studio 2022 (Desktop development with C++ installed)
- Kamera Logitech C270 (Pastikan sudah dicolok)
- Git installed

------------------------------------------------------------
2. CARA SETUP AWAL
------------------------------------------------------------
Buka Terminal/CMD di folder pilihanmu, lalu:

A. Clone Repository:
   git clone https://github.com/[USERNAME_KAMU]/gate_ui.git

B. Masuk ke Folder:
   cd gate_ui

C. Install Packages:
   flutter pub get

------------------------------------------------------------
3. CARA RUN APLIKASI
------------------------------------------------------------
1. Hubungkan kamera Logitech C270 ke port USB.
2. Pastikan device yang dipilih di VS Code adalah "Windows (desktop)".
3. Jalankan perintah:
   flutter run

------------------------------------------------------------
4. FITUR SAAT INI (STATUS)
------------------------------------------------------------
- Standby Mode: Animasi instruksi looping (Posisikan Wajah, dll).
- Active Mode: Tampilan Identitas (Nama & NIM) setelah trigger.
- Trigger Simulasi: Gunakan tombol "Simulasi" untuk mencoba 
  transisi UI dari Standby ke Data Mahasiswa.
- Anti-Overflow: Sudah menggunakan FittedBox agar UI tidak 
  error saat jendela di-resize.

------------------------------------------------------------
5. ATURAN NGODING (WORKFLOW)
------------------------------------------------------------
Biar kodingan kita nggak bentrok (conflict), ikuti alur ini:

1. SELALU PULL DULU sebelum mulai:
   git pull origin main

2. Jika sudah selesai nambah fitur:
   git add .
   git commit -m "Fitur: [tulis apa yang kamu ubah]"
   git push origin main

------------------------------------------------------------
6. TROUBLESHOOTING
------------------------------------------------------------
- Jika Kamera Error: Pastikan tidak ada aplikasi lain 
  (Zoom/Teams/Gmeet) yang sedang memakai kamera.
- Jika Layout Error: Pastikan widget Expanded hanya berada 
  di dalam Row atau Column.

============================================================
Kontak [NAMA KAMU] jika ada kendala di kodingan main.dart.
Selamat ngoding, semoga TA kita lancar!
============================================================