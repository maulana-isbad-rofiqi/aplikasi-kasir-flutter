import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_gate.dart';
import 'models.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(ProdukAdapter().typeId)) {
    Hive.registerAdapter(ProdukAdapter());
  }
  if (!Hive.isAdapterRegistered(KeranjangItemAdapter().typeId)) {
    Hive.registerAdapter(KeranjangItemAdapter());
  }
  if (!Hive.isAdapterRegistered(TransaksiAdapter().typeId)) {
    Hive.registerAdapter(TransaksiAdapter());
  }
  if (!Hive.isAdapterRegistered(RiwayatStokAdapter().typeId)) {
    Hive.registerAdapter(RiwayatStokAdapter());
  }
  if (!Hive.isAdapterRegistered(ItemAdapter().typeId)) {
    Hive.registerAdapter(ItemAdapter());
  }
  await Hive.openBox<Produk>('produkBox');
  await Hive.openBox<String>('pengaturanBox');
  await Hive.openBox<KeranjangItem>('keranjangBox');
  await Hive.openBox<Transaksi>('transaksiBox');
  await Hive.openBox<RiwayatStok>('riwayatStokBox');
  
  runApp(const AplikasiKasir());
}

class AplikasiKasir extends StatelessWidget {
  const AplikasiKasir({super.key});

  @override
  Widget build(BuildContext context) {
    const Color warnaPrimer = Color(0xFF6200EE);
    const Color warnaBackgroundGelap = Color(0xFF121212);
    const Color warnaCardGelap = Color(0xFF1E1E1E);

    final ThemeData temaGelap = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: warnaBackgroundGelap,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: warnaBackgroundGelap,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: warnaCardGelap,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warnaPrimer,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: warnaCardGelap,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: warnaPrimer,
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Aplikasi Kasir',
      debugShowCheckedModeBanner: false,
      theme: temaGelap,
      home: const AuthGate(),
    );
  }
}