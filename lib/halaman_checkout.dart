import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';
import 'halaman_struk.dart';

class HalamanCheckout extends StatefulWidget {
  const HalamanCheckout({super.key});

  @override
  State<HalamanCheckout> createState() => _HalamanCheckoutState();
}

class _HalamanCheckoutState extends State<HalamanCheckout> {
  final Box<KeranjangItem> _keranjangBox =
      Hive.box<KeranjangItem>('keranjangBox');
  final Box<String> _pengaturanBox = Hive.box<String>('pengaturanBox');
  final Box<Transaksi> _transaksiBox = Hive.box<Transaksi>('transaksiBox');

  String? _metodePembayaran;
  final _uangBayarController = TextEditingController();
  double _kembalian = 0.0;

  @override
  void dispose() {
    _uangBayarController.dispose();
    super.dispose();
  }

  double _hitungTotalHarga() {
    double total = 0.0;
    for (var item in _keranjangBox.values) {
      total += (item.harga * item.jumlah);
    }
    return total;
  }

  void _hitungKembalian() {
    final double total = _hitungTotalHarga();
    final double? uangBayar = double.tryParse(_uangBayarController.text);

    if (uangBayar != null && uangBayar >= total) {
      setState(() {
        _kembalian = uangBayar - total;
      });
    } else {
      setState(() {
        _kembalian = 0.0;
      });
    }
  }

  Future<void> _prosesPembayaran() async {
    try {
      if (_metodePembayaran == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih metode pembayaran terlebih dahulu!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final double totalHarga = _hitungTotalHarga();
      double? uangBayar;
      double? kembalian;

      if (_metodePembayaran == 'CASH') {
        uangBayar = double.tryParse(_uangBayarController.text);

        if (uangBayar == null || uangBayar < totalHarga) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uang tunai yang dibayarkan kurang dari total!'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        kembalian = uangBayar - totalHarga;
      }

      var uuid = const Uuid();
      String tanggal = DateFormat('yyyyMMdd').format(DateTime.now());
      String idTransaksi =
          'TX-$tanggal-${uuid.v4().substring(0, 6)}'.toUpperCase();

      final List<Item> itemsTransaksi = _keranjangBox.values
          .map((keranjangItem) => Item(
                nama: keranjangItem.nama,
                jumlah: keranjangItem.jumlah,
                harga: keranjangItem.harga,
              ))
          .toList();

      final Transaksi transaksiBaru = Transaksi(
        id: idTransaksi,
        items: itemsTransaksi,
        totalHarga: totalHarga,
        metodePembayaran: _metodePembayaran!,
        tanggal: DateTime.now(),
        uangBayar: uangBayar,
        kembalian: kembalian,
      );

      await _transaksiBox.add(transaksiBaru);
      await _keranjangBox.clear();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HalamanStruk(transaksi: transaksiBaru),
          ),
        );
      }
    } catch (e) {

      print("--- ERROR SAAT PROSES PEMBAYARAN ---");
      print(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool cashAktif =
        (_pengaturanBox.get('cash_aktif') ?? 'true') == 'true';
    final String nomorDana = _pengaturanBox.get('nomor_dana') ?? '';
    final String? pathQRIS = _pengaturanBox.get('path_qris');
    final double totalHarga = _hitungTotalHarga();
    
    final formatAngka = NumberFormat.decimalPattern('id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ringkasan Pesanan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _keranjangBox.length,
                itemBuilder: (context, index) {
                  final item = _keranjangBox.getAt(index)!;
                  return ListTile(
                    title: Text(item.nama),
                    subtitle:
                        Text('Rp ${formatAngka.format(item.harga)} x ${item.jumlah}'),
                    trailing: Text(
                      formatAngka.format(item.harga * item.jumlah),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 30),

            Text(
              'Pilih Metode Pembayaran',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (cashAktif)
              Card(
                color: _metodePembayaran == 'CASH'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Theme.of(context).cardTheme.color,
                child: ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text('CASH'),
                  subtitle: const Text('Bayar tunai di kasir'),
                  onTap: () {
                    setState(() {
                      _metodePembayaran = 'CASH';
                    });
                  },
                ),
              ),
            if (nomorDana.isNotEmpty)
              Card(
                color: _metodePembayaran == 'DANA'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Theme.of(context).cardTheme.color,
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: const Text('DANA'),
                  subtitle: Text(nomorDana),
                  onTap: () {
                    setState(() {
                      _metodePembayaran = 'DANA';
                    });
                  },
                ),
              ),
            if (pathQRIS != null && pathQRIS.isNotEmpty)
              Card(
                color: _metodePembayaran == 'QRIS'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Theme.of(context).cardTheme.color,
                child: ListTile(
                  leading: const Icon(Icons.qr_code_2),
                  title: const Text('QRIS'),
                  subtitle: const Text('Scan kode QR untuk membayar'),
                  onTap: () {
                    setState(() {
                      _metodePembayaran = 'QRIS';
                    });
                  },
                ),
              ),
            const SizedBox(height: 20),

            if (_metodePembayaran == 'CASH')
              _buildInfoCash(totalHarga, formatAngka),
            if (_metodePembayaran == 'DANA')
              _buildInfoPembayaran('Bayar ke DANA', nomorDana),
            if (_metodePembayaran == 'QRIS') _buildInfoQRIS(pathQRIS),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Bayar:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  formatAngka.format(totalHarga),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _prosesPembayaran,
              child: const Text('Selesaikan Pembayaran'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCash(double totalHarga, NumberFormat formatAngka) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Pembayaran Tunai',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _uangBayarController,
              decoration: const InputDecoration(
                  labelText: 'Jumlah Uang Tunai',
                  hintText: 'Contoh: 50000 (tanpa titik)'
                  ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                _hitungKembalian();
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kembalian:', style: TextStyle(fontSize: 16)),
                Text(
                  formatAngka.format(_kembalian),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPembayaran(String judul, String info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(judul, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              info,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoQRIS(String? pathQRIS) {
    if (pathQRIS == null || pathQRIS.isEmpty) {
      return _buildInfoPembayaran(
          'QRIS belum diatur', 'Silakan atur di Halaman Admin');
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Silakan scan QRIS di bawah ini',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Image.file(
              File(pathQRIS),
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Text('Gagal memuat gambar QRIS'),
            ),
          ],
        ),
      ),
    );
  }
}