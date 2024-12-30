// ignore_for_file: unused_local_variable, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:lji/Admin/Create/textField.dart';
import 'package:lji/FOR%20USER/NotifikasiUser.dart';
import 'package:lji/styles/color.dart';
import 'package:lji/styles/dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartItem {
  bool isChecked;
  String productId;
  String productImage;
  String productName;
  String productVariation;
  int quantity;
  int price;
  int productStock;
  int keuntungan;

  CartItem(
      {required this.isChecked,
      required this.productId,
      required this.productImage,
      required this.productName,
      required this.productVariation,
      required this.quantity,
      required this.price,
      required this.productStock,
      required this.keuntungan});
}

enum LoadingStatus {
  Loading,
  Loaded,
  Empty,
}

class KeranjangPage02 extends StatefulWidget {
  KeranjangPage02({Key? key});

  @override
  State<KeranjangPage02> createState() => KeranjangPage01();
}

class KeranjangPage01 extends State<KeranjangPage02> {
  String selectedPaymentMethod =
      ''; // Menyimpan pilihan, bisa "Offline" atau "Online"
  String selectedButton = "";
  User? user = FirebaseAuth.instance.currentUser;
  bool _isEditing = false;
  bool _isKeyBoard = true;
  bool _isTotalDisabled = false;
  List<CartItem> cartItems = [];
  LoadingStatus _loadingStatus =
      LoadingStatus.Loading; // Inisialisasi status loading
  TextEditingController catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() async {
    String? userID;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userID = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      // Periksa apakah bidang "cart" ada dalam dokumen dan tidak kosong
      if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('cart')) {
          List<CartItem> items = [];
          List<dynamic> cart = userData['cart'];

          for (var item in cart) {
            DocumentSnapshot productDoc = await FirebaseFirestore.instance
                .collection('produk')
                .doc(item['product_id'])
                .get();

            // Check if the product document exists
            if (productDoc.exists) {
              items.add(CartItem(
                productId: item['product_id'],
                productName: productDoc['nama_produk'],
                productVariation: productDoc['variasi_rasa'],
                quantity: item['jumlah'],
                price: productDoc['harga_produk'],
                isChecked: true,
                productImage: productDoc['gambar_produk'],
                productStock: productDoc['stok_produk'],
                keuntungan: productDoc['keuntungan'],
              ));
            } else {
              // Handle the case where the product has been deleted
              print('Product with ID ${item['product_id']} no longer exists');

              // Optionally, remove the item from the user's cart in Firestore
              await _removeProductFromCart(item['product_id']);
            }
          }

          setState(() {
            cartItems = items;
            if (!_isEditing) {
              for (var item in cartItems) {
                item.isChecked = true;
              }
            }
            _loadingStatus = cartItems.isNotEmpty
                ? LoadingStatus.Loaded
                : LoadingStatus.Empty; // Ubah status loading
          });
        }
      } else {
        // Jika 'cart' tidak ditemukan
        setState(() {
          cartItems = []; // Kosongkan list cartItems
          _loadingStatus = LoadingStatus.Empty; // Ubah status loading
        });
      }
    }
  }

  Future<void> _removeProductFromCart(String productId) async {
    // Get user ID from the authenticated user
    String? userID;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userID = user.uid;

      try {
        // Get the user's cart data
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .get();

        List<dynamic> updatedCart = List.from(userDoc['cart']);

        // Remove the item with the specified product_id from the user's cart
        updatedCart.removeWhere((item) => item['product_id'] == productId);

        // Update the cart in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .update({'cart': updatedCart});

        print('Product removed from the cart');

        // Print the current cart after removal for debugging purposes
        DocumentSnapshot updatedUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .get();
        print('Updated Cart: ${updatedUserDoc['cart']}');
      } catch (error) {
        print('Error removing product from the cart: $error');
        // Handle error, if needed
      }
    }
  }

  void _updateTotalPrice() async {
    // Calculate total price based on selected quantities
    int total = 0;

    // List untuk menyimpan produk yang perlu dihapus
    List<String> productsToDelete = [];

    for (var item in cartItems) {
      if (item.isChecked) {
        total += item.quantity * item.price;
      }
      if (item.quantity == 0) {
        bool deleteConfirmed = await _showDeleteConfirmationDialog(item);
        if (deleteConfirmed) {
          productsToDelete.add(item.productId);
        } else {
          // Jika pengguna menolak hapus, set jumlah kembali ke 1
          item.quantity = 1;
        }
      }
    }

    // Hapus produk dari Firestore
    await _deleteProductsFromFirestore(productsToDelete);

    // Setelah semua pekerjaan asinkron selesai, update state
    setState(() {
      _isTotalDisabled = total <= 0;
      if (cartItems.isEmpty) {
        for (var item in cartItems) {
          item.isChecked = false;
        }
      }
    });
  }

  void _checkout() async {
    String catatan =
        catatanController.text.isEmpty ? "Kosong" : catatanController.text;

    // Tampilkan dialog "Loading"
    showDialog(
      context: context,
      builder: (context) => Loading(
        isLoading: true,
        title: 'Sedang diproses',
      ),
    );

    try {
      // Ambil informasi pengguna yang sedang diotentikasi
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userID = user.uid;

        // Ambil detail produk yang dipilih
        List<Map<String, dynamic>> selectedProducts = [];
        double totalKeuntungan = 0; // Variabel untuk menyimpan total keuntungan

        for (var item in cartItems) {
          if (item.isChecked) {
            double keuntunganProduk = (item.price * item.quantity) * 0.2;

            selectedProducts.add({
              'nama_produk': item.productName,
              'variasi_rasa': item.productVariation,
              'harga_produk': item.price,
              'jumlah': item.quantity,
              'id_produk': item.productId,
              'gambar_produk': item.productImage,
              'total_harga': item.price * item.quantity,
              'keuntungan': keuntunganProduk,
            });

            totalKeuntungan +=
                keuntunganProduk; // Tambahkan keuntungan per produk
          }
        }

        // Hitung total barang dan harga total
        int totalBarang = 0;
        int hargaTotal = 0;

        for (var produk in selectedProducts) {
          totalBarang += produk['jumlah'] as int;
          hargaTotal += produk['total_harga'] as int;
        }

        // Mengonversi totalKeuntungan menjadi int sebelum disimpan
        int totalKeuntunganInt = totalKeuntungan.toInt(); // Konversi ke int

        String? namaPembeli = await getUsernameFromUserID(userID);

        // Dapatkan tanggal dan waktu sekarang
        DateTime now = DateTime.now();

        // Format tanggal dan waktu
        String formattedDate = DateFormat('d MMM, y').format(now);
        String formattedTime = DateFormat('HH:mm').format(now);

        // Menyimpan metode pembayaran yang dipilih
        String metodePembayaran =
            selectedPaymentMethod; // Menyimpan metode pembayaran "Offline" atau "Online"

        // Simpan pesanan ke database Firestore
        await FirebaseFirestore.instance.collection('pesanan').add({
          'nama_pembeli':
              namaPembeli, // Gunakan nama pengguna sebagai nama pembeli
          'id_pembeli': userID,
          'tanggal': formattedDate,
          'jam': formattedTime,
          'produk': selectedProducts,
          'status': 'pending',
          'total_barang': totalBarang,
          'harga_total': hargaTotal,
          'waktu_pesanan': Timestamp.now(),
          'catatan': catatan, // Menggunakan catatan yang telah ditentukan
          'metode_pembayaran':
              metodePembayaran, // Menambahkan metode pembayaran
          'dibaca': false,
          'dibacauser': false,
          'total_keuntungan':
              totalKeuntunganInt, // Menyimpan total keuntungan sebagai int
        });

        // Hapus produk yang telah dibeli dari keranjang
        await _deleteSelectedProducts();

        // Tutup dialog "Loading"
        Navigator.pop(context);

        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (context) => SucessDialog(
            title: 'Berhasil',
            content: 'Pesanan berhasil diproses.',
            buttonConfirm: 'Ok',
            onButtonConfirm: () {
              Navigator.pop(context);
            },
          ),
        );

        // Kirim pemberitahuan ke admin
        String? adminFcmToken = await getAdminFcmToken();
        if (adminFcmToken != null) {
          await sendNotificationToAdmin(
            adminFcmToken,
            'Ada beberapa pesanan baru yang menunggu konfirmasi',
          );
          print("berhasil");
        }

        await _tampilkanNotifikasi();
      } else {
        // Handle case where the user is not authenticated
        print('User not authenticated');
      }
    } catch (error) {
      print('Error processing order: $error');
      // Handle error, misalnya, menampilkan pesan kesalahan kepada pengguna
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

  Future<String?> getUsernameFromUserID(String userID) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userID).get();

      if (userSnapshot.exists) {
        return userSnapshot['username'];
      } else {
        return null; // Atau nilai default jika pengguna tidak ditemukan
      }
    } catch (error) {
      print('Error getting username: $error');
      return null; // Atau nilai default jika terjadi kesalahan
    }
  }

  Future<bool> _showDeleteConfirmationDialog(CartItem cartItem) async {
    bool deleteConfirmed = false;

    await showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        title: 'Peringatan',
        content: 'Apakah Anda yakin ingin menghapus produk ini?',
        buttonCancel: 'Tidak',
        onButtonCancel: () {
          // Set deleteConfirmed menjadi false dan tutup dialog
          deleteConfirmed = false;
          Navigator.pop(context);
        },
        buttonConfirm: 'Ya',
        onButtonConfirm: () {
          // Set deleteConfirmed menjadi true dan tutup dialog
          deleteConfirmed = true;
          Navigator.pop(context);
        },
      ),
    );

    return deleteConfirmed;
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

  Future<void> updateAllPesananDibaca() async {
    try {
      // Mendapatkan referensi koleksi 'pesanan' dengan filter berdasarkan userID
      CollectionReference pesananCollection =
          FirebaseFirestore.instance.collection('pesanan');
      QuerySnapshot pesananSnapshot =
          await pesananCollection.where('id_pembeli', isEqualTo: user).get();

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

  Future<void> _deleteProductsFromFirestore(List<String> productIds) async {
    // Dapatkan user ID dari pengguna yang sedang diotentikasi
    String? userID;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userID = user.uid;

      // Hapus produk dari koleksi cart pada dokumen pengguna
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      List<dynamic> updatedCart = List.from(userDoc['cart']);

      // Hapus item dengan product_id yang ada di dalam productIds
      updatedCart
          .removeWhere((item) => productIds.contains(item['product_id']));

      // Update data di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update({'cart': updatedCart});
    }
    if (productIds.isNotEmpty) {
      _loadCartItems();
    }
    setState(() {
      cartItems.removeWhere((item) => productIds.contains(item.productId));
    });
  }

  Future<void> _deleteSelectedProducts() async {
    List<String> selectedProductIds = [];

    for (var item in cartItems) {
      if (item.isChecked) {
        selectedProductIds.add(item.productId);
      }
    }

    if (selectedProductIds.isNotEmpty) {
      // Hapus produk yang dipilih dari Firestore
      await _deleteProductsFromFirestore(selectedProductIds);

      // Setelah menghapus, load kembali daftar produk
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Keranjang',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 3,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(width: 3),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _isEditing ? Colors.red : Color(0xFF49A013),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${cartItems.where((item) => item.isChecked).length}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditing = !_isEditing;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            margin: EdgeInsets.only(right: 10),
            child: Text(
              _isEditing ? 'Selesai' : 'Ubah',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xff000000),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return _isEditing
        ? SingleChildScrollView(
            reverse: true,
            child: Container(
              // Bottom navigation bar when editing
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color(0x499c9c9c),
                  offset: Offset(0, 0),
                  blurRadius: 2,
                ),
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                child: BottomAppBar(
                  height: 70,
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  elevation: 1,
                  notchMargin: 8,
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteDialog(
                              title: 'Peringatan',
                              content:
                                  'Apakah kamu yakin ingin menghapus list keranjangmu ?',
                              buttonConfirm: 'Ok',
                              onButtonConfirm: () {
                                _deleteSelectedProducts();
                                Navigator.pop(context);
                              },
                              buttonCancel: 'Cancel',
                              onButtonCancel: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
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
                height: 234,
                elevation: 1,
                notchMargin: 8,
                color: Colors.white,
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: "Catatan (Opsional) : ",
                      hintText: "Tambahkan catatan",
                      controller: catatanController,
                    ),
                    SizedBox(
                        height:
                            5), // Menambahkan jarak antara CustomTextField dan Text
                    Align(
                      alignment: Alignment.centerLeft, // Menyusun teks ke kiri
                      child: Text(
                        'Opsi Pembayaran',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Menambahkan jarak ke bawah
                    Row(
                      children: [
                        ChoiceChip(
                          checkmarkColor: Colors.white,
                          label: Text(
                            'Offline',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: selectedPaymentMethod == 'Offline',
                          onSelected: (bool selected) {
                            setState(() {
                              selectedPaymentMethod = selected ? 'Offline' : '';
                            });
                          },
                          selectedColor: Color(0xff4fb60e),
                          backgroundColor: Colors.grey,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(width: 10),
                        ChoiceChip(
                          checkmarkColor: Colors.white,
                          label: Text(
                            'Online',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: selectedPaymentMethod == 'Online',
                          onSelected: (bool selected) {
                            setState(() {
                              selectedPaymentMethod = selected ? 'Online' : '';
                            });
                          },
                          selectedColor: Color(0xff4fb60e),
                          backgroundColor: Colors.grey,
                          shape: StadiumBorder(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Total : ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(_calculateTotal())}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ACC_ADMIN(
                                title: "Konfirmasi Pembelian",
                                content:
                                    "Apakah benar untuk checkout pesanan ini?.",
                                buttonConfirm: "Benar",
                                onButtonConfirm: () async {
                                  _checkout();
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
                            backgroundColor: Color(0xff4fb60e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            'Checkout',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Builder(builder: (context) {
        if (_loadingStatus == LoadingStatus.Loading) {
          // Tampilkan dialog loading jika proses pemanggilan sedang berlangsung
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitWave(size: 43, color: greenPrimary),
              SizedBox(
                height: 30,
              ),
              Text(
                'Loading',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: greenPrimary),
              )
            ],
          );
        } else if (_loadingStatus == LoadingStatus.Empty) {
          // Tampilkan pesan "Belum ada keranjang" jika keranjang kosong
          return Center(
            child: Text(
              'Belum ada keranjang',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  height: 60,
                  child: Row(
                    children: [
                      Checkbox(
                        value: cartItems.isNotEmpty &&
                            cartItems.every((item) => item.isChecked),
                        onChanged: cartItems.isNotEmpty
                            ? (value) {
                                setState(() {
                                  cartItems.forEach((item) {
                                    item.isChecked = value!;
                                  });
                                  _updateTotalPrice();
                                });
                              }
                            : null, // Nonaktifkan checkbox jika keranjang kosong
                        visualDensity: VisualDensity(
                          horizontal: -0.0,
                          vertical: -0.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide.none,
                        ),
                        activeColor:
                            _isEditing ? Colors.red : Color(0xFF49A013),
                        checkColor: Colors.white,
                      ),
                      Text(
                        'Semua',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      CartItem cartItem = cartItems[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shadowColor: Color(0x499c9c9c),
                            elevation: 3,
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: cartItems[index].isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              cartItems[index].isChecked =
                                                  value!;
                                              _updateTotalPrice();
                                            });
                                          },
                                          visualDensity: VisualDensity(
                                            horizontal: -4.0,
                                            vertical: -4.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide.none,
                                          ),
                                          activeColor: _isEditing
                                              ? Colors.red
                                              : Color(0xFF49A013),
                                          checkColor: Colors.white,
                                        ),
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  cartItem.productImage),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItem.productName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                cartItem.productVariation,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 9),
                                              ),
                                              Text(
                                                NumberFormat.currency(
                                                        locale: 'id',
                                                        symbol: 'Rp ',
                                                        decimalDigits: 0)
                                                    .format(cartItem.price),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        highlightColor: Colors.transparent,
                                        icon: Icon(
                                            Icons.do_not_disturb_on_outlined),
                                        iconSize: 22,
                                        color: Color(0xFF49A013),
                                        onPressed: () {
                                          if (cartItems[index].quantity > 0) {
                                            setState(() {
                                              cartItems[index].quantity--;
                                              _updateTotalPrice();
                                            });
                                          }
                                        },
                                      ),
                                      IntrinsicWidth(
                                        child: Text(
                                          '${cartItems[index].quantity}',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: cartItems[index].quantity <
                                                      cartItems[index]
                                                          .productStock
                                                  ? Color(0xFF49A013)
                                                  : Colors.grey[350]),
                                        ),
                                      ),
                                      IconButton(
                                        highlightColor: Colors.transparent,
                                        icon: Icon(Icons.add_circle_outline),
                                        iconSize: 22,
                                        color: cartItems[index].quantity >=
                                                cartItems[index].productStock
                                            ? Colors.grey[
                                                350] // Ubah warna menjadi abu-abu jika melebihi stok_produk
                                            : Color(0xFF49A013),
                                        onPressed: () {
                                          setState(() {
                                            if (cartItems[index].quantity <
                                                cartItems[index].productStock) {
                                              cartItems[index].quantity++;
                                            }
                                            _updateTotalPrice();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: Visibility(
        visible: _calculateTotal() > 0,
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  int _calculateTotal() {
    int total = 0;
    for (var item in cartItems) {
      if (item.isChecked) {
        total += item.quantity * item.price;
      }
    }
    return total;
  }
}
