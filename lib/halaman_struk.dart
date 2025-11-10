import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'models.dart';

class HalamanStruk extends StatelessWidget {
  final Transaksi transaksi;

  const HalamanStruk({super.key, required this.transaksi});

  Future<Uint8List> _buatPdfStruk() async {
    final doc = pw.Document();

    final Box<String> pengaturanBox = Hive.box<String>('pengaturanBox');
    final String namaToko = pengaturanBox.get('nama_toko') ?? 'NAMA TOKO ANDA';

    // --- PERBAIKAN: Gunakan kunci 'path_logo' (bukan 'path_logo_toko') ---
    final String? pathLogo = pengaturanBox.get('path_logo');
    // --- AKHIR PERBAIKAN ---

    pw.ImageProvider? logo;
    if (pathLogo != null && pathLogo.isNotEmpty) {
      try {
        final logoBytes = await File(pathLogo).readAsBytes();
        logo = pw.MemoryImage(logoBytes);
      } catch (e) {
        print("Gagal load logo untuk PDF: $e");
      }
    }

    // --- PERBAIKAN: Gunakan formatAngka (10.000) bukan formatCurrency (Rp 10.000) ---
    // Ini agar kita bisa fleksibel menambahkan "Rp" atau "@"
    final formatAngka = NumberFormat.decimalPattern('id_ID');
    // --- AKHIR PERBAIKAN ---

    doc.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(80 * PdfPageFormat.mm, double.infinity,
            marginAll: 5 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logo != null)
                pw.Center(
                  child: pw.Image(
                    logo,
                    height: 60,
                    fit: pw.BoxFit.contain,
                  ),
                ),
              pw.SizedBox(height: logo != null ? 5 : 0),
              pw.Center(
                child: pw.Text(
                  namaToko,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'ID Transaksi: ${transaksi.id}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Tanggal: ${DateFormat('dd/MM/yyyy HH:mm').format(transaksi.tanggal)}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Divider(height: 20, borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                      flex: 3,
                      child: pw.Text('Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('Jml x Harga',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('Subtotal',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.Divider(height: 5),
              ...transaksi.items.map((item) {
                return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(flex: 3, child: pw.Text(item.nama)),
                        // --- PERBAIKAN: Gunakan formatAngka untuk harga satuan ---
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                                '${item.jumlah}x @${formatAngka.format(item.harga)}',
                                textAlign: pw.TextAlign.right)),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                                formatAngka.format(item.jumlah * item.harga),
                                textAlign: pw.TextAlign.right)),
                        // --- AKHIR PERBAIKAN ---
                      ],
                    ));
              }),
              pw.Divider(height: 20, borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Harga:',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text(
                    // --- PERBAIKAN: Gunakan formatAngka ---
                    'Rp ${formatAngka.format(transaksi.totalHarga)}',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Metode Pembayaran:'),
                  pw.Text(
                    transaksi.metodePembayaran,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              if (transaksi.metodePembayaran == 'CASH' &&
                  transaksi.uangBayar != null) ...[
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Uang Tunai:'),
                    // --- PERBAIKAN: Gunakan formatAngka ---
                    pw.Text('Rp ${formatAngka.format(transaksi.uangBayar!)}'),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Kembalian:'),
                    // --- PERBAIKAN: Gunakan formatAngka ---
                    pw.Text('Rp ${formatAngka.format(transaksi.kembalian!)}'),
                  ],
                ),
              ],
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Text(
                  '--- Terima Kasih ---',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN: Buat formatter untuk tampilan layar ---
    final formatAngka = NumberFormat.decimalPattern('id_ID');
    // --- AKHIR PERBAIKAN ---

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Berhasil'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Kembali ke halaman paling awal (halaman produk)
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade400,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                'Pembayaran Berhasil!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'ID Transaksi: ${transaksi.id}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                // --- PERBAIKAN: Gunakan formatAngka untuk tampilan layar ---
                'Total: Rp ${formatAngka.format(transaksi.totalHarga)}',
                // --- AKHIR PERBAIKAN ---
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.print),
                label: const Text('Cetak Struk'),
                onPressed: () => Printing.layoutPdf(
                  // Gunakan format kertas struk 80mm
                  onLayout: (PdfPageFormat format) => _buatPdfStruk(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
