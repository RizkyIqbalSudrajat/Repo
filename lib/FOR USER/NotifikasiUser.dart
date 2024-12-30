import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lji/FOR%20USER/NotifUser/CustomDonNotif.dart';
import 'package:lji/FOR%20USER/NotifUser/CustomReqNotif.dart';
import 'package:lji/FOR%20USER/NotifUser/CustomDelNotif.dart';
import 'package:lji/styles/color.dart';

class NotifUser extends StatefulWidget {
  final String userId;
  const NotifUser({Key? key, required this.userId});

  @override
  State<NotifUser> createState() => _NotifUserState();
}

class _NotifUserState extends State<NotifUser> {
  late Stream<QuerySnapshot> _pesananStream;

  @override
  void initState() {
    super.initState();
    _pesananStream = FirebaseFirestore.instance
        .collection('pesanan')
        .where('id_pembeli', isEqualTo: widget.userId)
        .orderBy('waktu_pesanan', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            height: 3,
            color: Color(0xff000000),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pesananStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                'Belum ada notifikasi',
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
              ),
            );
          }

          return ListView.builder(
            itemCount: pesananList.length,
            itemBuilder: (BuildContext context, int index) {
              final pesanan = pesananList[index];
              final status = pesanan['status'];
              final tanggal = pesanan['tanggal'];
              final jam = pesanan['jam'];

              // Menentukan jenis notifikasi berdasarkan status pesanan
              Widget notifWidget;
              if (status == 'pending') {
                notifWidget = NotifReq(
                  tanggal: tanggal,
                  waktu: jam,
                );
              } else if (status == 'Ditolak') {
                notifWidget = NotifDel(tanggal: tanggal, waktu: jam);
              } else if (status == 'Diterima') {
                notifWidget = NotifS(tanggal: tanggal, waktu: jam);
              } else {
                // Tampilkan widget default jika status tidak dikenali
                notifWidget = SizedBox();
              }

              return notifWidget;
            },
          );
        },
      ),
    );
  }
}
