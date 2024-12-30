import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lji/Admin/Update/update.dart';

class ListMenu extends StatelessWidget {
  final DocumentSnapshot produkData;
  const ListMenu({super.key, required this.produkData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateProduk(
              namaProduk: produkData['nama_produk'],
              hargaProduk: produkData['harga_produk'].toString(),
              stokProduk: produkData['stok_produk'].toString(),
              gambarUrl: produkData['gambar_produk'],
              varianProduk: produkData['variasi_rasa'],
              documentId: produkData.id,
              kadaluwarsa: produkData['kadaluwarsa'],
              keuntungan: produkData['keuntungan'].toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.symmetric(vertical: 10),
        height: 116,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(156, 156, 156, 0.29),
              offset: Offset(0, 0),
              blurRadius: 3,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(produkData['gambar_produk']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    _buildTextInfo(),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(produkData['nama_produk'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Text(produkData['variasi_rasa'],
                  style: GoogleFonts.poppins(
                      fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                  .format(produkData['harga_produk']),
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    String stokText = produkData['stok_produk'] == 0
        ? "Habis"
        : "${produkData['stok_produk']}";
    Color textColor =
        produkData['stok_produk'] == 0 ? Colors.red : Colors.black;

    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        "Stok: $stokText",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color:
              textColor, // Menggunakan warna yang telah ditentukan berdasarkan kondisi
        ),
      ),
    );
  }
}
