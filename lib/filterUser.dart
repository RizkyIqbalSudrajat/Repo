import 'package:flutter/material.dart';

class FilterUser extends StatefulWidget {
  final Function(String) onMinumanSelected;
  final Function(String) onMakananSelected;
  const FilterUser({Key? key, required this.onMinumanSelected, required this.onMakananSelected}) : super(key: key);

  @override
  State<FilterUser> createState() => _FilterUserState();
}

class _FilterUserState extends State<FilterUser> {
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
                widget.onMinumanSelected("Minuman");
              });
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(156, 156, 156, 0.29),
                      offset: Offset(0, 0),
                      blurRadius: 5,
                    )
                ],
                borderRadius: BorderRadius.circular(10),
                color: selectedIndex == 0
                    ? Color.fromRGBO(73, 160, 19, 1)
                    : Colors.white,
              ),

              height: 35,
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
              widget.onMakananSelected("Makanan");
            });
          },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(156, 156, 156, 0.29),
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                color: selectedIndex == 1
                    ? Color.fromRGBO(73, 160, 19, 1)
                    : Colors.white,
              ),

              height: 35,
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
