import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To Do List Harian',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Aplikasi ini membantu kamu mencatat tugas harian beserta tanggalnya, '
              'dan bisa menandai apakah tugas sudah selesai atau belum.\n\n'
              'Fitur yang tersedia:\n'
              '- Menambah tugas\n'
              '- Menandai tugas selesai\n'
              '- Menghapus tugas\n'
              '- Menyimpan tugas secara lokal\n'
              '- Tampilan tema terang & gelap\n'
              '- Custom font',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}