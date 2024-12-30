// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lji/Admin/Create/create_produk.dart';
import 'package:lji/Admin/HistoryAdmin/HistoryAdmin.dart';
import 'package:lji/Admin/Notifikasi/notifikasi.dart';
import 'package:lji/Admin/Stok/list_produk.dart';
import 'package:lji/filterUser.dart';
import 'package:lji/styles/button.dart';
import 'package:lji/styles/dialog.dart';
import 'package:lji/styles/font.dart';
import 'package:google_fonts/google_fonts.dart';

class TabbarStok extends StatefulWidget {
  @override
  _TabbarStok createState() => _TabbarStok();
}

class _TabbarStok extends State<TabbarStok>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String selectedCategory;
  late Stream<QuerySnapshot> produkStream;
  TextEditingController _numberController = TextEditingController();
  int _number = 0;
  int _max = 2;
  bool isChecklistMode = false;
  bool isAllChecked = false;
  bool checkAll = false;
  List<bool> isCheckedList = []; // Ganti jumlah item sesuai kebutuhan
  List<DocumentSnapshot> produkList = [];
  bool isAscendingOrder = true;
  String searchQuery = '';
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // Mengubah panjang menjadi 2
    selectedCategory = "Minuman"; // Default category
    _isMounted = true;
    _numberController.text = '$_number';
    produkStream = FirebaseFirestore.instance.collection('produk').snapshots();
    produkStream.listen((QuerySnapshot querySnapshot) {
      if (_isMounted) {
        setState(() {
          isCheckedList =
              List.generate(querySnapshot.docs.length, (index) => false);
          produkList = querySnapshot.docs.toList();
        });
      }
    });
  }

  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _updateNumber() {
    setState(() {
      _number = int.tryParse(_numberController.text) ?? 0;
    });
  }

  bool isAnyItemChecked() {
    return isCheckedList.contains(true);
  }

  void _increment() {
    setState(() {
      _number++;
      _numberController.text = '$_number';
    });
  }

  void _decrement() {
    setState(() {
      if (_number > 0) {
        _number--;
        _numberController.text = '$_number';
      }
    });
  }

  void ubahItem() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tambah Produk",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: _decrement,
                  ),
                  Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none),
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) => _updateNumber(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _increment,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: redButton,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Batal",
                        style: textButton,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: greenButton,
                      onPressed: () {
                        Navigator.pop(context);
                        updateSelectedStock();
                        deactivateChecklistMode();
                        showDialog(
                          context: context,
                          builder: (context) => SucessDialog(
                            title: 'Berhasil',
                            content: 'Berhasil menambahkan stok',
                            buttonConfirm: 'Ok',
                            onButtonConfirm: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Konfirmasi",
                        style: textButton,
                      ))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void hapusItem() {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        title: 'Peringatan',
        content: 'Apakah anda yakin menghapus produk ini?',
        buttonCancel: 'Batal',
        onButtonCancel: () {
          Navigator.pop(context);
        },
        buttonConfirm: 'Hapus',
        onButtonConfirm: () {
          Navigator.pop(context);
          deleteCheckedItems();
        },
      ),
    );
  }

  void activateChecklistMode() {
    setState(() {
      isChecklistMode = true;
      checkAll = isCheckedList.every((isChecked) => isChecked);
    });
  }

  void deactivateChecklistMode() {
    if (_isMounted) {
      setState(() {
        isChecklistMode = false;
        toggleCheckAll(false);
        print("Fungsi ini dipanggil");
      });
    }
  }

  void toggleCheckAll(bool value) {
    setState(() {
      isCheckedList = List.generate(isCheckedList.length, (index) => value);
      isAllChecked = value;
    });
  }

  void toggleItemCheck(int index) {
    setState(() {
      isCheckedList[index] = !isCheckedList[index];
      // Cek apakah semua item sudah terpilih
      bool allChecked = isCheckedList.every((isChecked) => isChecked);

      // Set nilai checkAll berdasarkan kondisi
      checkAll = allChecked;
    });
  }

  void showPopupMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          100, 150, 200, 0), // Adjust the position as needed
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Banyak ke Sedikit',
          child: Text('Banyak ke Sedikit'),
        ),
        PopupMenuItem<String>(
          value: 'Sedikit ke Banyak',
          child: Text('Sedikit ke Banyak'),
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue != null) {
        handlePopupMenuSelection(selectedValue);
      }
    });
  }

  void handlePopupMenuSelection(String selectedValue) {
    setState(() {
      if (selectedValue == 'Banyak ke Sedikit') {
        isAscendingOrder = false;
        produkList.sort((a, b) {
          print("banyak ke sedikit");
          int stokA = a['stok_produk'] as int;
          int stokB = b['stok_produk'] as int;
          return stokA.compareTo(stokB);
        });
      } else if (selectedValue == 'Sedikit ke Banyak') {
        isAscendingOrder = true;
        produkList.sort((a, b) {
          print("sedikitbanyak ke ");
          int stokA = a['stok_produk'] as int;
          int stokB = b['stok_produk'] as int;
          return stokB.compareTo(stokA);
        });
      }
    });
  }

  void updateSelectedStock() {
    for (int i = 0; i < isCheckedList.length; i++) {
      if (isCheckedList[i]) {
        int currentStock = produkList[i]['stok_produk'] as int;
        int updatedStock = currentStock + _number; // Use the entered number

        // Update the stock for the selected product in Firestore
        FirebaseFirestore.instance
            .collection('produk')
            .doc(produkList[i].id)
            .update({
          'stok_produk': updatedStock,
          'kategori_produk':
              produkList[i]['kategori_produk'] ?? 'DefaultCategory',
        });
      }
    }
  }

  void deleteCheckedItems() {
    try {
      // Get a list of document IDs to be deleted
      List<String> itemsToDelete = [];
      for (int i = 0; i < isCheckedList.length; i++) {
        if (isCheckedList[i]) {
          itemsToDelete.add(produkList[i].id);
        }
      }

      // Delete items from Firestore
      itemsToDelete.forEach((documentId) async {
        await FirebaseFirestore.instance
            .collection('produk')
            .doc(documentId)
            .delete();
      });

      // Refresh the StreamBuilder
      setState(() {
        // You may need to adjust this if your stream initialization depends on other conditions
        produkStream =
            FirebaseFirestore.instance.collection('produk').snapshots();
      });
      // Show success message or handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Items deleted successfully.'),
        ),
      );
      deactivateChecklistMode();
    } catch (error) {
      print('Error deleting items: $error');
      // Show error message or handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting items.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isAnyItemChecked()
          ? BottomAppBar(
              shape: CircularNotchedRectangle(),
              elevation: 1,
              shadowColor: const Color.fromARGB(255, 7, 3, 3),
              surfaceTintColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: greenButton,
                    onPressed: ubahItem,
                    child: Text(
                      'Ubah',
                      style: textButton,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: hapusItem,
                    style: redButton,
                    child: Text(
                      'Hapus',
                      style: textButton,
                    ),
                  ),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RiwayatAdmin(),
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
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Notifikasi(),
                ),
              );
            },
            child: Icon(
              Icons.notifications,
              size: 25,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 13,
          )
        ],
        centerTitle: true,
        title: Text(
          "Produk",
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: FilterUser(
                onMinumanSelected: (category) {
                  setState(() {
                    selectedCategory = category;
                    _tabController.animateTo(0); // Tab 1
                  });
                },
                onMakananSelected: (category) {
                  setState(() {
                    selectedCategory = category;
                    _tabController.animateTo(1); // Tab 2
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isChecklistMode
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  checkAll = false;
                                });
                                deactivateChecklistMode();
                              },
                              icon: Icon(Icons.close),
                            ),
                            Text("Batal")
                          ],
                        )
                      : Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      156, 156, 156, 0.28999999165534973),
                                  offset: Offset(0, 0),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                  isChecklistMode
                      ? Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              activeColor: Color.fromRGBO(73, 160, 19, 1),
                              value: checkAll,
                              onChanged: (value) {
                                setState(() {
                                  checkAll = value!;
                                });
                                toggleCheckAll(value!);
                              },
                            ),
                            SizedBox(
                              width: 15,
                            )
                          ],
                        )
                      : Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showPopupMenu();
                              },
                              icon: Icon(Icons.filter_list_rounded),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TambahProduk(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(73, 160, 19, 1),
                                    minimumSize: Size(30, 30),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))))
                          ],
                        ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: produkStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            // Ambil data produk dari snapshot
                            produkList = snapshot.data!.docs
                                .where((produk) =>
                                    (produk['kategori_produk'] as String?)
                                            ?.isNotEmpty ==
                                        true &&
                                    (produk['kategori_produk'] as String) ==
                                        selectedCategory &&
                                    (produk['nama_produk'] as String)
                                        .toLowerCase()
                                        .contains(searchQuery))
                                .toList();

                            // Jika hasil pencarian kosong, tampilkan pesan
                            if (produkList.isEmpty) {
                              return Center(
                                child: Text(
                                  'Tidak ada produk atau keyword salah',
                                  style: GoogleFonts.poppins(),
                                ),
                              );
                            }

                            produkList.sort((a, b) {
                              int stokA = a['stok_produk'] as int;
                              int stokB = b['stok_produk'] as int;
                              return isAscendingOrder
                                  ? stokA.compareTo(stokB)
                                  : stokB.compareTo(stokA);
                            });

                            return ListView.builder(
                              itemCount: produkList.length,
                              itemBuilder: (context, index) {
                                return ListProduk(
                                  isChecklistMode: isChecklistMode,
                                  isChecked: isCheckedList[index],
                                  onToggleCheck: () {
                                    toggleItemCheck(index);
                                  },
                                  // Tambahkan data produk dari Firestore ke ListProduk
                                  produkData: produkList[index],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Center(child: Text('Tab 2 Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
