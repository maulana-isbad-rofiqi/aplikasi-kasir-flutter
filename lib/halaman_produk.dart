import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth_service.dart';
import 'models.dart';
import 'halaman_admin_utama.dart';
import 'halaman_keranjang.dart';
import 'package:intl/intl.dart'; // <-- Pastikan ini ada

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  final Box<Produk> _produkBox = Hive.box<Produk>('produkBox');
  final Box<KeranjangItem> _keranjangBox = Hive.box<KeranjangItem>('keranjangBox');
  final Box<String> _pengaturanBox = Hive.box<String>('pengaturanBox'); // <-- Box untuk logo/nama
  final AuthService _authService = AuthService();

  // ... (Fungsi _tambahKeKeranjang, _hitungTotalItem, _tampilkanDetailPopup, _tampilkanDialogLogout tetap SAMA) ...
  // --- (Tidak ada perubahan pada fungsi-fungsi ini, sudah benar) ---
  void _tambahKeKeranjang(Produk produk, int produkKey) {
    if (produk.stok <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok ${produk.nama} sudah habis!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_keranjangBox.containsKey(produkKey)) {
      final item = _keranjangBox.get(produkKey)!;
      item.jumlah++;
      item.save(); 
    } else {
      final itemBaru = KeranjangItem(
        produkKey: produkKey,
        nama: produk.nama,
        harga: produk.harga,
        imageUrl: produk.imageUrl,
        jumlah: 1, 
      );
      _keranjangBox.put(produkKey, itemBaru); 
    }

    produk.stok = produk.stok - 1;
    produk.save(); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produk.nama} ditambahkan ke keranjang!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  int _hitungTotalItem(Box<KeranjangItem> box) {
    int total = 0;
    for (var item in box.values) {
      total += item.jumlah;
    }
    return total;
  }
  
  Future<void> _tampilkanDetailPopup(Produk produk, int produkKey) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // --- PERBAIKAN: Format angka untuk popup ---
        final formatAngka = NumberFormat.decimalPattern('id_ID');

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final Produk produkRealtime = _produkBox.get(produkKey)!;
            final bool stokHabis = produkRealtime.stok <= 0;

            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Wrap( 
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'produk-$produkKey',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(produkRealtime.imageUrl),
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              height: 250,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 50),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        produkRealtime.nama,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // --- PERBAIKAN: Gunakan formatAngka ---
                            'Rp ${formatAngka.format(produkRealtime.harga)}', 
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Stok: ${produkRealtime.stok}', 
                            style: TextStyle(
                              fontSize: 16,
                              color: stokHabis ? Colors.red.shade300 : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Deskripsi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        produkRealtime.deskripsi,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('Ke Keranjang'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: stokHabis ? null : () {
                                _tambahKeKeranjang(produkRealtime, produkKey); 
                                setModalState(() {}); 
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_bag),
                              label: const Text('Beli Sekarang'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: stokHabis ? null : () {
                                
                                if (!_keranjangBox.containsKey(produkKey)) {
                                    _tambahKeKeranjang(produkRealtime, produkKey); 
                                    setModalState(() {});
                                } else {
                                  
                                  final item = _keranjangBox.get(produkKey)!;
                                  if(item.jumlah < 1) {
                                    _tambahKeKeranjang(produkRealtime, produkKey);
                                    setModalState(() {});
                                  }
                                }
                                
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const HalamanKeranjang(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {});
  }

  Future<void> _tampilkanDialogLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout sekarang?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red.shade400),
              ),
              onPressed: () {
                _authService.signOut();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN: Buat formatter di sini untuk GridView ---
    final formatAngka = NumberFormat.decimalPattern('id_ID');

    return Scaffold(
      appBar: AppBar(
        // --- PERBAIKAN: Logo dan Nama Toko ---
        title: ValueListenableBuilder<Box<String>>(
          valueListenable: _pengaturanBox.listenable(),
          builder: (context, box, _) {
            final String namaToko = box.get('nama_toko') ?? 'Produk Tersedia';
            final String? pathLogo = box.get('path_logo');

            return Row(
              children: [
                if (pathLogo != null && pathLogo.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.file(
                        File(pathLogo),
                        // --- PERBAIKAN: Tambahkan Key unik ---
                        // Ini memaksa Flutter memuat ulang gambar
                        // dan membantu mencegah crash dari file corrupt
                        key: ValueKey(pathLogo), 
                        height: 32, 
                        width: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) {
                          // Jika crash terjadi, print error-nya
                          print("Error memuat gambar logo: $e");
                          return const Icon(
                            Icons.storefront,
                            size: 30,
                          );
                        },
                      ),
                    ),
                  ),
                Text(namaToko),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            tooltip: 'Mode Admin',
            onPressed: () async {
              // --- PERBAIKAN: Gunakan 'await' agar UI di-refresh setelah admin ditutup ---
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HalamanAdminUtama(),
                ),
              );
            },
          ),
          
          ValueListenableBuilder(
            valueListenable: _keranjangBox.listenable(),
            builder: (context, Box<KeranjangItem> box, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HalamanKeranjang(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: 'Keranjang',
                  ),
                  if (box.values.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          _hitungTotalItem(box).toString(), 
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _tampilkanDialogLogout(context),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _produkBox.listenable(),
        builder: (context, Box<Produk> box, _) {
          if (box.values.isEmpty) {
            return const Center(
                child: Text(
                    'Tidak ada produk. Silakan tambahkan di Mode Admin.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              // --- PERBAIKAN: Sesuaikan rasio agar teks muat ---
              childAspectRatio: 0.75, // Diberi lebih banyak ruang vertikal
            ),
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final produk = box.getAt(index);
              final int produkKey = box.keyAt(index) as int;

              if (produk == null) {
                return const Card(child: Text('Data produk error'));
              }
              // --- PERBAIKAN: Kirim formatter ke _buildProductCard ---
              return _buildProductCard(produk, produkKey, formatAngka);
            },
          );
        },
      ),
    );
  }

  // --- Widget _buildProductCard (Dengan Perbaikan Layout & Format) ---
  Widget _buildProductCard(Produk produk, int produkKey, NumberFormat formatAngka) {
    final bool stokHabis = produk.stok <= 0;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      color: stokHabis
          ? Theme.of(context).cardTheme.color?.withOpacity(0.5)
          : Theme.of(context).cardTheme.color,
      child: InkWell(
        onTap: () {
          _tampilkanDetailPopup(produk, produkKey);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- PERBAIKAN: Layout diubah ke Expanded + Padding ---
            // 1. Gambar (mengambil ruang fleksibel)
            Expanded(
              flex: 3, // Beri 3 bagian ruang untuk gambar
              child: Hero( 
                tag: 'produk-$produkKey',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(produk.imageUrl), 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Icon(Icons.image_not_supported, size: 40));
                      },
                    ),
                    if (stokHabis)
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        child: const Center(
                          child: Text(
                            'STOK HABIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 2. Teks (mengambil sisa ruang)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Penting agar tidak overflow
                children: [
                  // Hapus Flexible dan Spacer
                  Text(
                    produk.nama, // <-- INI NAMA PRODUK
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stok: ${produk.stok}',
                    style: TextStyle(
                      fontSize: 14,
                      color: stokHabis ? Colors.red.shade300 : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8), 
                  Text(
                    'Rp ${formatAngka.format(produk.harga)}', // <-- INI HARGA
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // --- AKHIR PERBAIKAN LAYOUT ---
          ],
        ),
      ),
    );
  }
}