import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lji/Admin/Notifikasi/notifikasi.dart';
import 'package:lji/FOR%20USER/NotifikasiUser.dart';
import 'package:lji/Keranjang.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lji/styles/dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ListUser extends StatefulWidget {
  final DocumentSnapshot produkData;

  const ListUser({Key? key, required this.produkData}) : super(key: key);

  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool stockEmpty = widget.produkData['stok_produk'] == 0;
    return GestureDetector(
      onTap: stockEmpty
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Keranjang(
                    produkData: widget.produkData,
                  ),
                ),
              );
            },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.symmetric(vertical: 15),
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
                          image:
                              NetworkImage(widget.produkData['gambar_produk']),
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
              Text(widget.produkData['nama_produk'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Text(widget.produkData['variasi_rasa'],
                  style: GoogleFonts.poppins(
                      fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(widget.produkData['harga_produk']),
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.04;

    // Periksa apakah stok produk kosong
    bool stockEmpty = widget.produkData['stok_produk'] == 0;

    // Jika stok kosong, tampilkan teks 'Habis' dan nonaktifkan tombol
    if (stockEmpty) {
      return Center(
        child: Text(
          'Stock Habis',
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      );
    } else {
      // Jika stok tersedia, tampilkan tombol keranjang
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ACC_ADMIN(
              title: "Konfirmasi Pembelian",
              content: "Apakah benar untuk checkout pesanan ini?.",
              buttonConfirm: "Benar",
              onButtonConfirm: () async {
                // Memanggil fungsi untuk membeli langsung produk
                beliLangsung();
                print('Membeli langsung ${widget.produkData["nama_produk"]}');
                Navigator.pop(context);
              },
              buttonCancel: 'Batal',
              onButtonCancel: () {
                Navigator.pop(context);
              },
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(
              maxWidth: 40, maxHeight: 40, minWidth: 30, minHeight: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(
                73, 160, 19, 1), // Warna hijau untuk tombol keranjang
          ),
          child: Icon(
            Icons.shopping_cart,
            color: Colors.white,
            size: iconSize,
          ),
        ),
      );
    }
  }

  String? namaPembeli;
  String? userID;
  int jumlah = 1;
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

      // await _tampilkanNotifikasiLokal(message);
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> updateAdminPesananDibaca() async {
    try {
      // Mendapatkan referensi koleksi 'pesanan'
      CollectionReference pesananCollection =
          FirebaseFirestore.instance.collection('pesanan');

      // Mendapatkan semua dokumen dalam koleksi 'pesanan'
      QuerySnapshot pesananSnapshot = await pesananCollection.get();

      // Mengupdate nilai field 'dibaca' menjadi true untuk semua dokumen
      for (DocumentSnapshot doc in pesananSnapshot.docs) {
        await doc.reference.update({'dibaca': true});
      }
    } catch (error) {
      print('Error updating pesanan: $error');
    }
  }

  // Future<void> _tampilkanNotifikasiLokal(String message) async {
  //   // Inisialisasi FlutterLocalNotificationsPlugin
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   // Konfigurasi untuk Android
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('logoes');

  //   // Konfigurasi untuk platform
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   // Inisialisasi plugin
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //   // Konstruksi pesan notifikasi
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     '1',
  //     'Channel Name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: true, // Menampilkan waktu notifikasi
  //     enableLights: true,
  //     enableVibration: true,
  //     playSound: true,
  //     styleInformation: BigTextStyleInformation(
  //       message, // Pesan utama
  //       contentTitle: 'Pesanan Baru', // Judul notifikasi
  //       htmlFormatContent: true, // Mengizinkan konten dalam format HTML
  //       htmlFormatTitle: true, // Mengizinkan judul dalam format HTML
  //     ),
  //   );

  //   NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   // Tampilkan notifikasi
  //   await flutterLocalNotificationsPlugin.show(
  //     0, // ID notifikasi
  //     'Pesanan Baru', // Judul notifikasi
  //     message, // Pesan notifikasi
  //     platformChannelSpecifics,
  //     payload:
  //         'item x', // Payload notifikasi, bisa diisi dengan informasi tambahan jika diperlukan
  //   );
  //       await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse:
  //           (NotificationResponse response) async {
  //     // Tindakan saat notifikasi diterima oleh perangkat dan direspons oleh pengguna
  //     if (response.payload != null) {
  //       // Jika payload tidak null, maka kita navigasikan ke halaman NotifUser
  //       updateAdminPesananDibaca();
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => Notifikasi()),
  //       );
  //     }
  //   });
  // }

  void beliLangsung() async {
    try {
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
        totalBarang += (produk['jumlah'] as num)
            .toInt(); // Tambahkan jumlah produk ke total_barang
        hargaTotal += (produk['total_harga'] as num)
            .toInt(); // Tambahkan total harga produk ke harga_total
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
      String formattedDate =
          DateFormat('d MMM, y').format(now); // Output: 1 Jan, 2024

      // Format jamA
      String formattedTime = DateFormat('HH:mm').format(now); // Output: 09:15

      // Simpan pesanan ke Firebase
      DocumentReference pesananRef =
          await FirebaseFirestore.instance.collection('pesanan').add({
        'waktu_pesanan': Timestamp.now(),
        'nama_pembeli': namaPembeli, // Menyimpan nama pembeli
        'id_pembeli': userID, // Menyimpan ID pembeli
        'id_transaksi': '', // ID transaksi dapat diisi jika diperlukan
        'tanggal': formattedDate, // Menyimpan tanggal transaksi
        'jam': formattedTime,
        'produk': FieldValue.arrayUnion([
          // Menyimpan detail pesanan dalam bentuk array
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
        'status': 'pending', // Status pesanan menunggu persetujuan admin
        'total_barang': totalBarang, // Menambahkan field total_barang
        'harga_total': hargaTotal, // Menambahkan field harga_total
        'catatan': 'Kosong',
        'dibaca': false,
        'dibacauser': false
      });
      // Setelah dokumen ditambahkan, dapatkan ID transaksi yang dihasilkan
      String idTransaksi = pesananRef.id;

      // Kemudian, perbarui dokumen dengan ID transaksi yang dihasilkan
      await pesananRef.update({'id_transaksi': idTransaksi});

      print('Pesanan berhasil diproses');
      // Tutup dialog "Loading"
      Navigator.pop(context);

      // Tampilkan dialog "Sukses"
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
        // Send a notification to the admin user
        await sendNotificationToAdmin(
          adminFcmToken,
          '$namaPembeli telah memesan produk',
        );
        print("berhasil");
      }
      // Tampilkan notifikasi lokal
      await _tampilkanNotifikasi();
    } catch (error) {
      print('Error processing order: $error');
      // Handle error, misalnya, menampilkan pesan kesalahan kepada pengguna
      // Tutup dialog "Loading"
      Navigator.pop(context);

      // Tampilkan dialog "Error"
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
      QuerySnapshot pesananSnapshot = await pesananCollection
          .where('id_pembeli', isEqualTo: user!.uid)
          .get();

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
