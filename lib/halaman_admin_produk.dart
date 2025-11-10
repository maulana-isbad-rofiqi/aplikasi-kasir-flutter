import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'models.dart';

class HalamanAdminProduk extends StatefulWidget {
  const HalamanAdminProduk({super.key});

  @override
  State<HalamanAdminProduk> createState() => _HalamanAdminProdukState();
}

class _HalamanAdminProdukState extends State<HalamanAdminProduk> {
  final Box<Produk> _produkBox = Hive.box<Produk>('produkBox');
  final Box<RiwayatStok> _riwayatStokBox = Hive.box<RiwayatStok>('riwayatStokBox');
  final NumberFormat _formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0, name: 'Rp ');
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController(); 
  File? _selectedImageFile; 

  Future<void> _pilihGambar(Function(void Function()) dialogSetState) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      dialogSetState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _simpanProduk(
      Produk? produk, int? produkKey, BuildContext dialogContext) async {
    final String nama = _namaController.text;
    final double? harga = double.tryParse(_hargaController.text); 
    final int? stok = int.tryParse(_stokController.text);
    final String deskripsi = _deskripsiController.text; 
    String newImageUrl = ''; 

    if (nama.isEmpty ||
        harga == null ||
        stok == null ||
        deskripsi.isEmpty) { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field (termasuk deskripsi) harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      if (_selectedImageFile != null) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String namaFile = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = path.join(appDir.path, namaFile);
        await _selectedImageFile!.copy(filePath);
        newImageUrl = filePath; 
        if (produk != null && produk.imageUrl.isNotEmpty) {
          final fileLama = File(produk.imageUrl);
          if (await fileLama.exists()) {
            await fileLama.delete();
          }
        }
      } else if (produk != null) {
        newImageUrl = produk.imageUrl; 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus memilih foto produk!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final produkBaru = Produk(
        nama: nama,
        harga: harga,
        stok: stok,
        imageUrl: newImageUrl,
        deskripsi: deskripsi, 
      );

      if (produk == null) {
        await _produkBox.add(produkBaru);
      } else {
        await _produkBox.put(produkKey, produkBaru);
      }
      if (mounted) Navigator.of(dialogContext).pop(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _tampilkanFormDialog([Produk? produk, int? produkKey]) async {
    _selectedImageFile = null;
    if (produk != null) {
      _namaController.text = produk.nama;
      _hargaController.text = produk.harga.toStringAsFixed(0);
      _stokController.text = produk.stok.toString();
      _deskripsiController.text = produk.deskripsi; 
    } else {
      _namaController.clear();
      _hargaController.clear();
      _stokController.clear();
      _deskripsiController.clear(); 
    }
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stfContext, dialogSetState) {
            return AlertDialog(
              title: Text(produk == null ? 'Tambah Produk Baru' : 'Edit Produk'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _selectedImageFile != null
                              ? Image.file(_selectedImageFile!,
                                  fit: BoxFit.cover)
                              : (produk != null && produk.imageUrl.isNotEmpty
                                  ? Image.file(File(produk.imageUrl),
                                      fit: BoxFit.cover)
                                  : const Center(
                                      child: Icon(Icons.image_outlined,
                                          size: 50, color: Colors.grey),
                                    )),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(_selectedImageFile == null
                          ? 'Pilih Foto dari Galeri'
                          : 'Ganti Foto'),
                      onPressed: () => _pilihGambar(dialogSetState),
                    ),
                    const Divider(),
                    TextField(
                      controller: _namaController,
                      decoration:
                          const InputDecoration(labelText: 'Nama Produk'),
                    ),
                    TextField(
                      controller: _hargaController,
                      decoration: const InputDecoration(labelText: 'Harga'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                      ],
                    ),
                    TextField(
                      controller: _stokController,
                      decoration: const InputDecoration(labelText: 'Stok Awal'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Stok tetap angka bulat
                    ),
                    TextField(
                      controller: _deskripsiController,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi Produk'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                ElevatedButton(
                  child: const Text('Simpan'),
                  onPressed: () =>
                      _simpanProduk(produk, produkKey, dialogContext),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _tampilkanDialogHapus(Produk produk, int produkKey) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Anda yakin ingin menghapus ${produk.nama}?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                final fileFoto = File(produk.imageUrl);
                if (await fileFoto.exists()) {
                  await fileFoto.delete();
                }
              } catch (e) {
                print("Gagal hapus file foto lama: $e");
              }
              await _produkBox.delete(produkKey);
              if (mounted) Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _tampilkanDialogTambahStok(Produk produk, int produkKey) async {
    final tambahStokController = TextEditingController();
    final keteranganStokController = TextEditingController(); 
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Stok: ${produk.nama}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Stok saat ini: ${produk.stok}'),
                const SizedBox(height: 16),
                TextField(
                  controller: tambahStokController,
                  decoration:
                      const InputDecoration(labelText: 'Jumlah Stok Tambahan'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                TextField(
                  controller: keteranganStokController,
                  decoration:
                      const InputDecoration(labelText: 'Keterangan (Contoh: "Barang baru")'),
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () async {
                final int? jumlahTambahan =
                    int.tryParse(tambahStokController.text);
                final String keterangan = keteranganStokController.text;
                
                if (jumlahTambahan != null && jumlahTambahan > 0) {
                  produk.stok = produk.stok + jumlahTambahan;
                  await produk.save(); 
                  
                  final riwayat = RiwayatStok(
                    produkKey: produkKey,
                    namaProduk: produk.nama,
                    jumlah: jumlahTambahan,
                    keterangan: keterangan.isNotEmpty ? keterangan : 'Stok ditambahkan',
                    tanggal: DateTime.now(),
                  );
                  await _riwayatStokBox.add(riwayat);
                  if (mounted) Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Masukkan jumlah yang valid!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Kelola Produk'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _produkBox.listenable(),
        builder: (context, Box<Produk> box, _) {
          if (box.values.isEmpty) {
            return const Center(
                child: Text('Tidak ada produk. Silakan tambahkan.'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final produk = box.getAt(index);
              final int produkKey = box.keyAt(index) as int;
              if (produk == null) {
                return const ListTile(title: Text('Data produk error'));
              }

              return ListTile(
                leading: Image.file(
                  File(produk.imageUrl),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.image_not_supported),
                ),
                title: Text(produk.nama),
                subtitle:
                    Text('Harga: ${_formatCurrency.format(produk.harga)} - Stok: ${produk.stok}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_box_outlined),
                      color: Colors.green.shade400,
                      tooltip: 'Tambah Stok',
                      onPressed: () =>
                          _tampilkanDialogTambahStok(produk, produkKey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _tampilkanFormDialog(produk, produkKey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _tampilkanDialogHapus(produk, produkKey),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormDialog(),
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add),
      ),
    );
  }
}