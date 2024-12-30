import 'package:flutter/material.dart';
import 'package:lji/styles/shadow.dart';

class FilterAdmin extends StatefulWidget {
  const FilterAdmin({super.key});

  @override
  State<FilterAdmin> createState() => _FilterAdminState();
}

class _FilterAdminState extends State<FilterAdmin> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [shadowPrimary],
                color: selectedIndex == 0
                    ? Color.fromRGBO(73, 160, 19, 1)
                    : Colors.white,
              ),

              height: 40,
              padding: EdgeInsets.all(8.0), // Adjust padding as needed
              child: Image.asset(
                "assets/minum.png",
                height: 25,
                width: 25,
                color: selectedIndex == 0 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [shadowPrimary],
                color: selectedIndex == 1
                    ? Color.fromRGBO(73, 160, 19, 1)
                    : Colors.white,
              ),

              height: 40,
              padding: EdgeInsets.all(8.0), // Adjust padding as needed
              child: Image.asset(
                "assets/makan.png",
                height: 25,
                width: 25,
                color: selectedIndex == 1 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
