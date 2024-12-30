import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lji/Admin/Notifikasi/notifikasi.dart';
import 'package:lji/FOR%20USER/HistoryUser/HistoryUser.dart';
import 'package:lji/FOR%20USER/ListPesanan/ListPesanan.dart';
import 'package:lji/FOR%20USER/NotifikasiUser.dart';
import 'package:lji/TampilanUserKeranjang.dart';
import 'package:lji/filterUser.dart';
import 'package:lji/FOR%20USER/listMenuUser.dart';
import 'package:lji/styles/bottomlogout.dart';
import 'package:lji/styles/color.dart';
import 'package:lji/styles/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuUser extends StatefulWidget {
  MenuUser({
    Key? key,
  }) : super(key: key);

  @override
  _MenuUserState createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  String searchQuery = '';
  String selectedCategory = "Minuman";
  late Stream<QuerySnapshot> produkStream;
  List<DocumentSnapshot> produkList = [];
  User? user = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data produk saat widget diinisialisasi
    produkStream = FirebaseFirestore.instance.collection('produk').snapshots();
    produkStream.listen((QuerySnapshot querySnapshot) {
      setState(() {
        produkList = querySnapshot.docs.toList();
      });
    });
  }

  void _showLogoutBottomSheet(BuildContext context) {
    LogoutBottomSheet.show(context, AuthService());
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('onWillPop called'); // Add this line for debugging

        // Show exit confirmation dialog
        bool exitConfirmed = await showDialog(
          context: context,
          builder: (context) => DeleteDialog(
            title: 'Peringatan',
            content: 'Apakah Anda yakin ingin keluar dari aplikasi ?',
            buttonConfirm: 'Ok',
            onButtonConfirm: () =>
                Navigator.of(context).pop(true), // Wrap this in a function
            buttonCancel: 'Batal',
            onButtonCancel: () =>
                Navigator.of(context).pop(false), // Wrap this in a function
          ),
        );

        // If user confirms exit or dialog is dismissed, exit the app
        if (exitConfirmed) {
          SystemNavigator.pop();
          return true; // Return true to prevent further handling
        }

        return false; // Return false to allow normal back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Menu',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                height: 3,
                color: Color(0xff000000),
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              _showLogoutBottomSheet(context);
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 17, top: 17),
              height: 25,
              width: 25,
              child: Image.asset(
                "assets/logout.png",
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => listpesanan(
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.list,
                size: 25,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 13,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiwayatUser(
                      userId: user!.uid,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.history,
                size: 25,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 13,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pesanan')
                  .where('id_pembeli', isEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                // Cek setiap dokumen dalam koleksi pesanan
                for (var doc in snapshot.data!.docs) {
                  // Cek apakah field 'diif (doc.exists && doc.data() is Map<String, dynamic>) {
                  var data = doc.data() as Map<String, dynamic>;
                  bool dibaca = data.containsKey('dibacauser')
                      ? data['dibacauser']
                      : false;
                  if (!dibaca) {
                    return GestureDetector(
                      onTap: () {
                        updateAllPesananDibaca();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotifUser(
                              userId: user!.uid,
                            ),
                          ),
                        );
                      },
                      child: Badge(
                        isLabelVisible: true,
                        child: Icon(
                          Icons.notifications,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                }
                // Jika tidak ada pesanan yang belum dibaca, tampilkan badge dengan isLabelVisible false
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotifUser(
                          userId: user!.uid,
                        ),
                      ),
                    );
                  },
                  child: Badge(
                    isLabelVisible:
                        false, // Tidak ada pesanan yang belum dibaca
                    child: Icon(
                      Icons.notifications,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              width: 13,
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Icon(
                    Icons.shopping_cart,
                    size: 25,
                    color: Colors.black,
                  );
                }

                // Get the data from the snapshot
                Map<String, dynamic>? userData =
                    snapshot.data!.data() as Map<String, dynamic>?;

                // Check if userData is null or if 'cart' key is not present
                if (userData == null || !userData.containsKey('cart')) {
                  // If userData is null or 'cart' key is not present, display the cart icon without badge
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KeranjangPage02(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      size: 25,
                      color: Colors.black,
                    ),
                  );
                }

                // Get the cart data
                List<dynamic> cart = userData['cart'];

                // Check if cart is not empty
                if (cart.isNotEmpty) {
                  // If cart is not empty, display the cart icon with badge
                  return Badge(
                    isLabelVisible: true,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KeranjangPage02(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  // If cart is empty, display the cart icon without badge
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KeranjangPage02(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      size: 25,
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(156, 156, 156, 0.28999999165534973),
                      offset: Offset(0, 0),
                      blurRadius: 3,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    cursorColor: Colors.green,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: produkStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Column(
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
                          ]));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "Tidak ada produk yang tersedia.",
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }
                    List<DocumentSnapshot> filteredProdukList = snapshot
                        .data!.docs
                        .where((produk) =>
                            (produk['nama_produk'] as String)
                                .toLowerCase()
                                .contains(searchQuery))
                        .toList();

                    if (filteredProdukList.isEmpty) {
                      return Center(
                        child: Text(
                          "Tidak ditemukan atau keyword salah.",
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredProdukList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot produk = filteredProdukList[index];
                        return ListUser(produkData: produk);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> deleteAllPesanan() async {
  try {
    CollectionReference pesananCollection =
        FirebaseFirestore.instance.collection('pesanan');
    QuerySnapshot pesananSnapshot = await pesananCollection
        .where('id_pembeli', isEqualTo: user!.uid)
        .get();

    for (DocumentSnapshot doc in pesananSnapshot.docs) {
      await doc.reference.delete();
    }

    // Menampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Semua pesanan berhasil dihapus."),
      ),
    );
  } catch (e) {
    print("Error deleting pesanan: $e");

    // Menampilkan pesan error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Terjadi kesalahan saat menghapus pesanan."),
      ),
    );
  }
}

}
