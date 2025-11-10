# 💰 Aplikasi Kasir Flutter

Aplikasi Kasir sederhana berbasis **Flutter** yang digunakan untuk mengelola transaksi penjualan, stok produk, dan metode pembayaran (CASH, DANA, QRIS).  
Aplikasi ini cocok digunakan untuk toko kecil, kafe, atau usaha retail yang membutuhkan sistem kasir digital sederhana namun fungsional.

---

## 🚀 Fitur Utama

- 🔐 **Login Admin**
  - Akses aman untuk pemilik atau karyawan toko.
- 🛍️ **Kelola Produk**
  - Tambah, edit, hapus, dan atur stok produk secara dinamis.
- 💸 **Kelola Pembayaran**
  - Pilihan metode pembayaran: **CASH**, **DANA**, dan **QRIS**.
- 🧾 **Cetak Struk Otomatis**
  - Setelah transaksi selesai, aplikasi dapat **mencetak struk secara otomatis** berisi:
    - Nama toko dan logo.
    - Daftar produk yang dibeli.
    - Jumlah, harga per item, dan total keseluruhan.
    - Metode pembayaran yang digunakan.
    - Tanggal & waktu transaksi.
- 📦 **Riwayat Stok**
  - Menampilkan histori setiap penambahan atau pengurangan stok barang.
- 🧾 **Riwayat Transaksi**
  - Melihat seluruh riwayat transaksi dan total penjualan.
- ⚙️ **Pengaturan Toko**
  - Ubah nama toko, logo, serta informasi tambahan seperti alamat dan kontak toko.


---

## 🧠 Teknologi yang Digunakan

- **Flutter** (Front-end Framework)  
- **Dart** (Bahasa Pemrograman)  
- **Firebase / SQLite** (opsional, tergantung implementasi penyimpanan)  
- **UI Library:** Material Design

---

## 📱 Tampilan Aplikasi

Berikut beberapa tampilan hasil aplikasi kasir ini (pastikan file gambar berada di root repo atau path yang sesuai):

### 🛒 Halaman Produk  
Menampilkan daftar produk yang tersedia beserta stok dan harga.  
![Produk Tersedia](https://i.postimg.cc/KYdx7MCP/motion-photo-1620821510689416041.jpg)


---

### ⚙️ Menu Admin  
Berisi pengaturan toko, kelola produk, pembayaran, dan riwayat transaksi.  
![Menu Admin](https://i.postimg.cc/TPcJgVKz/motion-photo-4047433430745450848.jpg)

---

### 💳 Halaman Checkout Pembayaran  
Pilih metode pembayaran (Cash, DANA, QRIS) dan selesaikan transaksi.  
![Checkout Pembayaran](https://i.postimg.cc/mrdVK3TM/motion-photo-5956120407410530158.jpg)

---

### 🧾 Riwayat Stok dan Transaksi  
Menampilkan histori stok dan penjualan.  
![Riwayat Admin](https://i.postimg.cc/Fs2p4s59/IMG-20251110-WA0012.jpg)

---

## 🧩 Struktur Folder (contoh)

lib/

├── halaman_admin_pembayaran.dart

├── halaman_admin_produk.dart

├── halaman_admin_stok.dart

├── halaman_admin_transaksi.dart

├── halaman_checkout.dart

├── halaman_login.dart

├── halaman_keranjang.dart

├── main.dart

├── auth_gate.dart

└── settings.gradle

## ⚡ Cara Menjalankan

1. Masuk ke folder project:
cd aplikasi_kasir
2. Jalankan perintah untuk mendapatkan dependency:
flutter pub get
3. Jalankan aplikasi:
flutter run

🧑‍💻 Login
(contoh):

Email: admin@kasir.com  
Password: 123456

## 🎬 Have Fun Video Aplikasi

[![Tonton]](https://youtube.com/shorts/3hs6lkar5I0?si=K_cnogpBPYmBjPzk)

📸 Preview Project

Dibuat dan diuji langsung di perangkat Android menggunakan koneksi debug melalui VS Code.
