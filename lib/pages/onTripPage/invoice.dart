import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/landingpage.dart';
import 'review_page.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

int payby = 0;

class _InvoiceState extends State<Invoice> {
  String _error = '';
  bool _isLoading = false;
  @override
  void initState() {
    if (driverReq['is_paid'] == 0) {
      payby = 0;
    }
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        media.width * 0.05,
                        MediaQuery.of(context).padding.top + media.width * 0.05,
                        media.width * 0.05,
                        media.width * 0.05),
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                    //invoice data
                    child: (driverReq.isNotEmpty)
                        ? Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_tripsummary'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        height: media.height * 0.04,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (driverReq.isNotEmpty)
                                            Container(
                                              height: media.width * 0.13,
                                              width: media.width * 0.13,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          driverReq['userDetail']
                                                                  ['data'][
                                                              'profile_picture']),
                                                      fit: BoxFit.contain)),
                                            ),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          MyText(
                                            text: driverReq['userDetail']
                                                ['data']['name'],
                                            size: media.width * eighteen,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.height * 0.05,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.all(media.width * 0.04),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.grey.withOpacity(0.1)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    MyText(
                                                      text: languages[
                                                              choosenLanguage]
                                                          ['text_reference'],
                                                      size: media.width *
                                                          fourteen,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          media.width * 0.02,
                                                    ),
                                                    MyText(
                                                      text: driverReq[
                                                          'request_number'],
                                                      size:
                                                          media.width * twelve,
                                                      fontweight:
                                                          FontWeight.w700,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    MyText(
                                                      text: languages[
                                                              choosenLanguage]
                                                          ['text_rideType'],
                                                      size: media.width *
                                                          fourteen,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          media.width * 0.02,
                                                    ),
                                                    MyText(
                                                      text: (driverReq[
                                                                  'is_rental'] ==
                                                              false)
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['text_regular']
                                                          : languages[
                                                                  choosenLanguage]
                                                              ['text_rental'],
                                                      size:
                                                          media.width * twelve,
                                                      fontweight:
                                                          FontWeight.w700,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: media.height * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    MyText(
                                                      text: languages[
                                                              choosenLanguage]
                                                          ['text_distance'],
                                                      size: media.width *
                                                          fourteen,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          media.width * 0.02,
                                                    ),
                                                    MyText(
                                                      text: driverReq[
                                                              'total_distance'] +
                                                          ' ' +
                                                          driverReq['unit'],
                                                      size:
                                                          media.width * twelve,
                                                      fontweight:
                                                          FontWeight.w700,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    MyText(
                                                      text: languages[
                                                              choosenLanguage]
                                                          ['text_duration'],
                                                      size: media.width *
                                                          fourteen,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          media.width * 0.02,
                                                    ),
                                                    MyText(
                                                      text:
                                                          '${driverReq['total_time']} ${languages[choosenLanguage]['text_mins']}',
                                                      size:
                                                          media.width * twelve,
                                                      fontweight:
                                                          FontWeight.w700,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.height * 0.03,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: media.width * 0.05,
                                            width: media.width * 0.05,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                            child: Container(
                                              height: media.width * 0.025,
                                              width: media.width * 0.025,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white
                                                      .withOpacity(0.8)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: media.width * 0.06,
                                          ),
                                          Expanded(
                                            child: MyText(
                                              text: driverReq['pick_address'],
                                              size: media.width * twelve,
                                              // maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.width * 0.02,
                                      ),
                                      (tripStops.isNotEmpty)
                                          ? Column(
                                              children: tripStops
                                                  .asMap()
                                                  .map((i, value) {
                                                    return MapEntry(
                                                        i,
                                                        (i <
                                                                tripStops
                                                                        .length -
                                                                    1)
                                                            ? Container(
                                                                padding: EdgeInsets.only(
                                                                    top: media
                                                                            .width *
                                                                        0.02,
                                                                    bottom: media
                                                                            .width *
                                                                        0.02),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      height: media
                                                                              .width *
                                                                          0.06,
                                                                      width: media
                                                                              .width *
                                                                          0.06,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Colors
                                                                              .red
                                                                              .withOpacity(0.1)),
                                                                      child:
                                                                          MyText(
                                                                        text: (i +
                                                                                1)
                                                                            .toString(),
                                                                        // maxLines: 1,
                                                                        color: const Color(
                                                                            0xFFFF0000),
                                                                        fontweight:
                                                                            FontWeight.w600,
                                                                        size: media.width *
                                                                            twelve,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: media
                                                                              .width *
                                                                          0.05,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          MyText(
                                                                        text: tripStops[i]
                                                                            [
                                                                            'address'],
                                                                        // maxLines: 1,
                                                                        size: media.width *
                                                                            twelve,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Container());
                                                  })
                                                  .values
                                                  .toList(),
                                            )
                                          : Container(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: media.width * 0.05,
                                            width: media.width * 0.05,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red
                                                    .withOpacity(0.1)),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: media.width * 0.03,
                                              color: const Color(0xFFFF0000),
                                            ),
                                          ),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          Expanded(
                                            child: MyText(
                                              text: driverReq['drop_address'],
                                              size: media.width * twelve,
                                              // maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.height * 0.03,
                                      ),
                                      driverReq['is_bid_ride'] == 1
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  (driverReq['payment_opt'] ==
                                                          '1')
                                                      ? languages[
                                                              choosenLanguage]
                                                          ['text_cash']
                                                      : (driverReq[
                                                                  'payment_opt'] ==
                                                              '2')
                                                          ? languages[
                                                                  choosenLanguage]
                                                              ['text_wallet']
                                                          : languages[
                                                                  choosenLanguage]
                                                              ['text_card'],
                                                  style: GoogleFonts.notoSans(
                                                      fontSize: media.width *
                                                          twentyeight,
                                                      color: buttonColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.05,
                                                ),
                                                Text(
                                                  driverReq['requestBill']
                                                              ['data'][
                                                          'requested_currency_symbol'] +
                                                      ' ' +
                                                      driverReq['requestBill']
                                                                  ['data']
                                                              ['total_amount']
                                                          .toString(),
                                                  style: GoogleFonts.notoSans(
                                                      fontSize: media.width *
                                                          twentysix,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                MyText(
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_tripfare'],
                                                  size: media.width * fourteen,
                                                  fontweight: FontWeight.w700,
                                                ),
                                                SizedBox(
                                                  height: media.height * 0.05,
                                                ),
                                                (driverReq['is_rental'] == true)
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: media
                                                                        .width *
                                                                    0.05),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            MyText(
                                                              text: languages[
                                                                      choosenLanguage]
                                                                  [
                                                                  'text_ride_type'],
                                                              size:
                                                                  media.width *
                                                                      fourteen,
                                                            ),
                                                            MyText(
                                                              text: driverReq[
                                                                  'rental_package_name'],
                                                              size:
                                                                  media.width *
                                                                      fourteen,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MyText(
                                                          text: languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_baseprice'],
                                                          size: media.width *
                                                              twelve,
                                                        ),
                                                        MyText(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          text: driverReq['requestBill']
                                                                      ['data'][
                                                                  'requested_currency_symbol'] +
                                                              ' ' +
                                                              driverReq['requestBill']
                                                                          [
                                                                          'data']
                                                                      [
                                                                      'base_price']
                                                                  .toString(),
                                                          size: media.width *
                                                              twelve,
                                                        ),
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
                                                        MyText(
                                                          text: languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_distprice'],
                                                          size: media.width *
                                                              twelve,
                                                        ),
                                                        MyText(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          text: driverReq['requestBill']
                                                                      ['data'][
                                                                  'requested_currency_symbol'] +
                                                              ' ' +
                                                              driverReq['requestBill']
                                                                          [
                                                                          'data']
                                                                      [
                                                                      'distance_price']
                                                                  .toString(),
                                                          size: media.width *
                                                              twelve,
                                                        ),
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
                                                        MyText(
                                                          text: languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_timeprice'],
                                                          size: media.width *
                                                              twelve,
                                                        ),
                                                        MyText(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          text: driverReq['requestBill']
                                                                      ['data'][
                                                                  'requested_currency_symbol'] +
                                                              ' ' +
                                                              driverReq['requestBill']
                                                                          [
                                                                          'data']
                                                                      [
                                                                      'time_price']
                                                                  .toString(),
                                                          size: media.width *
                                                              twelve,
                                                        ),
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
                                                (driverReq['requestBill']
                                                                ['data'][
                                                            'cancellation_fee'] !=
                                                        0)
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyText(
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_cancelfee'],
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                              ),
                                                              MyText(
                                                                // ignore: prefer_interpolation_to_compose_strings
                                                                text: driverReq['requestBill']
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'requested_currency_symbol'] +
                                                                    ' ' +
                                                                    driverReq['requestBill']['data']
                                                                            [
                                                                            'cancellation_fee']
                                                                        .toString(),
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: media
                                                                        .width *
                                                                    0.03,
                                                                bottom: media
                                                                        .width *
                                                                    0.03),
                                                            height: 1.5,
                                                            color: const Color(
                                                                0xffE0E0E0),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                                (driverReq['requestBill']
                                                                ['data'][
                                                            'airport_surge_fee'] !=
                                                        0)
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyText(
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_surge_fee'],
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                              ),
                                                              MyText(
                                                                // ignore: prefer_interpolation_to_compose_strings
                                                                text: driverReq['requestBill']
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'requested_currency_symbol'] +
                                                                    ' ' +
                                                                    driverReq['requestBill']['data']
                                                                            [
                                                                            'airport_surge_fee']
                                                                        .toString(),
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: media
                                                                        .width *
                                                                    0.03,
                                                                bottom: media
                                                                        .width *
                                                                    0.03),
                                                            height: 1.5,
                                                            color: const Color(
                                                                0xffE0E0E0),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MyText(
                                                          text: languages[
                                                                      choosenLanguage]
                                                                  [
                                                                  'text_waiting_price'] +
                                                              ' (' +
                                                              driverReq['requestBill']
                                                                      ['data'][
                                                                  'requested_currency_symbol'] +
                                                              ' ' +
                                                              driverReq['requestBill']
                                                                          ['data']
                                                                      [
                                                                      'waiting_charge_per_min']
                                                                  .toString() +
                                                              ' x ' +
                                                              driverReq['requestBill']
                                                                          ['data']
                                                                      [
                                                                      'calculated_waiting_time']
                                                                  .toString() +
                                                              ' ' +
                                                              languages[choosenLanguage]
                                                                  ['text_mins'] +
                                                              ')',
                                                          size: media.width *
                                                              twelve,
                                                        ),
                                                        MyText(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          text: driverReq['requestBill']
                                                                      ['data'][
                                                                  'requested_currency_symbol'] +
                                                              ' ' +
                                                              driverReq['requestBill']
                                                                          [
                                                                          'data']
                                                                      [
                                                                      'waiting_charge']
                                                                  .toString(),
                                                          size: media.width *
                                                              twelve,
                                                        ),
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
                                                (driverReq['requestBill']
                                                                ['data'][
                                                            'admin_commision'] !=
                                                        0)
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyText(
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_convfee'],
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                              ),
                                                              MyText(
                                                                // ignore: prefer_interpolation_to_compose_strings
                                                                text: driverReq['requestBill']
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'requested_currency_symbol'] +
                                                                    ' ' +
                                                                    driverReq['requestBill']['data']
                                                                            [
                                                                            'admin_commision']
                                                                        .toString(),
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: media
                                                                        .width *
                                                                    0.03,
                                                                bottom: media
                                                                        .width *
                                                                    0.03),
                                                            height: 1.5,
                                                            color: const Color(
                                                                0xffE0E0E0),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                                (driverReq['requestBill']
                                                                ['data'][
                                                            'promo_discount'] !=
                                                        null)
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyText(
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_discount'],
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              MyText(
                                                                // ignore: prefer_interpolation_to_compose_strings
                                                                text: driverReq['requestBill']
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'requested_currency_symbol'] +
                                                                    ' ' +
                                                                    driverReq['requestBill']['data']
                                                                            [
                                                                            'promo_discount']
                                                                        .toString(),
                                                                size: media
                                                                        .width *
                                                                    twelve,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: media
                                                                        .width *
                                                                    0.03,
                                                                bottom: media
                                                                        .width *
                                                                    0.03),
                                                            height: 1.5,
                                                            color: const Color(
                                                                0xffE0E0E0),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MyText(
                                                          text: languages[
                                                                  choosenLanguage]
                                                              ['text_taxes'],
                                                          size: media.width *
                                                              twelve,
                                                        ),
                                                        MyText(
                                                          text:
                                                              // ignore: prefer_interpolation_to_compose_strings
                                                              driverReq['requestBill']
                                                                          [
                                                                          'data']
                                                                      [
                                                                      'requested_currency_symbol'] +
                                                                  ' ' +
                                                                  '${driverReq['requestBill']['data']['service_tax']}',
                                                          size: media.width *
                                                              twelve,
                                                        ),
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
                                                        MyText(
                                                          text: languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_totalfare'],
                                                          size: media.width *
                                                              twelve,
                                                        ),
                                                        MyText(
                                                          text:
                                                              // ignore: prefer_interpolation_to_compose_strings
                                                              '${driverReq['requestBill']['data']['requested_currency_symbol']} ' +
                                                                  driverReq['requestBill']
                                                                              [
                                                                              'data']
                                                                          [
                                                                          'total_amount']
                                                                      .toString(),
                                                          size: media.width *
                                                              twelve,
                                                        ),
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
                                                SizedBox(
                                                  height: media.height * 0.02,
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              if (_error != '')
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      bottom: media.height * 0.02),
                                  child: Text(
                                    _error,
                                    style: GoogleFonts.notoSans(
                                        fontSize: media.width * fourteen,
                                        color: Colors.red),
                                    maxLines: 1,
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        (driverReq['payment_opt'] == '1')
                                            ? languages[choosenLanguage]
                                                ['text_cash']
                                            : (driverReq['payment_opt'] == '2')
                                                ? languages[choosenLanguage]
                                                    ['text_wallet']
                                                : languages[choosenLanguage]
                                                    ['text_card'],
                                        style: GoogleFonts.notoSans(
                                            fontSize: media.width * sixteen,
                                            color: buttonColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: media.width * 0.02,
                                      ),
                                      MyText(
                                        text: driverReq['requestBill']['data']
                                            ['requested_currency_symbol'],
                                        size: media.width * sixteen,
                                      ),
                                      MyText(
                                        text:
                                            ' ${driverReq['requestBill']['data']['total_amount']}',
                                        size: media.width * twenty,
                                        fontweight: FontWeight.w800,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: media.width * 0.02,
                                  ),
                                  Expanded(
                                      child: (driverReq['payment_opt'] == '0' &&
                                              driverReq['is_paid'] == 0)
                                          ? Container(
                                              height: media.width * 0.12,
                                              // width: media.width * 0.9,
                                              padding: EdgeInsets.only(
                                                  left: media.width * 0.03,
                                                  right: media.width * 0.03),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.08),
                                                  color: borderLines),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    languages[choosenLanguage][
                                                        'text_waitingforpayment'],
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: media.width *
                                                            fourteen,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(
                                                    width: media.width * 0.02,
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          media.width * 0.05,
                                                      width: media.width * 0.05,
                                                      child:
                                                          const CircularProgressIndicator())
                                                ],
                                              ),
                                            )
                                          : Button(
                                              onTap: () async {
                                                if (driverReq['is_paid'] == 0) {
                                                  setState(() {
                                                    _error = '';
                                                    _isLoading = true;
                                                  });
                                                  var val =
                                                      await paymentReceived();
                                                  if (val == 'logout') {
                                                    navigateLogout();
                                                  } else if (val == 'success') {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _isLoading = false;
                                                      _error = val.toString();
                                                    });
                                                  }
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Review()));
                                                }
                                              },
                                              text: (driverReq['is_paid'] == 0)
                                                  ? languages[choosenLanguage]
                                                      ['text_payment_received']
                                                  : languages[choosenLanguage]
                                                      ['text_confirm']))
                                ],
                              ),
                            ],
                          )
                        : Container(),
                  ),
                  //loader
                  (_isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container(),
                ],
              );
            }),
      ),
    );
  }
}
