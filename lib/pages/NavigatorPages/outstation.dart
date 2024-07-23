import 'package:flutter/material.dart';
import 'package:flutter_driver/functions/functions.dart';
import 'package:flutter_driver/pages/NavigatorPages/historyoutstationdetails.dart';
import 'package:flutter_driver/pages/loadingPage/loading.dart';
import 'package:flutter_driver/pages/login/landingpage.dart';
import 'package:flutter_driver/pages/login/login.dart';
import 'package:flutter_driver/pages/noInternet/nointernet.dart';
import 'package:flutter_driver/styles/styles.dart';
import 'package:flutter_driver/translation/translation.dart';
import 'package:flutter_driver/widgets/widgets.dart';

class OutStation extends StatefulWidget {
  const OutStation({super.key});

  @override
  State<OutStation> createState() => _OutStationState();
}

class _OutStationState extends State<OutStation> {
  dynamic _shimmer;
  @override
  void initState() {
    // _isLoading = true;
    outstationfun();
    historyFiltter = '';
    _shimmer = AnimationController.unbounded(vsync: MyTickerProvider())
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  dynamic selectedHistory;

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

//get history
  outstationfun() async {
    if (mounted) {
      setState(() {
        outStationList.clear();
        for (var i = 0; i < 10; i++) {
          outStationList.add({});
        }
      });
    }
    var val = await outStationListFun();
    if (val == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        child: Directionality(
      textDirection:
          (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    media.width * 0.05,
                    media.width * 0.05 + MediaQuery.of(context).padding.top,
                    media.width * 0.05,
                    media.width * 0.05),
                color: page,
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios, color: textColor)),
                    Expanded(
                      child: MyText(
                        textAlign: TextAlign.center,
                        text: languages[choosenLanguage]['text_outstation'],
                        size: media.width * twenty,
                        maxLines: 1,
                        fontweight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: media.width * 1,
                color: (outStationList.isEmpty)
                    ? (!isDarkTheme)
                        ? Colors.white
                        : Colors.black
                    : (isDarkTheme)
                        ? Colors.grey
                        : Colors.grey.withOpacity(0.2),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: media.width * 0.02,
                      ),
                      (outStationList.isNotEmpty)
                          ? Column(
                              children: outStationList
                                  .asMap()
                                  .map((i, value) {
                                    return MapEntry(
                                        i,
                                        (outStationList[i].isEmpty)
                                            ? AnimatedBuilder(
                                                animation: _shimmer,
                                                builder: (context, widget) {
                                                  return ShaderMask(
                                                      blendMode:
                                                          BlendMode.srcATop,
                                                      shaderCallback: (bounds) {
                                                        return LinearGradient(
                                                                colors:
                                                                    shaderColor,
                                                                stops:
                                                                    shaderStops,
                                                                begin:
                                                                    shaderBegin,
                                                                end: shaderEnd,
                                                                tileMode:
                                                                    TileMode
                                                                        .clamp,
                                                                transform: SlidingGradientTransform(
                                                                    slidePercent:
                                                                        _shimmer
                                                                            .value))
                                                            .createShader(
                                                                bounds);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.all(
                                                            media.width * 0.03),
                                                        padding: EdgeInsets.all(
                                                            media.width * 0.03),
                                                        decoration: BoxDecoration(
                                                            color: page,
                                                            borderRadius: BorderRadius
                                                                .circular(media
                                                                        .width *
                                                                    0.02)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.15,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.15,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.02,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.2,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.2,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.02,
                                                            ),
                                                            const MySeparator(),
                                                            // Container(
                                                            //   height: 1,
                                                            //   width: media.width * 0.8,
                                                            //   color: hintColor,
                                                            // ),
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.02,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.05,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: hintColor
                                                                          .withOpacity(
                                                                              0.5)),
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.05,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height: media
                                                                            .width *
                                                                        0.05,
                                                                    color: hintColor
                                                                        .withOpacity(
                                                                            0.5),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.03,
                                                            ),

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.05,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: hintColor
                                                                          .withOpacity(
                                                                              0.5)),
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.05,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height: media
                                                                            .width *
                                                                        0.05,
                                                                    color: hintColor
                                                                        .withOpacity(
                                                                            0.5),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                })
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OutStationDetails(
                                                                    requestId:
                                                                        outStationList[i]
                                                                            [
                                                                            'id'],
                                                                    i: i,
                                                                  )));
                                                    },
                                                    child: Container(
                                                      width: media.width * 0.9,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              media.width *
                                                                  0.025,
                                                              media.width *
                                                                  0.02,
                                                              media.width *
                                                                  0.025,
                                                              media.width *
                                                                  0.05),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: page,
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.02,
                                                          left: media.width *
                                                              0.03,
                                                          right: media.width *
                                                              0.03),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: MyText(
                                                                    text: outStationList[i]
                                                                            [
                                                                            'vehicle_type_name']
                                                                        .toString(),
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w600,
                                                                    size: media
                                                                            .width *
                                                                        fourteen),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  MyText(
                                                                      text: outStationList[i]
                                                                              [
                                                                              'trip_start_time']
                                                                          .toString(),
                                                                      color:
                                                                          hintColor,
                                                                      fontweight:
                                                                          FontWeight
                                                                              .bold,
                                                                      size: media
                                                                              .width *
                                                                          twelve),
                                                                  if (outStationList[
                                                                              i]
                                                                          [
                                                                          'is_round_trip'] ==
                                                                      1)
                                                                    MyText(
                                                                        // ignore: prefer_interpolation_to_compose_strings
                                                                        text: (' - ' + outStationList[i]['return_time'])
                                                                            .toString(),
                                                                        color:
                                                                            hintColor,
                                                                        fontweight:
                                                                            FontWeight
                                                                                .bold,
                                                                        size: media.width *
                                                                            twelve),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MyText(
                                                                text: (outStationList[i]
                                                                            [
                                                                            'is_round_trip'] ==
                                                                        1)
                                                                    ? languages[
                                                                            choosenLanguage]
                                                                        [
                                                                        'text_round_trip']
                                                                    : languages[
                                                                            choosenLanguage]
                                                                        [
                                                                        'text_one_way_trip'],
                                                                size: media
                                                                        .width *
                                                                    sixteen,
                                                                color: Colors
                                                                    .orange,
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  MyText(
                                                                    text: (outStationList[i]['payment_opt'] ==
                                                                            '1')
                                                                        ? languages[choosenLanguage]
                                                                            [
                                                                            'text_cash']
                                                                        : (outStationList[i]['payment_opt'] ==
                                                                                '2')
                                                                            ? languages[choosenLanguage]['text_wallet']
                                                                            : (outStationList[i]['payment_opt'] == '0')
                                                                                ? languages[choosenLanguage]['text_card']
                                                                                : '',
                                                                    size: media
                                                                            .width *
                                                                        fourteen,
                                                                    color:
                                                                        textColor,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.02,
                                                                  ),
                                                                  MyText(
                                                                      text: outStationList[i]
                                                                              [
                                                                              'requested_currency_symbol'] +
                                                                          ' ' +
                                                                          outStationList[i]['accepted_ride_fare']
                                                                              .toString(),
                                                                      fontweight:
                                                                          FontWeight
                                                                              .bold,
                                                                      size: media
                                                                              .width *
                                                                          fourteen),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          const MySeparator(),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .green
                                                                        .withOpacity(
                                                                            0.4)),
                                                                child:
                                                                    Container(
                                                                  height: media
                                                                          .width *
                                                                      0.025,
                                                                  width: media
                                                                          .width *
                                                                      0.025,
                                                                  decoration: const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.03,
                                                              ),
                                                              Expanded(
                                                                child: MyText(
                                                                  text: outStationList[
                                                                          i][
                                                                      'pick_address'],
                                                                  maxLines: 1,
                                                                  size: media
                                                                          .width *
                                                                      twelve,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.03,
                                                          ),
                                                          if (outStationList[i][
                                                                  'drop_address'] !=
                                                              null)
                                                            Row(
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
                                                                  child: Icon(
                                                                    Icons
                                                                        .location_on,
                                                                    color: const Color(
                                                                        0xFFFF0000),
                                                                    size: media
                                                                            .width *
                                                                        eighteen,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.03,
                                                                ),
                                                                Expanded(
                                                                  child: MyText(
                                                                    text: outStationList[
                                                                            i][
                                                                        'drop_address'],
                                                                    maxLines: 1,
                                                                    size: media
                                                                            .width *
                                                                        twelve,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                  })
                                  .values
                                  .toList(),
                            )
                          : SizedBox(
                              height: media.height * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: media.width * 0.6,
                                    width: media.width * 0.6,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage((isDarkTheme)
                                                ? 'assets/images/nodatafounddark.gif'
                                                : 'assets/images/nodatafound.gif'),
                                            fit: BoxFit.contain)),
                                  ),
                                  SizedBox(
                                    width: media.width * 0.6,
                                    child: MyText(
                                        text: languages[choosenLanguage]
                                            ['text_noDataFound'],
                                        textAlign: TextAlign.center,
                                        fontweight: FontWeight.w800,
                                        size: media.width * sixteen),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ))
            ],
          ),

          (_isLoading)
              ? const Positioned(top: 0, child: Loading())
              : Container(),
          //no internet
          (internet == false)
              ? Positioned(
                  top: 0,
                  child: NoInternet(
                    onTap: () {
                      setState(() {
                        internetTrue();
                      });
                    },
                  ))
              : Container(),
        ],
      ),
    ));
  }
}
