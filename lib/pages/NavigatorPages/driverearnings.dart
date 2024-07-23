import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/landingpage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';
import '../noInternet/nointernet.dart';

class DriverEarnings extends StatefulWidget {
  const DriverEarnings({Key? key}) : super(key: key);

  @override
  State<DriverEarnings> createState() => _DriverEarningsState();
}

class _DriverEarningsState extends State<DriverEarnings> {
  bool _isLoading = true;
  int _showEarning = 0;
  int _pickDate = 0;
  dynamic fromDate;
  dynamic toDate;
  dynamic _fromDate, _toDate;
  String _error = '';

  @override
  void initState() {
    _error = '';
    getEarnings();
    super.initState();
  }

  navigateLogout() {
    if (ownermodule == '1') {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
            (route) => false);
      });
    } else {
      ischeckownerordriver = 'driver';
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      });
    }
  }

//getting earnings data
  getEarnings() async {
    driverTodayEarnings.clear();
    var val = await driverTodayEarning();
    if (val == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _datePicker() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: (_pickDate == 2) ? fromDate : DateTime(2020),
        lastDate: DateTime.now());
    if (picker != null) {
      setState(() {
        if (_pickDate == 1) {
          fromDate = picker;
          _fromDate = picker.toString().split(" ")[0];
          toDate = null;
          _toDate = null;
        } else if (_pickDate == 2) {
          toDate = picker;
          _toDate = picker.toString().split(" ")[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(media.width * 0.05,
                  media.width * 0.05, media.width * 0.05, 0),
              height: media.height * 1,
              width: media.width * 1,
              color: page,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: media.width * 0.05),
                        width: media.width * 1,
                        alignment: Alignment.center,
                        child: MyText(
                          text: languages[choosenLanguage]['text_earnings'],
                          size: media.width * twenty,
                          fontweight: FontWeight.w600,
                        ),
                      ),
                      Positioned(
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                  height: media.width * 0.05,
                                  width: media.width * 0.05,
                                  child: Icon(Icons.arrow_back_ios,
                                      color: textColor))))
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                    padding: EdgeInsets.all(media.width * 0.01),
                    height: media.width * 0.12,
                    width: media.width * 0.85,
                    decoration: BoxDecoration(
                        color: page,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.grey.withOpacity(0.2))
                        ]),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _showEarning = 0;
                              _isLoading = true;
                            });

                            var val = await driverTodayEarning();
                            if (val == 'logout') {
                              navigateLogout();
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Container(
                              height: media.width * 0.1,
                              alignment: Alignment.center,
                              width: media.width * 0.28,
                              decoration: BoxDecoration(
                                  borderRadius: (_showEarning == 0)
                                      ? BorderRadius.circular(12)
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                        color: (_showEarning == 0)
                                            ? Colors.black.withOpacity(0.2)
                                            : page,
                                        spreadRadius: 2,
                                        blurRadius: 2)
                                  ],
                                  color:
                                      (_showEarning == 0) ? textColor : page),
                              child: MyText(
                                text: languages[choosenLanguage]['text_today'],
                                size: media.width * fifteen,
                                fontweight: FontWeight.w600,
                                color: (_showEarning == 0) ? page : textColor,
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _showEarning = 1;
                              _isLoading = true;
                            });

                            var val = await driverWeeklyEarning();
                            if (val == 'logout') {
                              navigateLogout();
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Container(
                              height: media.width * 0.1,
                              alignment: Alignment.center,
                              width: media.width * 0.26,
                              decoration: BoxDecoration(
                                  borderRadius: (_showEarning == 1)
                                      ? BorderRadius.circular(12)
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                        color: (_showEarning == 1)
                                            ? Colors.black.withOpacity(0.2)
                                            : page,
                                        spreadRadius: 2,
                                        blurRadius: 2)
                                  ],
                                  color:
                                      (_showEarning == 1) ? textColor : page),
                              child: MyText(
                                text: languages[choosenLanguage]['text_weekly'],
                                size: media.width * fifteen,
                                fontweight: FontWeight.w600,
                                color: (_showEarning == 1) ? page : textColor,
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              driverReportEarnings.clear();
                              _toDate = null;
                              _fromDate = null;
                              _error = '';
                              _showEarning = 2;
                            });
                          },
                          child: Container(
                              height: media.width * 0.1,
                              alignment: Alignment.center,
                              width: media.width * 0.28,
                              decoration: BoxDecoration(
                                  borderRadius: (_showEarning == 2)
                                      ? BorderRadius.circular(12)
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                        color: (_showEarning == 2)
                                            ? Colors.black.withOpacity(0.2)
                                            : page,
                                        spreadRadius: 2,
                                        blurRadius: 2)
                                  ],
                                  color:
                                      (_showEarning == 2) ? textColor : page),
                              child: MyText(
                                text: languages[choosenLanguage]['text_report'],
                                size: media.width * fifteen,
                                fontweight: FontWeight.w600,
                                color: (_showEarning == 2) ? page : textColor,
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: (driverTodayEarnings.isNotEmpty && _showEarning == 0)
                        ?
                        //current day earnings
                        Column(children: [
                            Stack(
                              children: [
                                Container(
                                  width: media.width * 0.9,
                                  height: media.width * 0.54,
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffAAAAAA)
                                              .withOpacity(0.55)),
                                      // color: Color(0xffAAAAAA).withOpacity(0.55),
                                      borderRadius: BorderRadius.circular(
                                          media.width * 0.05),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: const [
                                            0.42,
                                            0.77
                                          ],
                                          colors: [
                                            const Color(0xffCACAC2)
                                                .withOpacity(0.5),
                                            const Color(0xff646460)
                                                .withOpacity(0.3)
                                          ])),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: media.width * 0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_todayearn'],
                                              size: media.width * sixteen,
                                              color: (isDarkTheme == true)
                                                  ? Colors.black
                                                  : textColor,
                                              fontweight: FontWeight.w500,
                                            ),
                                            SizedBox(
                                              width: media.width * 0.05,
                                            ),
                                            MyText(
                                              text:
                                                  '${driverTodayEarnings['currency_symbol']}${driverTodayEarnings['total_earnings'].toStringAsFixed(2)}',
                                              size: media.width * eighteen,
                                              color: (isDarkTheme == true)
                                                  ? Colors.black
                                                  : textColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.07,
                                      ),
                                      SizedBox(
                                        width: media.width * 0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  width: media.width * 0.17,
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_trips'],
                                                    size:
                                                        media.width * fourteen,
                                                    color: textColor,
                                                    fontweight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.015,
                                                ),
                                                Container(
                                                  width: media.width * 0.17,
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: driverTodayEarnings[
                                                            'total_trips_count']
                                                        .toString(),
                                                    size: media.width * sixteen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: media.width * 0.025,
                                            ),
                                            Container(
                                              height: media.width * 0.14,
                                              width: media.width * 0.01,
                                              color: const Color(0xffD9D9D9),
                                            ),
                                            SizedBox(
                                              width: media.width * 0.025,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: media.width * 0.17,
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_enable_wallet'],
                                                    size:
                                                        media.width * fourteen,
                                                    color: textColor,
                                                    fontweight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.015,
                                                ),
                                                Container(
                                                  width: media.width * 0.17,
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: driverTodayEarnings[
                                                            'total_wallet_trip_count']
                                                        .toString(),
                                                    size: media.width * sixteen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: media.width * 0.025,
                                            ),
                                            Container(
                                              height: media.width * 0.14,
                                              width: media.width * 0.01,
                                              color: const Color(0xffD9D9D9),
                                            ),
                                            SizedBox(
                                              width: media.width * 0.025,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: media.width * 0.17,
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_cash'],
                                                    size:
                                                        media.width * fourteen,
                                                    color: textColor,
                                                    fontweight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.015,
                                                ),
                                                Container(
                                                  width: media.width * 0.17,
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: driverTodayEarnings[
                                                            'total_cash_trip_count']
                                                        .toString(),
                                                    size: media.width * sixteen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -media.width * 0.09,
                                    left: media.width * 0.05,
                                    child: Container(
                                      height: media.width * 0.174,
                                      width: media.width * 0.174,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xffD9D9D9)
                                              .withOpacity(0.7)),
                                    )),
                                Positioned(
                                    top: media.width * 0.12,
                                    right: -media.width * 0.11,
                                    child: Container(
                                      height: media.width * 0.22,
                                      width: media.width * 0.22,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xff808080)
                                              .withOpacity(0.27)),
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: media.width * 0.19,
                                        width: media.width * 0.19,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffCACAC2)),
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.1,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText(
                                      text: languages[choosenLanguage]
                                          ['text_tripkm'],
                                      size: media.width * sixteen,
                                    ),
                                    MyText(
                                      text:
                                          driverTodayEarnings['total_trip_kms']
                                              .toString(),
                                      size: media.width * sixteen,
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: media.width * 0.03,
                                      bottom: media.width * 0.01),
                                  height: 1.5,
                                  color: const Color(0xffE0E0E0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText(
                                      text: languages[choosenLanguage]
                                          ['text_walletpayment'],
                                      size: media.width * sixteen,
                                    ),
                                    MyText(
                                      text: driverTodayEarnings[
                                              'currency_symbol'] +
                                          ' ' +
                                          driverTodayEarnings[
                                                  'total_wallet_trip_amount']
                                              .toStringAsFixed(2),
                                      size: media.width * sixteen,
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: media.width * 0.03,
                                      bottom: media.width * 0.01),
                                  height: 1.5,
                                  color: const Color(0xffE0E0E0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_cashpayment'],
                                  size: media.width * sixteen,
                                ),
                                MyText(
                                  text: driverTodayEarnings['currency_symbol'] +
                                      ' ' +
                                      driverTodayEarnings[
                                              'total_cash_trip_amount']
                                          .toStringAsFixed(2),
                                  size: media.width * sixteen,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.03,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: media.width * 0.03,
                                  bottom: media.width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: languages[choosenLanguage]
                                        ['text_totalearnings'],
                                    size: media.width * sixteen,
                                    color: buttonColor,
                                  ),
                                  MyText(
                                    text: driverTodayEarnings[
                                            'currency_symbol'] +
                                        ' ' +
                                        driverTodayEarnings['total_earnings']
                                            .toStringAsFixed(2),
                                    size: media.width * sixteen,
                                    color: buttonColor,
                                  ),
                                ],
                              ),
                            ),
                          ])
                        :
                        //current week earnings
                        (driverWeeklyEarnings.isNotEmpty && _showEarning == 1)
                            ? Column(children: [
                                MyText(
                                  text: driverWeeklyEarnings['start_of_week'] +
                                      ' - ' +
                                      driverWeeklyEarnings['end_of_week'],
                                  size: media.width * fifteen,
                                  color: (isDarkTheme == true)
                                      ? Colors.white
                                      : hintColor,
                                ),
                                SizedBox(
                                  height: media.width * 0.025,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyText(
                                      text: driverWeeklyEarnings[
                                          'currency_symbol'],
                                      size: media.width * eighteen,
                                    ),
                                    MyText(
                                      text:
                                          driverWeeklyEarnings['total_earnings']
                                              .toStringAsFixed(2),
                                      size: media.width * eighteen,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                SizedBox(
                                  height: media.width * 0.5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: weekDays
                                        .map((i, value) {
                                          List val = [];
                                          weekDays.forEach((i, value) {
                                            val.add(double.parse(
                                                weekDays[i].toString()));
                                          });
                                          val.sort();
                                          return MapEntry(
                                              i,
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  MyText(
                                                    text:
                                                        weekDays[i].toString(),
                                                    size: media.width * twelve,
                                                    color: (isDarkTheme == true)
                                                        ? Colors.white
                                                        : hintColor,
                                                  ),
                                                  SizedBox(
                                                    height: media.width * 0.01,
                                                  ),
                                                  Container(
                                                    width: media.width * 0.07,
                                                    height: (val.last > 0)
                                                        ? (media.width * 0.35) /
                                                            (val.last /
                                                                double.parse(
                                                                    weekDays[i]
                                                                        .toString()))
                                                        : 1,
                                                    color: buttonColor,
                                                  ),
                                                  SizedBox(
                                                    height: media.width * 0.005,
                                                  ),
                                                  MyText(
                                                    text: i,
                                                    size: media.width * twelve,
                                                    color: (isDarkTheme == true)
                                                        ? Colors.white
                                                        : hintColor,
                                                  )
                                                ],
                                              ));
                                        })
                                        .values
                                        .toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.withOpacity(0.1)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: media.width * 0.17,
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_trips'],
                                              size: media.width * sixteen,
                                              color: (isDarkTheme == true)
                                                  ? Colors.white
                                                  : hintColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.015,
                                          ),
                                          Container(
                                            width: media.width * 0.17,
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text: driverWeeklyEarnings[
                                                      'total_trips_count']
                                                  .toString(),
                                              size: media.width * sixteen,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: media.width * 0.17,
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_enable_wallet'],
                                              size: media.width * sixteen,
                                              color: (isDarkTheme == true)
                                                  ? Colors.white
                                                  : hintColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.015,
                                          ),
                                          Container(
                                            width: media.width * 0.17,
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text: driverWeeklyEarnings[
                                                      'total_wallet_trip_count']
                                                  .toString(),
                                              size: media.width * sixteen,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: media.width * 0.17,
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_cash'],
                                              size: media.width * sixteen,
                                              color: (isDarkTheme == true)
                                                  ? Colors.white
                                                  : hintColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.015,
                                          ),
                                          Container(
                                            width: media.width * 0.17,
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text: driverWeeklyEarnings[
                                                      'total_cash_trip_count']
                                                  .toString(),
                                              size: media.width * sixteen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.1,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_tripkm'],
                                          size: media.width * sixteen,
                                        ),
                                        MyText(
                                          text: driverWeeklyEarnings[
                                                  'total_trip_kms']
                                              .toString(),
                                          size: media.width * sixteen,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: media.width * 0.03,
                                          bottom: media.width * 0.03),
                                      height: 1.5,
                                      color: const Color(0xffE0E0E0),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_walletpayment'],
                                          size: media.width * sixteen,
                                        ),
                                        MyText(
                                          text: driverWeeklyEarnings[
                                                  'currency_symbol'] +
                                              ' ' +
                                              driverWeeklyEarnings[
                                                      'total_wallet_trip_amount']
                                                  .toStringAsFixed(2),
                                          size: media.width * sixteen,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: media.width * 0.03,
                                          bottom: media.width * 0.03),
                                      height: 1.5,
                                      color: const Color(0xffE0E0E0),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_cashpayment'],
                                          size: media.width * sixteen,
                                        ),
                                        MyText(
                                          text: driverWeeklyEarnings[
                                                  'currency_symbol'] +
                                              ' ' +
                                              driverWeeklyEarnings[
                                                      'total_cash_trip_amount']
                                                  .toStringAsFixed(2),
                                          size: media.width * sixteen,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: media.width * 0.03,
                                          bottom: media.width * 0.01),
                                      height: 1.5,
                                      // color: const Color(0xffE0E0E0),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: media.width * 0.03,
                                      bottom: media.width * 0.03),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_totalearnings'],
                                        size: media.width * sixteen,
                                        color: buttonColor,
                                      ),
                                      MyText(
                                        text: driverWeeklyEarnings[
                                                'currency_symbol'] +
                                            ' ' +
                                            driverWeeklyEarnings[
                                                    'total_earnings']
                                                .toStringAsFixed(2),
                                        size: media.width * sixteen,
                                        color: buttonColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                )
                              ])
                            :
                            //earning on specific choosen date
                            (_showEarning == 2)
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: media.width * 0.03,
                                      ),
                                      Row(
                                        children: [
                                          MyText(
                                            text: languages[choosenLanguage]
                                                ['text_fromDate'],
                                            size: media.width * sixteen,
                                            fontweight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.width * 0.03,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _pickDate = 1;
                                          });
                                          _datePicker();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.03),
                                              border: Border.all(
                                                  color: (isDarkTheme == true)
                                                      ? textColor
                                                          .withOpacity(0.4)
                                                      : underline)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                text: _fromDate == null
                                                    ? languages[choosenLanguage]
                                                        ['text_choose_date']
                                                    : _fromDate.toString(),
                                                size: media.width * sixteen,
                                                color:
                                                    textColor.withOpacity(0.5),
                                              ),
                                              Icon(Icons.date_range_outlined,
                                                  color: textColor)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Row(
                                        children: [
                                          MyText(
                                            text: languages[choosenLanguage]
                                                ['text_toDate'],
                                            size: media.width * sixteen,
                                            fontweight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.width * 0.03,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_fromDate != null) {
                                            setState(() {
                                              _pickDate = 2;
                                            });
                                            _datePicker();
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              media.width * 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.03),
                                              border: Border.all(
                                                  color: (isDarkTheme == true)
                                                      ? textColor
                                                          .withOpacity(0.4)
                                                      : underline)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                text: _toDate == null
                                                    ? languages[choosenLanguage]
                                                        ['text_choose_date']
                                                    : _toDate.toString(),
                                                size: media.width * sixteen,
                                                color:
                                                    textColor.withOpacity(0.5),
                                              ),
                                              Icon(Icons.date_range_outlined,
                                                  color: textColor)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.1,
                                      ),
                                      if (_error != '')
                                        Column(
                                          children: [
                                            Container(
                                                // width: media.width*0.9,
                                                constraints: BoxConstraints(
                                                    maxWidth: media.width * 0.9,
                                                    minWidth:
                                                        media.width * 0.5),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color:
                                                        const Color(0xffFFFFFF)
                                                            .withOpacity(0.5)),
                                                child: MyText(
                                                  text: _error,
                                                  size: media.width * sixteen,
                                                  color: Colors.red,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  fontweight: FontWeight.w500,
                                                )),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                          ],
                                        ),
                                      Button(
                                          onTap: () async {
                                            setState(() {
                                              driverReportEarnings.clear();
                                              _isLoading = true;
                                            });
                                            if (_toDate != null &&
                                                _fromDate != null) {
                                              setState(() {
                                                _error = '';
                                              });

                                              var val =
                                                  await driverEarningReport(
                                                      _fromDate, _toDate);
                                              if (val == 'logout') {
                                                navigateLogout();
                                              }
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            } else {
                                              setState(() {
                                                _error =
                                                    'please enter all fields to proceed';
                                              });
                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                          width: media.width * 0.5,
                                          text: languages[choosenLanguage]
                                              ['text_confirm']),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      (driverReportEarnings.isNotEmpty)
                                          ? Column(
                                              children: [
                                                MyText(
                                                  text: driverReportEarnings[
                                                          'from_date'] +
                                                      ' - ' +
                                                      driverReportEarnings[
                                                          'to_date'],
                                                  size: media.width * fifteen,
                                                  color: hintColor,
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.025,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      driverReportEarnings[
                                                          'currency_symbol'],
                                                      style:
                                                          GoogleFonts.notoSans(
                                                              fontSize:
                                                                  media.width *
                                                                      eighteen,
                                                              color: textColor),
                                                    ),
                                                    Text(
                                                      driverReportEarnings[
                                                              'total_earnings']
                                                          .toStringAsFixed(2),
                                                      style:
                                                          GoogleFonts.notoSans(
                                                              fontSize:
                                                                  media.width *
                                                                      eighteen,
                                                              color: textColor),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.05,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.05),
                                                  width: media.width * 0.9,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.grey
                                                          .withOpacity(0.1)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: media.width *
                                                                0.17,
                                                            alignment: Alignment
                                                                .center,
                                                            child: MyText(
                                                              text: languages[
                                                                      choosenLanguage]
                                                                  [
                                                                  'text_trips'],
                                                              size:
                                                                  media.width *
                                                                      sixteen,
                                                              color: hintColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.015,
                                                          ),
                                                          Container(
                                                            width: media.width *
                                                                0.17,
                                                            alignment: Alignment
                                                                .center,
                                                            child: MyText(
                                                              text: driverReportEarnings[
                                                                      'total_trips_count']
                                                                  .toString(),
                                                              size:
                                                                  media.width *
                                                                      sixteen,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 1,
                                                        height:
                                                            media.width * 0.1,
                                                        color: borderLines,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: media.width *
                                                                0.19,
                                                            alignment: Alignment
                                                                .center,
                                                            child: MyText(
                                                              text: languages[
                                                                      choosenLanguage]
                                                                  [
                                                                  'text_enable_wallet'],
                                                              size:
                                                                  media.width *
                                                                      sixteen,
                                                              color: hintColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.015,
                                                          ),
                                                          Container(
                                                            width: media.width *
                                                                0.17,
                                                            alignment: Alignment
                                                                .center,
                                                            child: MyText(
                                                              text: driverReportEarnings[
                                                                      'total_wallet_trip_count']
                                                                  .toString(),
                                                              size:
                                                                  media.width *
                                                                      sixteen,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 1,
                                                        height:
                                                            media.width * 0.1,
                                                        color: borderLines,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: media.width *
                                                                0.17,
                                                            alignment: Alignment
                                                                .center,
                                                            child: MyText(
                                                              text: languages[
                                                                      choosenLanguage]
                                                                  ['text_cash'],
                                                              size:
                                                                  media.width *
                                                                      sixteen,
                                                              color: hintColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.015,
                                                          ),
                                                          Container(
                                                            width: media.width *
                                                                0.17,
                                                            alignment: Alignment
                                                                .center,
                                                            child: MyText(
                                                              text: driverReportEarnings[
                                                                      'total_cash_trip_count']
                                                                  .toString(),
                                                              size:
                                                                  media.width *
                                                                      sixteen,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.05,
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              ['text_tripkm'],
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  fontSize: media
                                                                          .width *
                                                                      sixteen,
                                                                  color:
                                                                      textColor),
                                                        ),
                                                        Text(
                                                          driverReportEarnings[
                                                                  'total_trip_kms']
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  fontSize: media
                                                                          .width *
                                                                      sixteen,
                                                                  color:
                                                                      textColor),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: media.width *
                                                              0.03,
                                                          bottom: media.width *
                                                              0.03),
                                                      height: 1.5,
                                                      color: const Color(
                                                          0xffE0E0E0),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_walletpayment'],
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  fontSize: media
                                                                          .width *
                                                                      sixteen,
                                                                  color:
                                                                      textColor),
                                                        ),
                                                        Text(
                                                          driverReportEarnings[
                                                                  'currency_symbol'] +
                                                              ' ' +
                                                              driverReportEarnings[
                                                                      'total_wallet_trip_amount']
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  fontSize: media
                                                                          .width *
                                                                      sixteen,
                                                                  color:
                                                                      textColor),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: media.width *
                                                              0.03,
                                                          bottom: media.width *
                                                              0.03),
                                                      height: 1.5,
                                                      color: const Color(
                                                          0xffE0E0E0),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_cashpayment'],
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  fontSize: media
                                                                          .width *
                                                                      sixteen,
                                                                  color:
                                                                      textColor),
                                                        ),
                                                        Text(
                                                          driverReportEarnings[
                                                                  'currency_symbol'] +
                                                              ' ' +
                                                              driverReportEarnings[
                                                                      'total_cash_trip_amount']
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  fontSize: media
                                                                          .width *
                                                                      sixteen,
                                                                  color:
                                                                      textColor),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: media.width *
                                                              0.03,
                                                          bottom: media.width *
                                                              0.01),
                                                      height: 1.5,
                                                      // color: const Color(0xffE0E0E0),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      top: media.width * 0.03,
                                                      bottom:
                                                          media.width * 0.03),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_totalearnings'],
                                                        style: GoogleFonts
                                                            .notoSans(
                                                                fontSize: media
                                                                        .width *
                                                                    sixteen,
                                                                color:
                                                                    buttonColor),
                                                      ),
                                                      Text(
                                                        driverReportEarnings[
                                                                'currency_symbol'] +
                                                            ' ' +
                                                            driverReportEarnings[
                                                                    'total_earnings']
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: GoogleFonts
                                                            .notoSans(
                                                                fontSize: media
                                                                        .width *
                                                                    sixteen,
                                                                color:
                                                                    buttonColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      )
                                    ],
                                  )
                                : Container(),
                  ))
                ],
              ),
            ),

            //no internet
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(onTap: () {
                      setState(() {
                        internetTrue();
                      });
                    }))
                : Container(),
            //loader
            (_isLoading == true)
                ? const Positioned(child: Loading())
                : Container()
          ],
        ),
      ),
    );
  }
}
