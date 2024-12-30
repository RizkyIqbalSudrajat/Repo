import 'package:flutter/material.dart';
import 'package:lji/Admin/HistoryAdmin/HistoryAdmin.dart';
import 'package:lji/Admin/Notifikasi/notifikasi.dart';
import 'package:lji/styles/bottomlogout.dart';

// import 'package:lji/Admin/Notifikasi/notifikasi.dart';
class Header extends StatelessWidget {
  const Header({super.key});
  void _showLogoutBottomSheet(BuildContext context) {
    LogoutBottomSheet.show(context, AuthService());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _showLogoutBottomSheet(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(
                left: 10 + MediaQuery.of(context).padding.left,
              ),
              child: Icon(
                Icons.logout, // Ganti dengan ikon yang sesuai
                size: 23,
                color: Colors.red,
              ),
            ),
          ),
          Row(
            children: [
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
                  size: 23,
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
                  size: 23,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
