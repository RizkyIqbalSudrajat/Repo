// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lji/Admin/Notifikasi/listpesan.dart';
import 'package:lji/styles/color.dart';
import 'package:lji/styles/dialog.dart';

class listpesanan extends StatefulWidget {
  const listpesanan({
    Key? key,
  }) : super(key: key);

  @override
  State<listpesanan> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<listpesanan> {
  late Stream<QuerySnapshot> pesananStream;
  bool hasNotifications = false; // Tambahkan variabel boolean

  @override
  void initState() {
    super.initState();
    pesananStream = FirebaseFirestore.instance
        .collection('pesanan')
        .where('status', isEqualTo: 'pending')
        .orderBy('waktu_pesanan', descending: false)
        .snapshots();
    pesananStream.listen((snapshot) {
      setState(() {
        hasNotifications = snapshot.docs.isNotEmpty;
      });
    });
  }

  String getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.year}-${tanggal.month}-${tanggal.day}';
  }

  Future<void> tambahkanPendapatanHarian(
      DateTime tanggal, int totalHarga, String tanggal_pendapatan) async {
    DateTime now = DateTime.now();
    try {
      // Cek apakah dokumen pendapatan harian untuk tanggal ini sudah ada
      final snapshot = await FirebaseFirestore.instance
          .collection('pendapatan_harian')
          .doc(_formatTanggal(tanggal))
          .get();

      if (snapshot.exists) {
        // Jika dokumen sudah ada, tambahkan total harga baru ke total yang ada
        int totalSaatIni = snapshot['total_harga'];
        await snapshot.reference
            .update({'total_harga': totalSaatIni + totalHarga, 'tanggal': now});
      } else {
        // Jika dokumen belum ada, buat dokumen baru dengan total harga pesanan
        await FirebaseFirestore.instance
            .collection('pendapatan_harian')
            .doc(_formatTanggal(tanggal))
            .set({
          'tanggal': tanggal,
          'total_harga': totalHarga,
          'tanggal_pendapatan': tanggal_pendapatan
        });
      }

      print('Pendapatan harian berhasil ditambahkan!');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> tambahkanPendapatanMingguan(
      DateTime tanggal, int totalHarga, String tanggal_pendapatan) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM, y').format(now);
    try {
      // Mengambil tanggal awal dan akhir minggu dari tanggal yang diberikan
      DateTime awalMinggu =
          tanggal.subtract(Duration(days: tanggal.weekday - 1));
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

      // Cek apakah dokumen pendapatan mingguan untuk minggu ini sudah ada
      final snapshot = await FirebaseFirestore.instance
          .collection('pendapatan_mingguan')
          .doc('$awalMingguStr-$akhirMingguStr')
          .get();

      if (snapshot.exists) {
        // Jika dokumen sudah ada, tambahkan total harga baru ke total yang ada
        int totalSaatIni = snapshot['total_harga'];
        await snapshot.reference.update({
          'total_harga': totalSaatIni + totalHarga,
          'tanggal': now,
          'tanggal_pendapatan': formattedDate
        });
      } else {
        // Jika dokumen belum ada, buat dokumen baru dengan total harga pesanan
        await FirebaseFirestore.instance
            .collection('pendapatan_mingguan')
            .doc('$awalMingguStr-$akhirMingguStr')
            .set({
          'awal_minggu': awalMinggu,
          'akhir_minggu': akhirMinggu,
          'total_harga': totalHarga,
          'tanggal': now,
          'tanggal_pendapatan': formattedDate
        });
      }

      print('Pendapatan mingguan berhasil ditambahkan!');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: Text(
            "List Pesanan",
            style:
                GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w500),
          ),
        ),
        body: StreamBuilder(
            stream: pesananStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        size: 43,
                        color: greenPrimary,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Loading',
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: greenPrimary),
                      )
                    ]);
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final pesananList = snapshot.data!.docs;
              if (pesananList.isEmpty) {
                return Center(
                    child: Text(
                  'Belum ada pesanan yang berlangsung',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                  ),
                ));
              }
              return ListView.builder(
                itemCount: pesananList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot pesanan = pesananList[index];
                  String userId =
                      pesanan['id_pembeli']; // Ambil user_id dari data pesanan
                  String catatan =
                      pesanan['catatan']; // Ambil user_id dari data pesanan
                  String namaPembeli = pesanan['nama_pembeli'];
                  String tanggal = pesanan['tanggal'];
                  String jam = pesanan['jam'];
                  int totalHarga = pesanan['harga_total'];
                  int totalBarang = pesanan['total_barang'];
                  List<dynamic> produkList = pesanan['produk'];
                  String statusPesanan = pesanan['status'];
                  String metodepembayaran = pesanan['metode_pembayaran'];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(
                                    156, 156, 156, 0.28999999165534972),
                                offset: Offset(0, 0),
                                blurRadius: 3,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.circle_notifications_rounded,
                                          color:
                                              Color.fromARGB(255, 73, 160, 19),
                                        ),
                                        SizedBox(width: 2),
                                        SizedBox(width: 15),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    tanggal,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Catatan: ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: null,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "$catatan",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                        maxLines: null,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Metode Pembayaran: ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: null,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "$metodepembayaran",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                        maxLines: null,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "List Pesanan: ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: produkList.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                ListPesan(
                                              produk: produkList[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Total : ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                      locale: 'id',
                                                      symbol: 'Rp ',
                                                      decimalDigits: 0)
                                                  .format(totalHarga),
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      if (statusPesanan == 'pending')
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      DeleteDialog(
                                                    title: "Peringatan",
                                                    content:
                                                        "Apakah kamu yakin membatalkan pesanan ini?",
                                                    buttonCancel: "Batal",
                                                    onButtonCancel: () {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonConfirm: "Batalkan",
                                                    onButtonConfirm: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('pesanan')
                                                          .doc(pesanan.id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize: Size(0, 40),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                "Batal Pesanan",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }));
  }
}
