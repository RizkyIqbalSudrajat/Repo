import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboardpage extends StatelessWidget {
  const Dashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // group7083UkU (183:87)
        width: double.infinity,
        height: 811,
        child: Container(
          // group7082bq6 (183:90)
          padding: EdgeInsets.fromLTRB(17, 19.73, 17, 134.18),
          width: double.infinity,
          height: 800.15,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // autogroupqs4xV9n (MBiKZAuz8EpWNpf3UQQs4x)
                margin: EdgeInsets.fromLTRB(6, 0, 6, 21.26),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // vectorcEQ (183:137)
                      margin: EdgeInsets.fromLTRB(0, 0.54, 106, 0),
                      width: 20,
                      height: 19.73,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 20,
                        height: 19.73,
                      ),
                    ),
                    Container(
                      // menu7BA (183:118)
                      margin: EdgeInsets.fromLTRB(0, 0, 73, 0),
                      child: Text(
                        'Menu',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // autogroup7xqqQRA (MBiKnFNXgHQgXe4mQq7XQQ)
                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0.44),
                      width: 18,
                      height: 20.72,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 18,
                        height: 20.72,
                      ),
                    ),
                    Container(
                      // vectoriRr (183:119)
                      margin: EdgeInsets.fromLTRB(0, 2.52, 0, 0),
                      width: 20,
                      height: 19.73,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 20,
                        height: 19.73,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupotj42hS (MBiKtur6NzdHzfgsGMoTJ4)
                margin: EdgeInsets.fromLTRB(7, 0, 6, 19.73),
                padding: EdgeInsets.fromLTRB(13, 15.79, 219.5, 14.53),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x499c9c9c),
                      offset: Offset(0, 0),
                      blurRadius: 27.7000007629,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // vector6SQ (185:244)
                      margin: EdgeInsets.fromLTRB(0, 0, 15.5, 1.25),
                      width: 19,
                      height: 18.75,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 19,
                        height: 18.75,
                      ),
                    ),
                    Text(
                      // searchDmv (185:245)
                      'Search',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupuxepABN (MBiL4QaGjJm7djT4WPUxEp)
                margin: EdgeInsets.fromLTRB(0, 0, 0, 13.81),
                width: double.infinity,
                height: 29.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogroupls6tVUY (MBiLCjfj7CHNy1ygpoLs6t)
                      margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
                      padding: EdgeInsets.fromLTRB(68, 4.93, 69, 4.95),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff55bc15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        // vectorbnU (179:171)
                        child: SizedBox(
                          width: 14,
                          height: 19.71,
                          child: Image.asset(
                            "assets/Logoes.png",
                            width: 14,
                            height: 19.71,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // autogroupa2ku8XW (MBiLFuF7tdfKWhu5uUa2kU)
                      padding: EdgeInsets.fromLTRB(65.25, 5.19, 66.25, 5.92),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x499c9c9c),
                            offset: Offset(0, 0),
                            blurRadius: 27.7000007629,
                          ),
                        ],
                      ),
                      child: Center(
                        // phbowlfoodfillSHJ (179:292)
                        child: SizedBox(
                          width: 19.5,
                          height: 18.49,
                          child: Image.asset(
                            "asset/Logoes.png",
                            width: 19.5,
                            height: 18.49,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogrouptxu2xWY (MBiLN9ZiB3oX1fo49HTxu2)
                margin: EdgeInsets.fromLTRB(0, 0, 0, 6.91),
                padding: EdgeInsets.fromLTRB(17, 14.8, 19, 18.75),
                width: double.infinity,
                height: 114.45,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x499c9c9c),
                      offset: Offset(0, 0),
                      blurRadius: 27.7000007629,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // 2WQ (183:102)
                      margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                      width: 97,
                      height: 80.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/Logoes.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      // autogroup5rdiwdN (MBiLYyb14hnG9LgUA25rDi)
                      margin: EdgeInsets.fromLTRB(0, 2.96, 79, 8.64),
                      width: 64,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // autogroupaconsmv (MBiLdDxvY7A5QPtcEmaCoN)
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 6.71),
                            width: double.infinity,
                            height: 44.6,
                            child: Stack(
                              children: [
                                Positioned(
                                  // estehcUc (183:103)
                                  left: 0,
                                  top: 0,
                                  child: Align(
                                    child: SizedBox(
                                      width: 64,
                                      height: 30,
                                      child: Text(
                                        'Es Teh',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // rasataroKdv (183:104)
                                  left: 2,
                                  top: 29.5985412598,
                                  child: Align(
                                    child: SizedBox(
                                      width: 51,
                                      height: 15,
                                      child: Text(
                                        'Rasa Taro',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // rp8000dPi (183:105)
                            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: Text(
                              'Rp. 8.000',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // group7075wQQ (183:120)
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0.99),
                      width: 37,
                      height: 36.5,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 37,
                        height: 36.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupkvggrXN (MBiLp8pQiDkW8UirB3kVGg)
                margin: EdgeInsets.fromLTRB(0, 0, 0, 6.91),
                padding: EdgeInsets.fromLTRB(17, 14.8, 19, 18.75),
                width: double.infinity,
                height: 114.45,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x499c9c9c),
                      offset: Offset(0, 0),
                      blurRadius: 27.7000007629,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // 7iC (183:107)
                      margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                      width: 97,
                      height: 80.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/Logoes.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      // autogrouphadiSkU (MBiM1Yf4b632R3E3ebHAdi)
                      margin: EdgeInsets.fromLTRB(0, 2.96, 79, 8.64),
                      width: 64,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // autogroupd84ka5z (MBiM5iCnn2oA5gVMooD84k)
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 6.71),
                            width: double.infinity,
                            height: 44.6,
                            child: Stack(
                              children: [
                                Positioned(
                                  // estehEAY (183:108)
                                  left: 0,
                                  top: 0,
                                  child: Align(
                                    child: SizedBox(
                                      width: 64,
                                      height: 30,
                                      child: Text(
                                        'Es Teh',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // rasatarojd6 (183:109)
                                  left: 2,
                                  top: 29.5985412598,
                                  child: Align(
                                    child: SizedBox(
                                      width: 51,
                                      height: 15,
                                      child: Text(
                                        'Rasa Taro',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // rp80002s6 (183:110)
                            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: Text(
                              'Rp. 8.000',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // group7076y1e (183:123)
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0.99),
                      width: 37,
                      height: 36.5,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 37,
                        height: 36.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogrouppqy4ggk (MBiMGd4Gx9PaomKbk5PQY4)
                margin: EdgeInsets.fromLTRB(0, 0, 0, 6.91),
                padding: EdgeInsets.fromLTRB(17, 14.8, 19, 18.75),
                width: double.infinity,
                height: 114.45,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x499c9c9c),
                      offset: Offset(0, 0),
                      blurRadius: 27.7000007629,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // xuA (183:112)
                      margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                      width: 97,
                      height: 80.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/Logoes.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      // autogroupa7sutH2 (MBiMRXy6KFDdHwU1XJA7SU)
                      margin: EdgeInsets.fromLTRB(0, 2.96, 79, 8.64),
                      width: 64,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // autogroupeu28QWG (MBiMVnM1nebSYzg9c3eU28)
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 6.71),
                            width: double.infinity,
                            height: 44.6,
                            child: Stack(
                              children: [
                                Positioned(
                                  // estehYMa (183:113)
                                  left: 0,
                                  top: 0,
                                  child: Align(
                                    child: SizedBox(
                                      width: 64,
                                      height: 30,
                                      child: Text(
                                        'Es Teh',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // rasataror7N (183:114)
                                  left: 2,
                                  top: 29.5985412598,
                                  child: Align(
                                    child: SizedBox(
                                      width: 51,
                                      height: 15,
                                      child: Text(
                                        'Rasa Taro',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // rp8000Adr (183:115)
                            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: Text(
                              'Rp. 8.000',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // group7077Vg8 (183:126)
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0.99),
                      width: 37,
                      height: 36.5,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 37,
                        height: 36.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupmzjuDME (MBiMg2Ywh6GQXmwn9yMZJU)
                padding: EdgeInsets.fromLTRB(17, 14.8, 19, 18.75),
                width: double.infinity,
                height: 114.45,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x499c9c9c),
                      offset: Offset(0, 0),
                      blurRadius: 27.7000007629,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // VpY (183:130)
                      margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
                      width: 97,
                      height: 80.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/Logoes.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      // autogroupwgp6dA4 (MBiMoMg4fUQUk78VPrWgP6)
                      margin: EdgeInsets.fromLTRB(0, 2.96, 79, 8.64),
                      width: 64,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // autogroupuq16Mrk (MBiMtBsM8665A3xQwQuq16)
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 6.71),
                            width: double.infinity,
                            height: 44.6,
                            child: Stack(
                              children: [
                                Positioned(
                                  // estehtLt (183:131)
                                  left: 0,
                                  top: 0,
                                  child: Align(
                                    child: SizedBox(
                                      width: 64,
                                      height: 30,
                                      child: Text(
                                        'Es Teh',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // rasatarooCx (183:132)
                                  left: 2,
                                  top: 29.5985717773,
                                  child: Align(
                                    child: SizedBox(
                                      width: 51,
                                      height: 15,
                                      child: Text(
                                        'Rasa Taro',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // rp8000J9i (183:133)
                            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: Text(
                              'Rp. 8.000',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // group7084RVE (183:134)
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0.99),
                      width: 37,
                      height: 36.5,
                      child: Image.asset(
                        "assets/Logoes.png",
                        width: 37,
                        height: 36.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
