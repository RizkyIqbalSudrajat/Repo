import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lji/Admin/Analisis%20Uang/listpendapatan.dart';
import 'package:lji/Admin/HistoryAdmin/HistoryAdmin.dart';
import 'package:lji/styles/color.dart';
import '../Notifikasi/notifikasi.dart';

class Pendapatan extends StatefulWidget {
  const Pendapatan({Key? key}) : super(key: key);

  @override
  _PendapatanState createState() => _PendapatanState();
}

class _PendapatanState extends State<Pendapatan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RiwayatAdmin(),
                ),
              );
            },
            child: Icon(
              Icons.history,
              size: 25,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Notifikasi(),
                ),
              );
            },
            child: Icon(
              Icons.notifications,
              size: 25,
            ),
          ),
          SizedBox(
            width: 13,
          )
        ],
        centerTitle: true,
        title: Text(
          "Omset Pendapatan",
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // Your existing widgets inside the Column
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text("Total minggu ini",
                    style: GoogleFonts.poppins(fontSize: 12)),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<int>(
                  future: getTotalPendapatanMingguan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: greenPrimary,);
                    } else {
                      return Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                            .format(snapshot.data ?? 0),
                        style: GoogleFonts.poppins(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Terbaru",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: getLatestPendapatanHarian(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: greenPrimary,);
                    } else {
                      List<Map<String, dynamic>> latestData =
                          snapshot.data ?? [];
                      if (latestData.isEmpty) {
                        return Text('Pendapatan minggu sebelumnya kosong');
                      } else {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              latestData.length > 3 ? 3 : latestData.length,
                          itemBuilder: (context, index) {
                            return ListPendapatan(
                              tanggal: latestData[index]['tanggal'],
                              totalHarga: latestData[index]['total_harga'],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Minggu yang lalu",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: getPreviousPendapatanMingguan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: greenPrimary,);
                    } else {
                      List<Map<String, dynamic>> previousData =
                          snapshot.data ?? [];
                      if (previousData.isEmpty) {
                        return Text('Pendapatan minggu sebelumnya kosong');
                      } else {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: previousData.length,
                          itemBuilder: (context, index) {
                            return ListPendapatan(
                              tanggal: previousData[index]['tanggal'],
                              totalHarga: previousData[index]['total_harga'],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Implement method to get total pendapatan mingguan
  Future<int> getTotalPendapatanMingguan() async {
    // Mengambil tanggal awal dan akhir minggu saat ini
    DateTime now = DateTime.now();
    DateTime awalMinggu = now.subtract(Duration(days: now.weekday - 1));
    DateTime akhirMinggu = awalMinggu.add(Duration(days: 6));

    // Menetapkan jam, menit, dan detik menjadi 00:00 untuk tanggal awal minggu
    awalMinggu =
        DateTime(awalMinggu.year, awalMinggu.month, awalMinggu.day, 0, 0, 0);

    // Menetapkan jam, menit, dan detik menjadi 23:59 untuk tanggal akhir minggu
    akhirMinggu = DateTime(
        akhirMinggu.year, akhirMinggu.month, akhirMinggu.day, 23, 59, 59);

    // Membuat format string untuk tanggal awal dan akhir minggu
    String awalMingguStr = _formatTanggal(awalMinggu);
    String akhirMingguStr = _formatTanggal(akhirMinggu);

    try {
      // Mengambil data pendapatan mingguan dari Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('pendapatan_mingguan')
          .doc('$awalMingguStr-$akhirMingguStr')
          .get();

      if (snapshot.exists) {
        // Jika dokumen ditemukan, kembalikan nilai total_harga
        return snapshot['total_harga'];
      } else {
        // Jika dokumen tidak ditemukan, kembalikan nilai 0
        return 0;
      }
    } catch (e) {
      // Jika terjadi kesalahan, tangani kesalahan
      print('Error: $e');
      return 0;
    }
  }

// TODO: Implement method to get previous pendapatan mingguan
  Future<List<Map<String, dynamic>>> getPreviousPendapatanMingguan() async {
    try {
      // Mendapatkan tanggal awal minggu sekarang
      DateTime now = DateTime.now();
      DateTime awalMingguIni = now.subtract(Duration(days: now.weekday + 6));

      // Mengambil data pendapatan mingguan sebelumnya dari Firestore
      final snapshots = await FirebaseFirestore.instance
          .collection('pendapatan_mingguan')
          .where('awal_minggu', isLessThan: awalMingguIni)
          .orderBy('awal_minggu', descending: true)
          .get();

      // Membuat list untuk menyimpan data pendapatan mingguan sebelumnya
      List<Map<String, dynamic>> pendapatanMingguanSebelumnya = [];

      // Mengambil data dari setiap dokumen
      snapshots.docs.forEach((doc) {
        pendapatanMingguanSebelumnya.add({
          'tanggal': doc['tanggal_pendapatan'],
          'total_harga': doc['total_harga']
        });
      });

      // Kembalikan data pendapatan mingguan sebelumnya
      return pendapatanMingguanSebelumnya;
    } catch (e) {
      // Jika terjadi kesalahan, tangani kesalahan
      print('Error: $e');
      return [];
    }
  }

  // TODO: Implement method to get latest pendapatan harian
  Future<List<Map<String, dynamic>>> getLatestPendapatanHarian() async {
    try {
      // Mengambil data pendapatan harian terbaru dari Firestore
      final snapshots = await FirebaseFirestore.instance
          .collection('pendapatan_harian')
          .orderBy('tanggal', descending: true)
          .get();

      // List untuk menyimpan data pendapatan harian terbaru
      List<Map<String, dynamic>> latestPendapatanHarian = [];

      // Iterasi melalui setiap dokumen dalam snapshots
      snapshots.docs.forEach((doc) {
        // Menambahkan data dari setiap dokumen ke dalam list
        latestPendapatanHarian.add({
          'tanggal': doc['tanggal_pendapatan'],
          'total_harga': doc['total_harga']
        });
      });

      // Kembalikan data pendapatan harian terbaru dalam list
      return latestPendapatanHarian;
    } catch (e) {
      // Jika terjadi kesalahan, tangani kesalahan
      print('Error: $e');
      return []; // Kembalikan list kosong jika terjadi kesalahan
    }
  }

  // Fungsi untuk memformat tanggal menjadi string (YYYY-MM-DD)
  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.year}-${tanggal.month}-${tanggal.day}';
  }
}
