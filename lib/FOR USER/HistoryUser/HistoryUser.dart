import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lji/FOR%20USER/HistoryUser/list_history.dart';
import 'package:lji/styles/color.dart';

class RiwayatUser extends StatefulWidget {
  final String userId;
  const RiwayatUser({Key? key, required this.userId}) : super(key: key);

  @override
  _RiwayatUserState createState() => _RiwayatUserState();
}

class _RiwayatUserState extends State<RiwayatUser> {
  late Stream<QuerySnapshot> _pesananStream;
  String? _selectedFilter;
  @override
  void initState() {
    super.initState();
    _pesananStream = _fetchDataPesanan();
  }

  Stream<QuerySnapshot> _fetchDataPesanan() {
    Query query = FirebaseFirestore.instance
        .collection('pesanan')
        .where('id_pembeli', isEqualTo: widget.userId)
        .where('status', whereIn: ["Diterima", "Ditolak"]).orderBy(
            'waktu_pesanan',
            descending: true);

    if (_selectedFilter != null) {
      query = query.where('status', isEqualTo: _selectedFilter);
    }

    return query.snapshots();
  }

  void _onFilterChanged(String? newFilter) {
    setState(() {
      _selectedFilter = _selectedFilter == newFilter ? null : newFilter;
      _pesananStream = _fetchDataPesanan();
    });
  }

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
            child: StreamBuilder<QuerySnapshot>(
              stream: _pesananStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

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
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: greenPrimary),
                      )
                    ],
                  );
                }

                // List of pesanan
                final List<DocumentSnapshot> pesananList = snapshot.data!.docs;

                if (pesananList.isEmpty) {
                  return Center(
                      child: Text(
                    'Tidak ada riwayat',
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 15),
                  ));
                }

                return ListView.builder(
                  itemCount: pesananList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot pesanan = pesananList[index];
                    String tanggal = pesanan['tanggal'];
                    String jam = pesanan['jam'];
                    int totalHarga = pesanan['harga_total'];
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
                                      "List Pesanan kamu",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
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
                                SizedBox(height: 10),
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
                                        produk: produkList[index],
                                      ),
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
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [],
                                ),
                                Container(
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
                                        "Pesan $status",
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
