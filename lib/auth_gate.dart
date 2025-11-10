import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'halaman_login.dart';
import 'halaman_produk.dart'; 

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HalamanProduk();
          }
          return const HalamanLogin();
        },
      ),
    );
  }
}