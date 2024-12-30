import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lji/Admin/Analisis%20Uang/uang.dart';
import 'package:intl/intl.dart';

class Analisis extends StatefulWidget {
  const Analisis({super.key});

  @override
  State<Analisis> createState() => _AnalisisState();
}

class _AnalisisState extends State<Analisis> {
  late Stream<QuerySnapshot> produkStream;

  void initState() {
    super
        .initState(); // Panggil fungsi untuk mengambil data produk saat widget diinisialisasi
    produkStream = FirebaseFirestore.instance.collection('produk').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Pendapatan(),
                  ),
                );
              },
              child: Container(
                  height: 126,
                  child: Stack(children: <Widget>[
                    Container(
                        height: 126,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(156, 156, 156, 0.29),
                                offset: Offset(0, 0),
                                blurRadius: 3,
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: StreamBuilder<int>(
                                stream: getTotalPendapatanMingguan(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  }
                                  return Text(
                                    NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0)
                                        .format(snapshot.data ?? 0),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  );
                                }),
                          ),
                        )),
                    Container(
                      width: double.infinity,
                      height: 77,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        color: Color.fromRGBO(73, 160, 19, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/uang.png"),
                            Text(
                              "Uang",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ])),
            ),
          ),
          SizedBox(
            width: 40,
          ),
          Expanded(
            child: Container(
                height: 126,
                child: Stack(children: <Widget>[
                  Container(
                    height: 126,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(156, 156, 156, 0.29),
                            offset: Offset(0, 0),
                            blurRadius: 3,
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: produkStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox();
                            }

                            // Extract product data from the snapshot
                            final List<DocumentSnapshot> produkList =
                                snapshot.data!.docs.toList();

                            // Determine the length of the list
                            int length = produkList.length;

                            return Text(
                              "$length",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 77,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      color: Color.fromRGBO(73, 160, 19, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/produk.png"),
                          Text(
                            "Total Produk",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ])),
          )
        ],
      ),
    );
  }

  // Ubah dari Future menjadi Stream
  Stream<int> getTotalPendapatanMingguan() async* {
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
        yield snapshot['total_harga'];
      } else {
        // Jika dokumen tidak ditemukan, kembalikan nilai 0
        yield 0;
      }
    } catch (e) {
      // Jika terjadi kesalahan, tangani kesalahan
      print('Error: $e');
      yield 0;
    }
  }

  // Fungsi untuk memformat tanggal menjadi string (YYYY-MM-DD)
  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.year}-${tanggal.month}-${tanggal.day}';
  }
}
