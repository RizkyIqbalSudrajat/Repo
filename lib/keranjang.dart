// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lji/FOR%20USER/NotifikasiUser.dart';
import 'package:lji/styles/color.dart';
import 'package:lji/styles/dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Keranjang extends StatefulWidget {
  final DocumentSnapshot produkData;
  Keranjang({Key? key, required this.produkData}) : super(key: key);

  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  String? namaPembeli;
  String? userID;
  int jumlah = 1;
  TextEditingController catatanController = TextEditingController();
  @override
  void dispose() {
    // Hapus controller saat widget di dispose
    catatanController.dispose();
    super.dispose();
  }

  void tambahkanKeKeranjang() async {
    // Mendapatkan informasi pengguna yang sedang diotentikasi
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userID = user.uid;
    } else {
      // Handle case where the user is not authenticated
      print('User not authenticated');
      return;
    }

    // Tampilkan dialog "Loading"
    showDialog(
      context: context,
      barrierDismissible:
          false, // Mencegah dialog ditutup dengan mengetuk di luar area dialog
      builder: (BuildContext context) {
        return Loading(
          isLoading: true,
          title: 'Loading',
        );
      },
    );

    // Update cart di dalam dokumen pengguna
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'cart': FieldValue.arrayUnion([
        {
          'product_id': widget
              .produkData.id, // Gunakan ID dokumen produk sebagai product_id
          'jumlah': jumlah
        }
      ])
    }).then((value) {
      print('Produk ditambahkan ke keranjang');
      // Tutup dialog "Loading"
      Navigator.pop(context);

      // Tampilkan dialog "Sukses"
      showDialog(
        context: context,
        builder: (context) => SucessDialog(
          title: 'Sukses',
          content: 'Dimasukkan ke keranjang',
          buttonConfirm: 'Oke',
          onButtonConfirm: () {
            Navigator.pop(context);
          },
        ),
      );
    }).catchError((error) {
      print('Gagal menambahkan produk ke keranjang: $error');
      // Handle error, misalnya, menampilkan pesan kesalahan kepada pengguna

      // Tutup dialog "Loading"
      Navigator.pop(context);
    });
  }

  Future<String?> getAdminFcmToken() async {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      return userSnapshot.docs[0]['fcmToken'];
    }

    return null;
  }

  Future<void> sendNotificationToAdmin(String fcmToken, String message) async {
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
            'title': 'Pesanan baru',
            'body': message,
          },
        }),
      );

      await _tampilkanNotifikasiLokal(message);
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
        contentTitle: 'Pesanan Baru', // Judul notifikasi
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

  void beliLangsung() async {
    String catatan =
        catatanController.text.isEmpty ? "Kosong" : catatanController.text;

    try {
      // Tampilkan dialog "Loading"
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Loading(
            isLoading: true,
            title: 'Loading',
          );
        },
      );

      // Ambil informasi produk
      String gambarProduk = widget.produkData["gambar_produk"];
      String namaProduk = widget.produkData["nama_produk"];
      String variasiRasa = widget.produkData["variasi_rasa"];
      int hargaProduk = widget.produkData["harga_produk"];
      String idProduk = widget.produkData.id;

      // Hitung total barang dan harga total
      int totalBarang = 0;
      int hargaTotal = 0;

      // Iterasi melalui setiap produk yang dibeli
      for (var produk in [
        {
          'nama_produk': namaProduk,
          'variasi_rasa': variasiRasa,
          'harga_produk': hargaProduk,
          'jumlah': jumlah,
          'id_produk': idProduk,
          'gambar_produk': gambarProduk,
          'total_harga': hargaProduk * jumlah
        }
      ]) {
        totalBarang += (produk['jumlah'] as num).toInt();
        hargaTotal += (produk['total_harga'] as num).toInt();
      }

      // Mendapatkan informasi pengguna yang sedang diotentikasi
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        userID = user.uid;
        String? username = await getUsernameFromUserID(userID!);
        // Gunakan username sebagai nama pembeli
        namaPembeli = username;
      } else {
        // Handle case where the user is not authenticated
        print('User not authenticated');
        return;
      }

      // Dapatkan tanggal sekarang
      DateTime now = DateTime.now();

      // Format tanggal
      String formattedDate = DateFormat('d MMM, y').format(now);

      // Format jam
      String formattedTime = DateFormat('HH:mm').format(now);

      // Simpan pesanan ke Firebase
      DocumentReference pesananRef =
          await FirebaseFirestore.instance.collection('pesanan').add({
        'waktu_pesanan': Timestamp.now(),
        'nama_pembeli': namaPembeli,
        'id_pembeli': userID,
        'id_transaksi': '',
        'tanggal': formattedDate,
        'jam': formattedTime,
        'produk': FieldValue.arrayUnion([
          {
            'nama_produk': namaProduk,
            'variasi_rasa': variasiRasa,
            'harga_produk': hargaProduk,
            'jumlah': jumlah,
            'id_produk': idProduk,
            'gambar_produk': gambarProduk,
            'total_harga': hargaProduk * jumlah
          }
        ]),
        'status': 'pending',
        'total_barang': totalBarang,
        'harga_total': hargaTotal,
        'catatan': catatan, // Menggunakan catatan yang telah ditentukan
        'dibaca': false,
        'dibacauser': false
      });

      String idTransaksi = pesananRef.id;
      await pesananRef.update({'id_transaksi': idTransaksi});

      print('Pesanan berhasil diproses');
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => SucessDialog(
          title: 'Berhasil',
          content: 'Pesanan berhasil diproses. Tunggu konfirmasi admin.',
          buttonConfirm: 'Ok',
          onButtonConfirm: () {
            Navigator.pop(context);
          },
        ),
      );

      String? adminFcmToken = await getAdminFcmToken();
      print(adminFcmToken);
      if (adminFcmToken != null) {
        await sendNotificationToAdmin(
          adminFcmToken,
          '$namaPembeli telah memesan produk',
        );
        print("berhasil");
      }

      await _tampilkanNotifikasi();
    } catch (error) {
      print('Error processing order: $error');
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => WarningDialog(
          title: 'Error',
          content: 'Gagal memproses pesanan.',
          buttonConfirm: 'Ok',
          onButtonConfirm: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  Future<void> updateAllPesananDibaca() async {
    try {
      // Mendapatkan referensi koleksi 'pesanan' dengan filter berdasarkan userID
      CollectionReference pesananCollection =
          FirebaseFirestore.instance.collection('pesanan');
      QuerySnapshot pesananSnapshot =
          await pesananCollection.where('id_pembeli', isEqualTo: userID).get();

      // Mengupdate nilai field 'dibacauser' menjadi true untuk semua dokumen yang terkait dengan userID saat ini
      for (DocumentSnapshot doc in pesananSnapshot.docs) {
        await doc.reference.update({'dibacauser': true});
      }
    } catch (error) {
      print('Error updating pesanan: $error');
    }
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
        'Kamu telah checkout pesananmu, tunggu konfirmasi dari admin dulu ya........!!!!!!!', // Pesan utama
        contentTitle: 'Checkout pesanan', // Judul notifikasi
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
        updateAllPesananDibaca();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotifUser(
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  )),
        );
      }
    });
  }

  Future<String?> getUsernameFromUserID(String userID) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userID).get();

      if (userSnapshot.exists) {
        return userSnapshot['username'];
      } else {
        return ''; // Atau nilai default jika pengguna tidak ditemukan
      }
    } catch (error) {
      print('Error getting owner name: $error');
      return ''; // Atau nilai default jika terjadi kesalahan
    }
  }

  @override
  Widget build(BuildContext context) {
    String gambarProduk = widget.produkData["gambar_produk"];
    String namaProduk = widget.produkData["nama_produk"];
    String variasiRasa = widget.produkData["variasi_rasa"];
    String kadaluwarsa = widget.produkData["kadaluwarsa"];
    int hargaProduk = widget.produkData["harga_produk"];
    int stokProduk = widget.produkData["stok_produk"];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Beli Menu",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 23,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context)
                          .size
                          .width, // Sesuaikan tinggi dengan lebar untuk membuat gambar persegi
                      child: AspectRatio(
                        aspectRatio:
                            1, // Memastikan gambar tetap berbentuk persegi
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            gambarProduk,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        namaProduk,
                        style: GoogleFonts.poppins(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff030303),
                        ),
                      ),
                    ),
                    Text(
                      variasiRasa,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000),
                      ),
                    ),
                    Text(
                      'Kadaluwarsa: $kadaluwarsa',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Stok: $stokProduk",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(hargaProduk),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: Color(0xff49a013),
                  ),
                ), //kedua
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan (Opsional)', // Add a title for the notes
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10), // Add some spacing
                    TextField(
                      cursorColor: greenPrimary,
                      controller:
                          catatanController, // Tambahkan controller ke TextField
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(),
                        hintText: 'Tambahkan catatan...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: greenPrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: greenPrimary),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0x499c9c9c),
            offset: Offset(0, 0),
            blurRadius: 2,
          ),
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: BottomAppBar(
            surfaceTintColor: Colors.white,
            height: 70,
            elevation: 1,
            notchMargin: 8,
            shape: CircularNotchedRectangle(),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika untuk memasukkan produk ke keranjang
                      tambahkanKeKeranjang();
                      print(
                          'Menambahkan ${widget.produkData["nama_produk"]} ke keranjang');
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: greenPrimary, width: 2),
                      minimumSize: Size(double.minPositive, 50),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: greenPrimary,
                    )),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ACC_ADMIN(
                          title: "Konfirmasi Pembelian",
                          content: "Apakah benar untuk checkout pesanan ini?.",
                          buttonConfirm: "Benar",
                          onButtonConfirm: () async {
                            // Memanggil fungsi untuk membeli langsung produk
                            beliLangsung();
                            print(
                                'Membeli langsung ${widget.produkData["nama_produk"]}');
                            Navigator.pop(context);
                          },
                          buttonCancel: 'Batal',
                          onButtonCancel: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.minPositive, 50),
                      backgroundColor: Color(0xff4fb60e),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Beli Langsung',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
