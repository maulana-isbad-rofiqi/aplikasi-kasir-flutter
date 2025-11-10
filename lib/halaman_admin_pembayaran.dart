import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HalamanAdminPembayaran extends StatefulWidget {
  const HalamanAdminPembayaran({super.key});

  @override
  State<HalamanAdminPembayaran> createState() => _HalamanAdminPembayaranState();
}

class _HalamanAdminPembayaranState extends State<HalamanAdminPembayaran> {
  final Box<String> _pengaturanBox = Hive.box<String>('pengaturanBox');

  late TextEditingController _danaNomorController;
  late bool _cashAktif;
  File? _selectedQRISImage;
  String? _pathGambarQRIS;

  @override
  void initState() {
    super.initState();
    final String nomorDanaTersimpan = _pengaturanBox.get('nomor_dana') ?? '';
    _pathGambarQRIS = _pengaturanBox.get('path_qris');
    _cashAktif = (_pengaturanBox.get('cash_aktif') ?? 'true') == 'true';

    _danaNomorController = TextEditingController(text: nomorDanaTersimpan);
  }

  Future<void> _pilihGambarQRIS() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedQRISImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _simpanPengaturan() async {
    try {
      await _pengaturanBox.put('nomor_dana', _danaNomorController.text);
      await _pengaturanBox.put('cash_aktif', _cashAktif.toString());

      if (_selectedQRISImage != null) {
        if (_pathGambarQRIS != null && _pathGambarQRIS!.isNotEmpty) {
          final fileLama = File(_pathGambarQRIS!);
          if (await fileLama.exists()) {
            await fileLama.delete();
          }
        }

        final Directory appDir = await getApplicationDocumentsDirectory();
        const String namaFile = 'qris_image.jpg';
        final String filePath = path.join(appDir.path, namaFile);

        await _selectedQRISImage!.copy(filePath);

        await _pengaturanBox.put('path_qris', filePath);
        setState(() {
          _pathGambarQRIS = filePath;
          _selectedQRISImage = null;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengaturan berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pengaturan CASH',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              title: const Text('Aktifkan Pembayaran CASH'),
              value: _cashAktif,
              onChanged: (bool value) {
                setState(() {
                  _cashAktif = value;
                });
              },
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            Text(
              'Pengaturan DANA',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _danaNomorController,
              decoration: const InputDecoration(
                labelText: 'Nomor DANA (contoh: 0812...)',
                prefixIcon: Icon(Icons.phone_android),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            Text(
              'Pengaturan QRIS',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _selectedQRISImage != null
                      ? Image.file(_selectedQRISImage!, fit: BoxFit.contain)
                      : (_pathGambarQRIS != null && _pathGambarQRIS!.isNotEmpty
                          ? Image.file(File(_pathGambarQRIS!),
                              fit: BoxFit.contain)
                          : const Center(
                              child: Text('Belum ada gambar QRIS'),
                            )),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              icon: const Icon(Icons.qr_code_scanner_outlined),
              label: Text(_pathGambarQRIS == null && _selectedQRISImage == null
                  ? 'Pilih Gambar QRIS'
                  : 'Ganti Gambar QRIS'),
              onPressed: _pilihGambarQRIS,
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
