// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lji/Admin/HistoryAdmin/HistoryAdmin.dart';
import 'package:lji/Admin/Notifikasi/listpesan.dart';
import 'package:lji/styles/color.dart';
import 'package:lji/styles/dialog.dart';
import 'package:http/http.dart' as http;

class Notifikasi extends StatefulWidget {
  const Notifikasi({
    Key? key,
  }) : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
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
            "Notifikasi",
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
                  'Belum ada notifikasi',
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
                  int total_keuntungan = pesanan['total_keuntungan'];
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
                                        Expanded(
                                          child: Text(
                                            "Dari $namaPembeli",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
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
                                        "Apakah kamu mau menerima pesanan dari user yang mau membeli produk kamu ?",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 20),
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
                                              "Total Keuntungan : ",
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
                                                  .format(total_keuntungan),
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
                                                                "Pakah kamu yakin menolak barang ini",
                                                            buttonCancel:
                                                                "Batal",
                                                            onButtonCancel: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            buttonConfirm:
                                                                "Tolak",
                                                            onButtonConfirm:
                                                                () async {
                                                              // Mengatur waktu sekarang
                                                              DateTime now =
                                                                  DateTime
                                                                      .now();
                                                              String
                                                                  hariPesanan =
                                                                  getDayName(
                                                                      now);
                                                              // Format tanggal dan waktu
                                                              String
                                                                  formattedDate =
                                                                  DateFormat(
                                                                          'd MMM, y')
                                                                      .format(
                                                                          now);
                                                              String
                                                                  formattedTime =
                                                                  DateFormat(
                                                                          'HH:mm')
                                                                      .format(
                                                                          now);
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'pesanan')
                                                                  .doc(pesanan
                                                                      .id)
                                                                  .update({
                                                                'dibacauser':
                                                                    false,
                                                                'status':
                                                                    'Ditolak',
                                                                'tanggal':
                                                                    formattedDate,
                                                                'jam':
                                                                    formattedTime,
                                                                'waktu_pesanan':
                                                                    Timestamp
                                                                        .now(),
                                                                'hari':
                                                                    hariPesanan,
                                                              });
                                                              String?
                                                                  adminFcmToken =
                                                                  await getUserFcmToken(
                                                                      userId);
                                                              print(
                                                                  adminFcmToken);
                                                              if (adminFcmToken !=
                                                                  null) {
                                                                // Send a notification to the admin user
                                                                await sendNotificationToUser(
                                                                  adminFcmToken,
                                                                  'Pesanan telah Ditolak',
                                                                );
                                                                print(
                                                                    "berhasil");
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            }));
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
                                                "Tolak",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            if (statusPesanan ==
                                                'pending') // Tampilkan tombol berdasarkan status pesanan
                                              ElevatedButton(
                                                onPressed: () async {
                                                  DateTime now = DateTime.now();
                                                  String hariPesanan =
                                                      getDayName(now);
                                                  String formattedDate =
                                                      DateFormat('d MMM, y')
                                                          .format(now);
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(now);

                                                  // Variabel untuk menandai apakah ada stok yang tidak mencukupi
                                                  bool insufficientStock =
                                                      false;

                                                  // Iterasi melalui daftar produk untuk pesanan ini
                                                  for (var produk
                                                      in produkList) {
                                                    String idProduk =
                                                        produk['id_produk'];
                                                    int jumlahDipesan =
                                                        produk['jumlah'];

                                                    // Mengambil stok produk dari Firestore
                                                    DocumentSnapshot produkDoc =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'produk')
                                                            .doc(idProduk)
                                                            .get();

                                                    if (produkDoc.exists) {
                                                      int stokAwal = produkDoc[
                                                          'stok_produk'];
                                                      int stokSisa = stokAwal -
                                                          jumlahDipesan;

                                                      if (stokSisa >= 0) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              ACC_ADMIN(
                                                            title:
                                                                "Konfirmasi Pembelian",
                                                            content:
                                                                "Apakah kamu yakin menerima pesanan ini.",
                                                            buttonConfirm: "Ok",
                                                            onButtonConfirm:
                                                                () async {
                                                              // Update stok produk
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'produk')
                                                                  .doc(idProduk)
                                                                  .update({
                                                                'stok_produk':
                                                                    stokSisa,
                                                              });

                                                              // Update status pesanan
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'pesanan')
                                                                  .doc(pesanan
                                                                      .id)
                                                                  .update({
                                                                'dibacauser':
                                                                    false,
                                                                'status':
                                                                    'Diterima',
                                                                'tanggal':
                                                                    formattedDate,
                                                                'jam':
                                                                    formattedTime,
                                                                'waktu_pesanan':
                                                                    DateTime
                                                                        .now(),
                                                                'hari':
                                                                    hariPesanan,
                                                              });

                                                              // Tambahkan keuntungan ke dalam koleksi "keuntungan"
                                                              double
                                                                  totalKeuntungan =
                                                                  produk[
                                                                      'keuntungan']; // Misalkan ini adalah total keuntungan untuk produk
                                                              await tambahkanKeuntungan(
                                                                  totalKeuntungan);

                                                              // Kirim notifikasi ke admin user
                                                              String?
                                                                  adminFcmToken =
                                                                  await getUserFcmToken(
                                                                      userId);
                                                              if (adminFcmToken !=
                                                                  null) {
                                                                await sendNotificationToUser(
                                                                    adminFcmToken,
                                                                    'Pesanan telah diterima');
                                                                print(
                                                                    "berhasil");
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            buttonCancel:
                                                                'Batal',
                                                            onButtonCancel: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        );
                                                      } else {
                                                        // Tandai bahwa ada stok yang tidak mencukupi
                                                        insufficientStock =
                                                            true;
                                                      }
                                                    } else {
                                                      // Tampilkan dialog produk tidak ditemukan
                                                      print(
                                                          'Produk tidak ditemukan');
                                                    }
                                                  }

                                                  // Jika ada stok yang tidak mencukupi, tampilkan dialog stok tidak mencukupi
                                                  if (insufficientStock) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return WarningDialog(
                                                          title: "Peringatan",
                                                          content:
                                                              "Stok tidak mencukupi",
                                                          buttonConfirm: "Ok",
                                                          onButtonConfirm: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 73, 160, 19),
                                                  minimumSize: Size(0, 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Terima",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
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

  Future<String?> getUserFcmToken(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['fcmToken'];
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> sendNotificationToUser(String fcmToken, String message) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAoDVgzIg:APA91bF4qRUd_N2SI6yPjryYeKGf8AaobqILbdDNDqaLOzK12VNliot_bCIFtYKXnNX4EX-s0LNUMqM7d0vxveJyB2_Uzzmg-1VRbBmiN9g690tGSLjEFjct0Hx0y34Sftx2nTNT2JV5',
        },
        body: json.encode(<String, dynamic>{
          'to': fcmToken,
          'priority': 'high',
          'notification': <String, dynamic>{
            'title': 'Pesanan',
            'body': message,
          },
        }),
      );

      await _tampilkanNotifikasi();
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> _tampilkanNotifikasiLokal(String message) async {
    // Inisialisasi FlutterLocalNotificationsPlugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Konfigurasi untuk Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logoes');

    // Konfigurasi untuk platform
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inisialisasi plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Konstruksi pesan notifikasi
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'Channel Name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true, // Menampilkan waktu notifikasi
      enableLights: true,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(
        message, // Pesan utama
        contentTitle: 'Pesanan', // Judul notifikasi
        htmlFormatContent: true, // Mengizinkan konten dalam format HTML
        htmlFormatTitle: true, // Mengizinkan judul dalam format HTML
      ),
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Mendapatkan tanggal dan waktu sekarang
    DateTime now = DateTime.now();

    // Tampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi
      'Pesanan Baru', // Judul notifikasi
      message, // Pesan notifikasi
      platformChannelSpecifics,
      payload:
          'item x', // Payload notifikasi, bisa diisi dengan informasi tambahan jika diperlukan
    );
  }

  Future<void> _tampilkanNotifikasi() async {
    // Inisialisasi FlutterLocalNotificationsPlugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Konfigurasi untuk Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logoes');

    // Konfigurasi untuk platform
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inisialisasi plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Konstruksi pesan notifikasi
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'Channel Name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true, // Menampilkan waktu notifikasi
      enableLights: true,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(
        'Berhasil konfirmasi pesanan', // Pesan utama
        contentTitle: 'Konfirmasi pesanan', // Judul notifikasi
        htmlFormatContent: true, // Mengizinkan konten dalam format HTML
        htmlFormatTitle: true, // Mengizinkan judul dalam format HTML
      ),
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Mendapatkan tanggal dan waktu sekarang
    DateTime now = DateTime.now();

    // Tampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi
      'Checkout pesanan', // Judul notifikasi
      'Kamu telah checkout pesananmu, tunggu konfirmasi dari admin dulu ya........!!!!!!!\n\n${DateFormat('dd MMMM yyyy, HH:mm').format(now)}', // Pesan notifikasi dengan tanggal
      platformChannelSpecifics,
      payload:
          'item x', // Payload notifikasi, bisa diisi dengan informasi tambahan jika diperlukan
    );
    // Tambahkan logika navigasi ke halaman NotifUser saat notifikasi ditekan
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      // Tindakan saat notifikasi diterima oleh perangkat dan direspons oleh pengguna
      if (response.payload != null) {
        // Jika payload tidak null, maka kita navigasikan ke halaman NotifUser
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RiwayatAdmin()),
        );
      }
    });
  }
}

// Fungsi untuk menambahkan keuntungan ke dalam koleksi "keuntungan"
Future<void> tambahkanKeuntungan(double totalKeuntungan) async {
  try {
    // Dapatkan referensi ke dokumen "keuntungan" yang akan menyimpan total keuntungan
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('keuntungan').doc('total');

    // Cek apakah dokumen "total" sudah ada
    DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists) {
      // Jika dokumen sudah ada, lakukan increment pada field "total"
      await docRef.update({
        'total': FieldValue.increment(totalKeuntungan),
      });
    } else {
      // Jika dokumen belum ada, buat dokumen baru dengan field "total"
      await docRef.set({
        'total': totalKeuntungan,
      });
    }
  } catch (e) {
    print('Error updating keuntungan: $e');
  }
}
