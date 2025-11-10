import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HalamanAdminToko extends StatefulWidget {
  const HalamanAdminToko({super.key});

  @override
  State<HalamanAdminToko> createState() => _HalamanAdminTokoState();
}

class _HalamanAdminTokoState extends State<HalamanAdminToko> {
  final Box<String> _pengaturanBox = Hive.box<String>('pengaturanBox');
  late TextEditingController _namaTokoController;
  File? _selectedLogoImage;
  String? _pathLogoToko;

  @override
  void initState() {
    super.initState();
    final String namaTokoTersimpan =
        _pengaturanBox.get('nama_toko') ?? 'Toko Anda';
    _pathLogoToko = _pengaturanBox.get('path_logo');
    _namaTokoController = TextEditingController(text: namaTokoTersimpan);
  }

  Future<void> _pilihLogo() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedLogoImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _hapusLogo() async {
    setState(() {
      _selectedLogoImage = null;
    });

    if (_pathLogoToko != null && _pathLogoToko!.isNotEmpty) {
      try {
        final fileLama = File(_pathLogoToko!);
        if (await fileLama.exists()) {
          await fileLama.delete();
        }
        await _pengaturanBox.delete('path_logo');
        setState(() {
          _pathLogoToko = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Logo berhasil dihapus!'),
                backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Gagal menghapus file logo: $e'),
                backgroundColor: Colors.red),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preview logo dibersihkan.')),
        );
      }
    }
  }

  Future<void> _simpanPengaturan() async {
    try {
      await _pengaturanBox.put('nama_toko', _namaTokoController.text);

      if (_selectedLogoImage != null) {
        if (_pathLogoToko != null && _pathLogoToko!.isNotEmpty) {
          final fileLama = File(_pathLogoToko!);
          if (await fileLama.exists()) {
            await fileLama.delete();
          }
        }

        final Directory appDir = await getApplicationDocumentsDirectory();
        const String namaFile = 'logo_toko.png';
        final String filePath = path.join(appDir.path, namaFile);

        final Uint8List imageBytes = await _selectedLogoImage!.readAsBytes();
        final File newFile = File(filePath);
        await newFile.writeAsBytes(imageBytes);

        await _pengaturanBox.put('path_logo', filePath);

        setState(() {
          _pathLogoToko = filePath;
          _selectedLogoImage = null;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengaturan toko berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool logoExists = _selectedLogoImage != null ||
        (_pathLogoToko != null && _pathLogoToko!.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Toko'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nama Toko',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _namaTokoController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko (Akan tampil di struk)',
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              'Logo Toko',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _selectedLogoImage != null
                      ? Image.file(_selectedLogoImage!, fit: BoxFit.contain)
                      : (_pathLogoToko != null && _pathLogoToko!.isNotEmpty
                          ? Image.file(
                              File(_pathLogoToko!),
                              fit: BoxFit.contain,
                              // --- PERBAIKAN: Tambahkan Key unik ---
                              // Ini memaksa Flutter memuat ulang gambar
                              // saat path-nya berubah (setelah simpan)
                              key: ValueKey(_pathLogoToko),
                              // --- AKHIR PERBAIKAN ---
                              errorBuilder: (c, e, s) => const Center(
                                child: Text('Gagal memuat logo lama'),
                              ),
                            )
                          : const Center(
                              child: Text('Belum ada Logo'),
                            )),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.image_outlined),
                  label: Text(logoExists ? 'Ganti Logo' : 'Pilih Logo Toko'),
                  onPressed: _pilihLogo,
                ),
                if (logoExists)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextButton.icon(
                      icon: Icon(Icons.delete_outline,
                          color: Colors.red.shade400),
                      label: Text(
                        'Hapus Logo',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                      onPressed: _hapusLogo,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Simpan Pengaturan'),
              onPressed: _simpanPengaturan,
            ),
          ],
        ),
      ),
    );
  }
}
