import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lji/FOR%20USER/HistoryUser/list_history.dart';
import 'package:lji/styles/color.dart';

class RiwayatAdmin extends StatefulWidget {
  const RiwayatAdmin({Key? key}) : super(key: key);

  @override
  _RiwayatState createState() => _RiwayatState();
}

class _RiwayatState extends State<RiwayatAdmin> {
  late Future<List<DocumentSnapshot>> _fetchDataPesanan;
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _fetchDataPesanan = fetchDataPesanan();
  }

  Future<List<DocumentSnapshot>> fetchDataPesanan() async {
    try {
      QuerySnapshot querySnapshot;
      if (_selectedFilter == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('pesanan')
            .orderBy('waktu_pesanan', descending: true)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('pesanan')
            .where('status', isEqualTo: _selectedFilter)
            .orderBy('waktu_pesanan', descending: true)
            .get();
      }
      return querySnapshot.docs;
    } catch (error) {
      print("Error fetching pesanan: $error");
      return [];
    }
  }

  void _onFilterChanged(String? newFilter) {
    setState(() {
      _selectedFilter = _selectedFilter == newFilter ? null : newFilter;
      _fetchDataPesanan = fetchDataPesanan();
    });
  }

  //   Future<void> hapusSemuaPesanan() async {
  //   try {
  //     // Dapatkan referensi koleksi pesanan
  //     final pesananCollection = FirebaseFirestore.instance.collection('pesanan');

  //     // Dapatkan seluruh dokumen pesanan
  //     final pesananDocs = await pesananCollection.get();

  //     // Hapus setiap dokumen pesanan
  //     for (final doc in pesananDocs.docs) {
  //       await doc.reference.delete();
  //     }

  //     print('Semua pesanan berhasil dihapus');
  //   } catch (error) {
  //     print("Error deleting pesanan: $error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
          "Riwayat",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Panggil fungsi hapusSemuaPesanan ketika tombol hapus ditekan
        //       hapusSemuaPesanan();
        //     },
        //     icon: Icon(Icons.delete),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          ToggleButtons(
            splashColor: Colors.transparent,
            fillColor: Colors.transparent,
            renderBorder: false,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _selectedFilter == 'Diterima'
                      ? Colors.green
                      : Colors.transparent,
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Diterima',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: _selectedFilter == 'Diterima'
                        ? Colors.white
                        : Colors.green,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _selectedFilter == 'Ditolak'
                      ? Colors.red
                      : Colors.transparent,
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Ditolak',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: _selectedFilter == 'Ditolak'
                        ? Colors.white
                        : Colors.red,
                  ),
                ),
              ),
            ],
            isSelected: [
              _selectedFilter == 'Diterima',
              _selectedFilter == 'Ditolak',
            ],
            onPressed: (int index) {
              _onFilterChanged(index == 0 ? 'Diterima' : 'Ditolak');
            },
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _fetchDataPesanan,
              builder: (context, snapshot) {
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
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Terjadi kesalahan saat mengambil data'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                    'Belum ada riwayat',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot pesanan = snapshot.data![index];
                      String namaPembeli = pesanan['nama_pembeli'];
                      String catatan = pesanan['catatan'];
                      int totalHarga = pesanan['harga_total'];
                      int total_keuntungan = pesanan['total_keuntungan'];
                      String tanggal = pesanan['tanggal'];
                      String jam = pesanan['jam'];
                      String status = pesanan['status'];
                      List<dynamic> produkList = pesanan['produk'];
                      String metodepembayaran = pesanan['metode_pembayaran'];
                      Color statusColor = status == 'Diterima'
                          ? Color.fromARGB(255, 73, 160, 19)
                          : Colors.red;
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                    blurRadius: 2,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              color: statusColor,
                                            ),
                                          ),
                                          Icon(
                                            Icons.history,
                                            size: 19,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "List Pesanan $namaPembeli",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
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
                                        SizedBox(height: 5),
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: produkList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            ListHistory(
                                                produk: produkList[index]),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                child: Text(
                                                  "Total :",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0)
                                                .format(totalHarga),
                                            style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                child: Text(
                                                  "Total Keuntungan :",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0)
                                                .format(total_keuntungan),
                                            style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.only(right: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              tanggal,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              jam,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Pesanan $status",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: statusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
